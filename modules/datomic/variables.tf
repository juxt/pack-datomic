variable "aws_region" {}

variable "availability_zones" {
  type = "list"
}

variable "system_name" {
  default = "datomic"
}

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

variable "sql_user" {
  default = ""
}

variable "sql_password" {
  default = ""
}

variable "sql_url" {
  default = ""
}

variable "ami" {}

variable "key_name" {}
