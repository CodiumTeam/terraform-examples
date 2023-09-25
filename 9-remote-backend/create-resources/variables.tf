variable "s3_bucket_name" {
  description = "Name for the S3 bucket created to store Terraform state. Otherwise randomly generated"
  type        = string
  default     = null
}

variable "dynamo_table_name" {
  description = "Name for the DynamocDB table created to lock Terraform state."
  type        = string
  default     = "terraform-locking"
}