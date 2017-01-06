variable "aws_region" {}

variable "availability_zones" {
  type = "list"
}

variable "system_name" {
  default = "datomic"
}

variable "transactor_instance_type" {
  default = "c4.4xlarge"
}

variable "instance_count" {
  default = "1"
}

variable "transactor_memory_index_max" {
  default = "2048m"
}

variable "transactor_memory_index_threshold" {
  default = "32m"
}

variable "transactor_object_cache_max" {
  default = "4g"
}

variable "transactor_xmx" {
  default = "10g"
}

variable "datomic_license" {}

variable "transactor_java_opts" {
  default = ""
}

variable "cloudwatch_dimension" {
  default = "Datomic"
}

variable "memcached_uri" {}

variable "sql_user" {}

variable "sql_password" {}

variable "sql_url" {}

variable "ami" {}

variable "key_name" {}
