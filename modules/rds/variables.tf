variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "source_sg_ids" {
  description = "The IDs of the security groups to allow access from"
  type        = list(string)
}

variable "env" {
  description = "The environment to deploy to"
  type        = string
}

variable "system" {
  description = "The system name"
  type        = string
}

variable "created_by" {
  description = "Tag description for resources made by terraform"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "aurora"
}

variable "engine_version" {
  description = "The database engine version to use"
  type        = string
  default     = "5.6.10a"
}

variable "family" {
  description = "The database engine family to use"
  type        = string
  default     = "aurora-mysql5.7"
}

variable "instance_type" {
  description = "The instance type to use from https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html"
  type        = string
  default     = "db.t3.small"
}

variable "instance_count" {
  description = "The number of instances to use"
  type        = number
  default     = 1
}

variable "database_name" {
  description = "The name of the database"
  type        = string
}

variable "master_username" {
  description = "The master username"
  type        = string
}

variable "rds_params" {
  description = "The RDS parameters"
  type        = map(string)
  default = {
    # Aurora MySQL のパラメータグループ
    max_connections                = "3000"               # Aurora に合わせた高い同時接続数
    character_set_server           = "utf8mb4"            # サーバーの文字セット
    collation_server               = "utf8mb4_unicode_ci" # サーバーの照合順序
    innodb_flush_log_at_trx_commit = "2"                  # パフォーマンス向上
    query_cache_type               = "0"                  # クエリキャッシュ無効化（推奨設定）
    slow_query_log                 = "1"                  # スロークエリログを有効化
    long_query_time                = "1"                  # スロークエリの基準時間（秒）
    binlog_format                  = "ROW"                # バイナリログ形式
  }
}

# variable "rds_params" {
#   description = "The RDS parameters"
#   type        = map(string)
#   default = {
#     # Aurora PostgreSQL のパラメータグループ
#     work_mem                     = "4MB"           # 各クエリ用のメモリ量
#     maintenance_work_mem         = "64MB"          # メンテナンス用メモリ量
#     max_connections              = "500"           # 同時接続数の最大値
#     shared_buffers               = "256MB"         # バッファメモリ量
#     effective_cache_size         = "1024MB"        # キャッシュメモリ量
#     logging_collector            = "on"            # ログ収集を有効化
#     log_min_duration_statement   = "1000"          # ログに記録するクエリの最小実行時間（ms）
#     log_statement                = "none"          # クエリログの詳細度
#     timezone                     = "UTC"           # タイムゾーン
#   }
# }
