variable "vpc_cidr" {
  description = "used to store data about my vpc"
  type = string
  default = "10.0.0.0/16"
}
variable "public_subnet_count" {
  description = "number of public subnets"
  type = number
  default = 2
}

variable "private_subnet_count" {
  description = "number of private subnet"
  type = number
  default = 2

}

variable "vpc_tenancy" {
  description = "used to store a value"
  type = string
  default = "default"
}

variable "name" {
  description = "used to store the name of the user who created the resource"
  type = string
  default = "Warren"
}

# variable "default_tag" {
# description = "bird is the word"
# type = map("Bird","Word")

# }

variable "subnet_bits" {
  description = "used to determine the size of the subnets"
  type = number
  # add 8 bits to the subnet mask
  default = 8

}

variable "az_zones" {
  type = list
  description = "AZs"


}

# element(list, index)