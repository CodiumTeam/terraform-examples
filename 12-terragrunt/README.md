# 12. Terragrunt

As we saw in an [earlier example](../10-environments/b-multiple), as you add more components and environments there is quite a lot of repetition. You are repeating remote backend definitions (which can't use variables or locals), and you are repeating declarations of *module* blocks.

[Gruntwork.io](https://gruntwork.io/) has created [Terragrunt](https://terragrunt.gruntwork.io/) to help with those challenges. The main purpose of Terragrunt is to help you DRY (Do not Repeat Yourself) your Terraform configuration.

It provides a quite a few benefits:

- Auto initializes - no more `terraform init`
- Avoid repetition of remote backend block
- No chicken-egg problem when creating an S3 backend
- Minimize copy paste between environments
- Capture dependencies between components without the use of a data source, and having to reference the state store.
- Invoke Terraform commands in bulk to multiple components and/or environments, in the right order considering dependencies.
- Create defaults for common CLI parameters
- Use different AWS accounts for each environment

The basic premise is that you create a module for each component of your infrastructure. Each environment/module will then have a `*.hcl` file containing the reference to the module to use, and the list of inputs (kind of like the `tfvars` file). There are also a few functions available to reference other components, and import data from other files, hence allowing you to place common settings in a file at the root of your folder structure.

Terragrunt is just a wrapper for terraform, so the main difference is that instead of running `terraform` commands you execute `terragrunt` followed by the usual `apply`, `plan`, `fmt`, `validate`, etc.

It also provides a special `terragrunt run-all` command that allows you to run another command (`apply`, `plan`, etc.) in bulk to all the sub-folders. 

Usually the referenced modules and the actual environment definitions will sit in two separate repositories. This allows you to reference a specific version of the module, enabling the use of different versions in each environment. It is possible to override this behaviour temporarily when developing the modules, so you don't have to push changes to the modules repository to test them in your environment one:
```bash
terragrunt apply --terragrunt-source ../../../modules//app
```

When integrating Terragrunt in CI pipelines, you can use the `--terragrunt-non-interactive` flag.

## Example

This is a refactored version of [example 10](../10-environments/b-multiple), using Terragrunt. Notice how most of the repeated code and multiple `*.tf` have disappeared in favour of a single `hcl` file per component. Even then some of the input parameters have been replaced by expressions (like the *naming_prefix*).

Terragrunt will initialize the different projects, create the remote backend and create the VPC and Nginx servers in the right order, simply by doing `terraform run-all apply`.

> **Note:** There seems to be some issues doing `terraform run-all destroy`, as it attempts to remove resources in the wrong order. Also `terraform run-all plan` may not function correctly as there are dependencies between VPC and Nginx. 