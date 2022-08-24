variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "db_subnet_name" {
  type = string
}

variable "deletion_protection" {
  default = false
}

variable "common_tags" {

}

variable "prefix" {
  type = string
}
