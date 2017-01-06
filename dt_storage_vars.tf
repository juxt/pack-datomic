# SQL Only --------------------------------

variable "sql_user" {
  default = ""
}

variable "sql_password" {
  default = ""
}

variable "sql_url" {
  default = ""
}

# Dynamo Only --------------------------------

variable "aws_dynamodb_table" {
  default = ""
}

variable "aws_dynamodb_region" {
  default = ""
}

variable "aws_account_id" {
  default = ""
}
