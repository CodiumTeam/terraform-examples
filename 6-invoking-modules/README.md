# 6. Use modules to make things easier

Modules are the main way to package and reuse resource configurations with Terraform. Instead of having to define your system from scratch you leverage generic definition of resources created by others.
There is an official module registry (the [Terraform Registry](https://registry.terraform.io/)) where one can publish, share, and find modules.

To reference a module in your code simply add a *module* block. As a minium you then need to add a source attribute to point to the location of the module. This attribute is generally *URL-like* and it can reference various types of sources: the Terraform Registry (or another registry), a git repository, an AWS S3 location, or simply a path within your local system.

After adding a reference to a module, you must execute `terraform init`. This will download the code for the module and store it locally within the `.terraform` folder. In case of reference to other local modules, it actually creates a symbolic link, so changes to the source local module are used straight away.

It is recommended to pin the version of the module, so you ensure consistency in your executions. This is done via the `version` attributes.

Within the *module* block you can add a number of input arguments, this is analogous to the arguments you add to resources, or data sources.

Modules also expose outputs, and this are available for you to consume and feed to other parts of your code. 

A common practice is to put closely related modules in the same repository. To use them as individual modules, it is necessary to use a special `//` notation. E.g. `hashicorp/consul/aws//modules/consul-cluster` will access the `consul-cluster` submodule within the `consul` module.

## Example

In this case, instead of depending on the default VPC network of your AWS infrastructure, we want to create a specific VPC just for our system. Creating a VPC requires a few steps, as you need to create subnets, etc. Instead of doing it manually we will reference the `terraform-aws-modules/vpc/aws` available in the Terraform Registry.

Notice that the naming in the *module* block 
```terraform
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  ...
```
the name *vpc* is our own way of naming this instance of the module. We could have chosen anything we wanted. We have also pinned the version to 5.1.2.

To reference any outputs of this module, we use its name, e.g. `module.vpc.public_subnets[0]`