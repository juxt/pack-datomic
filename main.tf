# Variables -----------------------------

variable "aws_profile" {}

variable "aws_region" {}

variable "availability_zone" {}

variable "system_name" {}

variable "datomic_license" {}

variable "transactor_key_name" {}

variable "transactor_ami" {}

variable "datomic_protocol" {
  default = "dev"
}

# Providers -----------------------------

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

# Modules -----------------------------

module "staging_datomic" {
  source             = "./modules/datomic"
  aws_region         = "${var.aws_region}"
  availability_zones = ["${var.availability_zone}"]
  system_name        = "${var.system_name}"
  datomic_license    = "${var.datomic_license}"
  key_name           = "${var.transactor_key_name}"
  ami                = "${var.transactor_ami}"
  memcached_uri      = ""
  protocol           = "${var.datomic_protocol}"

  # Storage Specific SQL:
  sql_user           = "${var.sql_user}"
  sql_password       = "${var.sql_password}"
  sql_url            = "${var.sql_url}"

  # Storage Specific Dynamo:
  aws_dynamodb_table = "${var.aws_dynamodb_table}"
  aws_dynamodb_region = "${var.aws_dynamodb_region}"
  aws_account_id = "${var.aws_account_id}"
}
