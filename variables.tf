variable "availability_zones_count" {
  description = "Number of availability zones to use when creating subnets"
  default     = 3
  type        = number
}

variable "enable_discover_ipam" {
  description = "Use data resource to discover IPAM pool"
  type        = bool
  default     = true
}

variable "enable_s3_vpc_endpoint" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint"
  type        = bool
  default     = true
}

variable "enable_ingress_implicit_allow" {
  description = "Enable a rule to allow all ingress traffic from 0.0.0.0/0"
  type        = bool
  default     = true
}

variable "enable_ingress_local_allow" {
  description = "Enable a rule to allow all ingress traffic from the local VPC CIDR block"
  type        = bool
  default     = true
}

variable "enable_ingress_cidr_deny" {
  description = "Enable a rule to deny all ingress traffic from a specific CIDR block (var.ingress_cidr_deny)"
  type        = bool
  default     = true
}

variable "ingress_acl_rules" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl"
  type = list(object({
    cidr_block = string
    action     = optional(string, "allow")
  }))
  default = []
}

variable "ingress_cidr_deny" {
  description = "Ingress CIDR block to deny traffic"
  type        = string
  default     = "10.0.0.0/8"
}

variable "ipam_search_description" {
  description = "IPAM pool description to search"
  type        = string
  default     = "*"
}

variable "name" {
  description = "Used to label all resources"
  type        = string
  default     = "default"
}

variable "subnet_ipv4_netmask_length" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#ipv4_netmask_length"
  type        = string
  default     = 21
}

variable "tags" {
  description = "Additional tags to be applied to all resources"
  default     = {}
  type        = map(string)
}

variable "transit_gateway_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment#transit_gateway_id"
  type        = string
  default     = null
}

variable "vpc_ipv4_ipam_pool_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#ipv4_ipam_pool_id"
  type        = string
  default     = null
}

variable "vpc_ipv4_netmask_length" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#ipv4_netmask_length"
  type        = string
  default     = 18
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}
