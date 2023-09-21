# Terraform examples

A collection of simple Terraform examples to highlight the core concepts of Terraform using the AWS provider. All the examples deploy a simple EC2 Ubuntu instance.

You may need to configure access to AWS, by installing AWS CLI and runing `aws config`. The examples can be simply run doing:

```bash
terraform init
terraform apply
```

And cleaned up doing `terraform destroy`

In addition, a devcontainer has been set up so it can be started with VS Code and there is no need to install Terraform. By default it will copy the AWS CLI credentials from the user.


# Terraform core concepts

1. [HCL, resources and providers](1-resources/README.md)
2. Using variables
3. Generating output
4. Avoid repetition with locals
5. Query information using data sources
6. Use modules to make things easier
7. Verifying with checks, preconditions, postconditions
8. Encapsulate your code in modules
9. Set up a remote backend
10. Manage multiple environments
11. Best practices