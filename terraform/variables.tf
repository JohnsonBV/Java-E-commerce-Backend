variable "aws_region" {
  default = "us-east-2"
}

variable "cluster_name" {
  default = "ecommerce-eks"
}

variable "ec2_key_pair" {
  description = "Name of your existing EC2 Key Pair"
  type        = string
  default     = "Victorpk"
}
