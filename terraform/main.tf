terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.7"
    }
  }
  required_version = ">= 0.13.3"
}

provider "aws" {
  profile = var.profile
  region  = "ap-southeast-2"
  ignore_tags {
    key_prefixes = ["Auto"]
  }
}

# Obviously don't hard code the secure values
locals {
  app_name         = "NodeWeb"
  lifecycle_state  = "PoC"
  subnet_count     = length(var.private_subnets)
  ecs_cluster_name = "${local.app_name}-cluster"
  cw_log_group     = "/${local.app_name}/Containers/logs"
  db_name          = "NodeWebdb"
  db_user          = "NodeWeb"
  common_tags = {
    "Application"     = "NodeWeb"
    "ApplicationRole" = "Docker Containers"
    "BusinessService" = "Collaboration Services"
    "Department"      = "Computer Science"
    "Environment"     = local.lifecycle_state
    "ProjectCode"     = "829206"
    "CostCentre"      = "8871"
    "Faculty"         = "Connect"
    "WikiLink"        = "TBC"
  }
}

resource "aws_cloudwatch_log_group" "global" {
  name              = local.cw_log_group
  retention_in_days = 7
}

data "aws_caller_identity" "current" {}