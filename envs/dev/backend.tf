// TODO: 一旦、ローカルのterraform.tfstateを使用するためコメントアウト
# terraform {
#   backend "s3" {
#     bucket         = "tf-s3-state-lock-example-tfstate"
#     key            = "terraform.tfstate"
#     dynamodb_table = "example-state-lock-table"
#   }
# }