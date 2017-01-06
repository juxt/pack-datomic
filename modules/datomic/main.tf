# transactor role. ec2 instances can assume the role of a transactor
resource "aws_security_group" "internal_inbound" {
  name        = "internal_inbound"
  description = "Allow access to Datomic Transactor"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    # ideally

    # cidr_blocks = ["10.0.0.0/14"]
  }

  ingress {
    from_port   = 4334
    to_port     = 4334
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Need to output S3 logs, TODO LOCK THIS DOWN more
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.system_name}_transactors"
  }
}

resource "aws_iam_role" "transactor" {
  name = "transactor"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

# policy with write access to cloudwatch
resource "aws_iam_role_policy" "transactor_cloudwatch" {
  name = "cloudwatch_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:PutMetricDataBatch"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      },
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# s3 bucket for the transactor logs
resource "aws_s3_bucket" "transactor_logs" {
  bucket = "${var.system_name}-datomic-logs"

  lifecycle {
    prevent_destroy = true
  }
}

# policy with write access to the transactor logs
resource "aws_iam_role_policy" "transactor_logs" {
  name = "s3_logs_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}",
        "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}/*"
      ]
    }
  ]
}
EOF
}

# instance profile which assumes the transactor role
resource "aws_iam_instance_profile" "transactor" {
  name  = "datomic"
  roles = ["${aws_iam_role.transactor.name}"]
}

# transactor launch config
resource "aws_launch_configuration" "transactor" {
  name_prefix          = "datomic-transactor-"
  image_id             = "${var.ami}"
  instance_type        = "${var.transactor_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.transactor.name}"
  security_groups      = ["${aws_security_group.internal_inbound.id}"]
  user_data            = "${data.template_file.transactor_user_data.rendered}"
  key_name             = "${var.key_name}"

  #  associate_public_ip_address = true

  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "transactor_user_data" {
  template = "${file("${path.module}/files/run-transactor.sh")}"

  vars {
    xmx                    = "${var.transactor_xmx}"
    java_opts              = "${var.transactor_java_opts}"
    region                 = "${var.aws_region}"
    transactor_role        = "${aws_iam_role.transactor.name}"
    memory_index_max       = "${var.transactor_memory_index_max}"
    s3_log_bucket          = "${aws_s3_bucket.transactor_logs.id}"
    memory_index_threshold = "${var.transactor_memory_index_threshold}"
    object_cache_max       = "${var.transactor_object_cache_max}"
    license-key            = "${var.datomic_license}"
    cloudwatch_dimension   = "${var.cloudwatch_dimension}"
    memcached_uri          = "${var.memcached_uri}"

    protocol = "${var.protocol}"

    # For SQL only:
    sql_user     = "${var.sql_user}"
    sql_password = "${var.sql_password}"
    sql_url      = "${var.sql_url}"

    # For Dynamo only:
    aws_dynamodb_table = "${var.aws_dynamodb_table}"
    aws_dynamodb_region = "${var.aws_dynamodb_region}"
  }
}

# autoscaling group for launching transactors
resource "aws_autoscaling_group" "datomic_asg" {
  availability_zones   = "${var.availability_zones}"
  name                 = "${var.system_name}_transactors"
  max_size             = "${var.instance_count}"
  min_size             = "${var.instance_count}"
  launch_configuration = "${aws_launch_configuration.transactor.name}"

  tag {
    key                 = "Name"
    value               = "${var.system_name}-transactor"
    propagate_at_launch = true
  }

  tag {
    key                 = "Type"
    value               = "Datomic"
    propagate_at_launch = true
  }
}
