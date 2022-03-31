variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "jabprojectone"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "EAST US"
}

variable "admin" {
  description = "Admin User Name"
  default = "projectone"
}

variable "password" {
  description = "The default password"
  default = "H@(k3rM0n3Y!"
}

variable "imagegroup" {
  description = "This is the resource group from the packer deployment"
  default = "jbprojectone"
}

variable "virtualimage" {
  description = "This is the virtual machine/image from the packer deployment"
  default = "jbprojectone"
}

variable "vmcount" {
  description = "Allow only minimum amount of VMs to be deployed"
  default = 2
}
