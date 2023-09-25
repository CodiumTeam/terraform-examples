# Terraform examples

A collection of simple Terraform examples to highlight the core concepts of Terraform using the AWS provider. All the examples deploy a simple EC2 Ubuntu instance.

You may need to configure access to AWS, by installing AWS CLI and running `aws config`. The examples can be simply run doing:

```bash
terraform init
terraform apply
```

And cleaned up doing `terraform destroy`

In addition, a devcontainer has been set up so it can be started with VS Code and there is no need to install Terraform. By default it will copy the AWS CLI credentials from the user.


# Terraform core concepts

1. [HCL, resources and providers](1-resources/README.md)
2. [Using variables](2-variables/README.md)
3. [Generating output](3-output/README.md)
4. [Avoid repetition with locals](4-locals/README.md)
5. [Query information using data sources](5-datasources/README.md)
6. [Use modules to make things easier](6-invoking-modules/README.md)
7. [Verifying with checks, pre-conditions, post-conditions](7-checks/README.md)
8. [Encapsulate your code in modules](8-creating-modules/README.md)
9. [Set up a remote backend](9-remote-backend/README.md)
10. [Manage multiple environments](10-environments/README.md)
11. [Best practices](11-best-practices/README.md)
12. [Terragrunt](12-terragrunt/README.md)