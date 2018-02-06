variable "aws_region" {}

variable "availability_zones" {
  type = "list"
}

variable "system_name" {
  default = "datomic"
}

variable "vpc_id" {
}

variable "subnet_ids" {
  type = "list"
}

variable "cidr" {}

variable "transactor_instance_type" {
  default = "t2.large"
}

variable "instance_count" {
  default = "1"
}

variable "transactor_memory_index_max" {
  default = "512m"
}

variable "transactor_memory_index_threshold" {
  default = "32m"
}

variable "transactor_object_cache_max" {
  default = "1g"
}

variable "transactor_xmx" {
  default = "4g"
}

variable "datomic_license" {}

variable "transactor_java_opts" {
  default = ""
}

variable "cloudwatch_dimension" {
  default = "Datomic"
}

variable "memcached_uri" {}

variable "protocol" {}

variable "ami" {}

variable "key_name" {}

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

variable "aws_dynamodb_read_capacity" {
  default = 5
}

variable "aws_dynamodb_write_capacity" {
  default = 5
}

variable "aws_account_id" {
  default = ""
}
