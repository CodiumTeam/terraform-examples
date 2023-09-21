variable "s3_bucket_name" {
  type        = string
  default     = null
  description = "Name for the S3 bucket created to store Terraform state. Otherwise randomly generated"
}

variable "dynamo_table_name" {
  type        = string
  default     = "terraform-locking"
  description = "Name for the DynamocDB table created to lock Terraform state."
}