provider "aws" {
  region  = var.aws_region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "bucket-states-dev"
    key            = "workspace/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-dev-state-table"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.dynamodb_table_dev
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}

module "lambda_function" {
  source = "./modules/lambda"

  aws_region         = var.aws_region
  bucket_state       = var.bucket_state
  dynamodb_table_dev = var.dynamodb_table_dev
}
