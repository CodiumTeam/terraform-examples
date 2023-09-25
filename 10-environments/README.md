# 10. Manage multiple environments

If your project is not too complex, you may be able to use it to deploy to multiple environments simply by changing the input variables. The recommendation is to create a `*.tfvars` file for each of the environments. When invoking terraform the right file is selected adding the `-var-file` to the CLI `terraform` command.

HOwever as projects grow in complexity, this many not give the required flexibility to capture the differences between environments. Also, as the project grows, it may be beneficial to split it into smaller chunks. Not only through modules, but in separate projects that can be executed independently.

This can lead to a structure where each environment is in a separate folder, and within each one, a folder contains a project for each of the components. 
In order to avoid duplicating lots of code, most of the definitions are created as modules, either on the same repository or in another one. Each component then invokes the module with the required input values stored in a `tfvars` file.

The advantage of storing the modules in a separate repository is that they can be versioned. When referencing a module stored in git, once can indicate which version (e.g. tag) wants to use. In this way different versions of the same module can be referenced in different environments. This is useful, for example, to test changes in *staging* or *qa* by making the changes in the source module, then incrementing the version only for those environments. If the tests are successful then the change can be applied to *production* too.

As the number of components and environments grows, is particularly important to automate all the executions in CI pipelines; particularly as there may be dependencies between some of the components.

## Example

Here we show two approaches for having multiple environments. The simple approach of having a *single* project, and using input variables to capture the differences between environments. The selection of environment is done via the CLI argument, e.g.
```bash
terraform apply -var-file qa.tfvars
```

The other example showcases the use of *multiple* projects. All the resources are defined in common modules stored in the root (usually they would be in a separate repository, but it is kept in the same on for simplicity). Then each component of each environment has its own project. Even through the use of modules there is a lot of copy paste code which can become hard to maintain in sync. 
Notice also how it uses the *terraform_remote_state* data source to capture output from one component (vpc) to be used in the other (nginx). This leads to even more repetition of all the remote state configuration in s3.