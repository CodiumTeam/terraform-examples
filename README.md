# Terraform examples

A collection of simple Terraform examples to highlight the core concepts of Terraform using the AWS provider. All the examples deploy a simple EC2 Ubuntu instance.

You may need to configure access to AWS, by installing AWS CLI and runing `aws config`. The examples can be simply run doing:
```bash
terraform init
terraform apply
```

And cleaned up doing `terraform destroy`

In addition, a devcontainer has been set up so it can be started with VS Code and there is no need to install Terraform. By default it will copy the AWS CLI credentials from the user.
