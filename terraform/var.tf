variable "acm_arn" {
  description = "The AWS ARN for the SSL certificate to be used on the LB"
}

variable "profile" {
  description = "The AWS Profile to be deployed against"
}

########################### Network Config ################################
variable "vpc_id" {
  description = "ID of the VPC to use"
}

variable "private_subnets" {
  description = "IDs of the Private Subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "IDs of Public Subnets"
  type        = list(string)
}

variable "hosted_zone" {
  description = "Hosted zone name to be used as the base"
}

variable "dns_name" {
  description = "Building on the hosted zone, what URL should the address be reachable at?"
}

variable "app_hosted_zone" {
  description = "Hosted zone name to be used as the base for the app Internal LB"
}

variable "app_host_zone_private" {
  description = "Is the app hosted Zone private"
  default     = false
}

variable "app_dns_name" {
  description = "Building on the hosted zone, what URL should the address be reachable at? This may be private for extra security"
}

variable "db_dns_name" {
  description = "Building on the hosted zone, what URL should the address be reachable at? This may be private for extra security"
}
########################### Containers ################################

variable "moodle_image" {
  description = "What image should be used for the Moodle Container"
}

variable "moodle_skip_bootstrap" {
  description = "Should the initial bootstrap be skipped when starting Moodle?"
  default     = "no"
}

variable "moodle_sitename" {
  description = "Name for the Moodle Site"
  default     = "CodeRunner Playpen"
}

variable "app_image" {
  description = "What image should be used for the app container(s)"
  default     = "trampgeek/appinabox:latest"
}

########################### DB Access ################################