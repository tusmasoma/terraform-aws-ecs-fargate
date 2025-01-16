terraform {
  backend "s3" {
    bucket         = "tf-s3-state-lock-example-tfstate"
    key            = "terraform.tfstate"
    use_lockfiles  = true
  }
}