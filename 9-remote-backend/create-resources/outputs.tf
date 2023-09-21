output "bucket_name" {
  description = "Name of bucket to store state"
  value       = aws_s3_bucket.this.id
}

output "table_name" {
  description = "Name of dynamo db table to store locking state"
  value       = var.dynamo_table_name
}

output "aws_region" {
  description = "AWS region where the resources are located"
  value       = data.aws_region.current.name
}

output "remote_configuration" {
  description = "Paste the following configuration to use this remote bucket"
  value       = <<EOT
terraform {
    backend "s3" {
        region         = "${data.aws_region.current.name}"
        bucket         = "${aws_s3_bucket.this.id}"
        key            = "terraform-state/terraform.tfstate"
        dynamodb_table = "${var.dynamo_table_name}"
    }
}
EOT
}