variable "region" {
  type    = string
  default = "us-east-2"
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "default_region" {
  type    = string
  default = "us-east-2"
}

variable "prefix" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_key_name" {
  type = string
}

