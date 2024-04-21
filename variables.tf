variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "bucket_state" {
  description = "The name of the S3 bucket for storing Lambda code and Terraform state"
  type =  string
  default = "bucket-states-dev"
}

variable "dynamodb_table_dev" {
  description = "The name of the DynamoDB table for state locking"
  type =  string
  default = "terraform-dev-state-table"
}
