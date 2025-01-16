## Design

このアーキテクチャは、AWSでのコンテナベースのアプリケーションを運用するための設計であり、高可用性、スケーラビリティ、およびセキュリティを重視しています。

<p align="center">
  <img src="./images/aws-ecs-on-fargate-arc.png" alt="ECS Design" width="80%">
</p>

## Module Design
モジュール設計は、Standard Module Structure に従っています。
```
modules/
├── alb
│   ├── README.md
│   ├── alb.tf
│   ├── listener.tf
│   ├── outputs.tf
│   ├── target_group.tf
│   └── variables.tf
├── ecs
│   ├── README.md
│   ├── cloudwatch_log.tf
│   ├── cluster.tf
│   ├── outputs.tf
│   ├── service.tf
│   ├── task_definition.tf
│   └── variables.tf
├── network
│   ├── README.md
│   ├── igw.tf
│   ├── ngw.tf
│   ├── outputs.tf
│   ├── route_table.tf
│   ├── subnet.tf
│   ├── variables.tf
│   └── vpc.tf
├── rds
│   ├── README.md
│   ├── cluster.tf
│   ├── instance.tf
│   ├── outputs.tf
│   └── variables.tf
└── route53
    ├── README.md
    ├── acm.tf
    ├── outputs.tf
    ├── route53.tf
    └── variables.tf
```
variables.tfとoutputs.tfは空でも作成します。
## Managing tfstate Files

tfstateファイルを管理する上で、以下の3つを守ってください。

- **tfstateファイルは必ずリモート管理**

- **tfstateファイルをロックすることでデプロイの衝突からインフラを守る**

- **tfstateファイルは環境ごとに分ける**

### **tfstateファイルは必ずリモート管理**
tfstateファイルをローカルで保存すべきでない理由は以下の通りです：

- **セキュリティリスク**:
    
    tfstateファイルには、アクセスキーや機密情報などのセキュアな情報が含まれる場合があります。ローカル管理では、これらの情報が漏洩するリスクが高まります。
    
- **チーム開発での競合**:
    
    複数の開発者が同じインフラを管理する場合、ローカル管理では各開発者が異なるtfstateファイルを持つことになり、実際のリモートインフラ構成が正確に共有されません。その結果、意図しないリソースの変更や削除が発生する可能性があります。
    
- **データの一貫性の確保**:
    
    リモート管理を使用することで、全員が同じtfstateファイルを利用し、最新の状態を常に共有できます。

#### 推奨されるリモート管理先：
- **AWS**: S3
- **Azure**: Azure Storage
- **GCP**: GCS（Google Cloud Storage）

#### 必須設定:
- バージョニング
- 暗号化
- ブロックパブリックアクセス

> [!WARNING]
> **tfstateファイルをgitでは管理すべきではない**
> 
> 理由：
> - **機密情報の漏洩リスク**: アクセスキーやパスワードが誤って公開される可能性がある。
> - **競合による不整合**: チームでの同時作業が状態ファイルの競合を引き起こす。
> - **リポジトリの肥大化**: 頻繁な更新が履歴管理を無意味に肥大化させる。
> - **適切な機能不足**: Gitにはリモートバックエンドのようなロック機能や暗号化機能がない。
> 
> などなど

> [!CAUTION]
> **tfstateファイルを保存する共有ストレージをterraformで作ってはいけない**
> 
> 理由：
> - **鶏と卵の問題（ブートストラップ問題）**
>     - Terraformの`backend`設定（例: S3, Azure Blob Storage, GCS）は、Terraformによるリソースの作成前に必要です。
>     - 共有ストレージをTerraformで管理する場合、その状態を保存する`tfstate`ファイルの保存場所が必要になります。この状況は「鶏と卵」のような矛盾を引き起こします。
> - **安定性と信頼性の確保**
>     - Terraformで共有ストレージを管理すると、そのストレージが削除されるリスクがあります。特に誤って`terraform destroy`を実行した場合、状態ファイルそのものが失われる可能性があります。
> 
> などなど
>
> **推奨**： tfstateファイル保存用のストレージは別のAWSアカウントで管理。

### **tfstateファイルをロックすることでデプロイの衝突からインフラを守る**
tfstateファイルをロックする理由は以下です。

- **チーム開発での競合**:
    
    複数の開発者が同じインフラを管理している場合、同時に`terraform apply`や`terraform import`を実行すると、リソースとtfstateファイルの間で不整合が発生する可能性があります。このような競合は、共有データに対する同時操作が原因で発生し、予期しないインフラ変更や障害につながることがあります。

#### ロック機構を設ける方法:

- **AWSの場合**:

  Terraform の Backend に S3 を使用している場合、 State Lock を有効化するためには DynamoDB テーブルを用意する必要があります。(v1.10以前)
    ```hcl
    terraform {
      backend "s3" {
        bucket         = "tf-s3-state-lock-example-tfstate"
        key            = "terraform.tfstate"
        dynamodb_table = "example-state-lock-table" # これが必要
      }
    }
    ```

    Terraform v1.10 からは、 S3 Backend の設定に use_lockfile = true を追加するだけで State Lock を有効化することができるようになります。 ( DynamoDB テーブルは不要 )

    ```diff
     terraform {
       backend "s3" {
         bucket       = "tf-s3-state-lock-example-tfstate"
         key          = "terraform.tfstate"
    +    use_lockfile = true # これだけで State Lock が有効化される
    -    dynamodb_table = "example-state-lock-table" # こっちは不要
      }
    }
    ```

### **tfstateファイルは環境ごとに分ける**
tfstateファイルを環境ごとに分けるべき理由は以下です。

- **環境間の影響を防ぐため**

    - 開発環境、ステージング環境、本番環境など、複数の環境を1つの`tfstate`ファイルで管理すると、環境間での影響を防ぐのが困難になります。

    - 誤って本番環境に対して開発環境の変更を適用するリスクがあります。

などなど

## Deployment Pipeline
TODO: 執筆

## Continuous Apply Strategy
TODO: 執筆
