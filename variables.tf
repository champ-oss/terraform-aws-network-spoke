variable "name" {
  description = "Used to label all resources"
  type        = string
  default     = "default"
}

variable "tags" {
  description = "Additional tags to be applied to all resources"
  default     = {}
  type        = map(string)
}

variable "subnet_size" {
  description = "How many bits to use for creating each subnet."
  default     = 3
  type        = number
  validation {
    condition     = var.subnet_size >= 0 && var.subnet_size <= 32
    error_message = "The subnet size (bits) should be between 0 and 32."
  }
}

variable "availability_zones_count" {
  description = "Number of availability zones to use when creating subnets"
  default     = 3
  type        = number
  validation {
    condition     = var.availability_zones_count <= 10
    error_message = "The number of availability zones to use should be less than 10."
  }
}

variable "ipv4_ipam_pool_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#ipv4_ipam_pool_id"
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#ipv4_netmask_length"
  type        = string
  default     = null
}

variable "enable_discover_ipam" {
  description = "Use data resource to discover IPAM pool"
  type        = bool
  default     = true
}

variable "ipam_search_description" {
  description = "IPAM pool description to search"
  type        = string
  default     = "*"
}

variable "enable_transit_gateway_attachment" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment"
  type        = bool
  default     = true
}

variable "transit_gateway_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment#transit_gateway_id"
  type        = string
  default     = null
}
