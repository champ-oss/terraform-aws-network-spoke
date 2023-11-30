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

variable "ingress_acl_allow_rules" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl"
  type = list(object({
    cidr_block = string
    rule_no    = number
  }))
  default = []
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
