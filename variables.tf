variable "image-01" {
  type = string
  default = "nginx:latest"
}
variable "name-01" {
  type = string
  default = "name01"
}
variable "essential-01" {
  type    = bool
  default = true
}
variable "containerPort-01" {
  type = number
  default = 80
}
variable "hostPort-01" {
  type = number
  default = 80
}
variable "bucket_name" {
  type    = string
  default = "proyecto-finaljd"
}