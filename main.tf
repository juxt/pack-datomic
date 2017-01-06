# Variables -----------------------------

variable "aws_account_id" {}

variable "aws_profile" {}

variable "aws_region" {}

variable "sql_user" {}

variable "sql_password" {}

variable "sql_url" {}

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

module "staging_datomic" {
  source             = "./modules/datomic"
  aws_region         = "${var.aws_region}"
  availability_zones = ["${var.availability_zone}"]
  system_name        = "${var.system_name}"
  peer_role          = "${module.staging_iam.instance_role_name}"
  security_group_ids = ["${module.staging_vpc.internal_inbound_id}"]
  datomic_license    = "${var.datomic_license}"

  memcached_uri    = ""
  sql_url          = "${var.sql_url}"
  sql_user         = "${var.sql_user}"
  sql_password     = "${var.sql_password}"
}
