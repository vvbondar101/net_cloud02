

variable "vm_resources" {
  type = map
  default = {
    core = 2
    memory = 4
    core_fraction = 20
}
}

variable "metadata" {
  type = map
  default = {
    serial-port-enable = 1
    ssh-keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZKAR4FPrx9zLO6awWqE8B9Y2M15S74R1cvkorfQy3Y vvbondar101@gmail.com"
}
}

variable "vm_premtible" {
  type        = bool
  default     = true
  description = "VM premtible"
}
variable "vm_nat" {
  type        = bool
  default     = true
  description = "VM NAT enable"
}

