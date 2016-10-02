provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "jmeter_cluster" {
  source = "jmeter_cluster"

  aws_region = "${var.aws_region}"
  slave_ssh_public_key_file = "ssh/loadServer.pub"
  master_ssh_private_key_file = "ssh/loadServer"
  master_ssh_public_key_file = "ssh/loadServer.pub"
  jmx_script_file = "script.jmx"
}