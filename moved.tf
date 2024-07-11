moved {
  from = data.aws_region.this
  to   = data.aws_region.this[0]
}

moved {
  from = aws_default_network_acl.this
  to   = aws_default_network_acl.this[0]
}

moved {
  from = aws_vpc_endpoint.s3
  to   = aws_vpc_endpoint.s3[0]
}

