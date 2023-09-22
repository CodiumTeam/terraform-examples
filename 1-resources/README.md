# 1. HCL, resources and providers

Terraform allows you to manage any system which can be modified via an API. It is commonly used to manage infrastructure, as all cloud providers, like AWS, Azure, Google, etc. offer an API to manage resources.

You write a manifest describing the *desired state* of the system, and then Terraform will suggest a series of actions to achieve that state. If you need to make changes to the system, you can modify the manifest, so it describes a different state, and then Terraform will suggest incremental changes to satisfy that new state.

These manifests are written as code in language known as HCL (Hashicorp Common Language). Since they are just files, you can and should commit them to source control so you can keep a historic record of all the changes made to your system. This is what is usually known as *Infrastructure as Code* (IaC).

Terraform knows how to communicate with an API via a provider which defines a series of objects you can interact with. There are official providers for all common cloud providers, docker, kubernetes, etc. In addition there are also open source, community-maintained providers, and you could also create a new provider from scratch.

To start managing your system, all you need to do is create a `*.tf` file. Convention dictates your file should be named `main.tf`. In there, you can describe which providers (and which versions) you want to use, and the state of your system.
It is good practice to specify the minimum or even the precise version of the providers you want to use; this ensures that your project works in a consistent manner, even after newer versions of a provider are available.

The basic construct to administer your system is the *resource*. It describes an entity that needs to be created in your system, e.g. an EC2 instance in AWS, or a bucket, or an IAM role, etc.

Resources admit a set of compulsory or optional arguments, describing the resource. They also produce a set of output arguments that can be used to query the created resource. For example, you could query the public IP of an EC2 instance, which is not known until it has been created. Those output arguments could be used as inputs for other resources, effectively linking them.

Terraform will automatically understand the dependencies between those resources analyzing how they reference each other (beware of dependency cycles though!), and it will create/destroy them in the right order.

The first step when you start a project is to execute `terraform init`. This will download the required providers and install them locally within the project folder. You must do this every time you add/change a provider.

The Terraform CLI provides a utility `terraform validate` to check the syntax of your project. In addition, you can also execute `terraform fmt` which will homogenize the format of your files.

## Example

This example defines the version of the AWS provider it requires, and then creates an EC2 instance in AWS. 


> Beware that for this example to work, you need to have a default VPC already created in AWS. 