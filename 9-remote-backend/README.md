# 9. Set up a remote backend

After changing the state of the system, Terraform will write the final state to a file `terraform.tfstate`. When making future changes to the desired configuration with the HCL files, Terraform will compare the new requested state with the last known state as recorded in the `terraform.tfstate` file. 

If for some reason the state of the system has been changed (maybe through other means) since the last execution the state would have *drifted*. 0

If for some reason you have a drift between your state file and the actual system, terraform will try to address it next time use the `plan` or `apply` commands. However, if you want to just refresh your state file, and **not make any changes to your infrastructure**,  you should [use the `--refresh-only` flag](https://developer.hashicorp.com/terraform/tutorials/state/refresh). This is better than the now obsolete `~~terraform refresh~~` command, as they provide an overview of the intended changes to the state file and let you accept or reject them. They will also update any outputs, so any dependencies have the correct information.

Maintaining the state file in sync is on the biggest challenges when working as a team. There are various solutions available:
1. Centralize your executions in a single server. For example, disallow users to do `apply` from their own computers, and only execute it from a CI pipeline or a central server.
1. Use Hashicorp's [Terraform Cloud](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate), which stores the state file remotely. It can be used simply as a remote storage location, and still use Terraform locally to perform the changes and communication with the underlying system, or it can be configured so the cloud is doing all the work directly.
1. Configure Terraform to use a different [storage backend](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) to save the state. There is [support for many backends](https://developer.hashicorp.com/terraform/cdktf/concepts/remote-backends#supported-backends) S3, Azure RM, Consul, GCS, a Postgres database, etc.

Terraform also provides a data source [`terraform_remote_state`](https://developer.hashicorp.com/terraform/language/state/remote-state-data) to query the state file of another project (as stored in any remote). This can be used to establish dependencies between projects. Use with care though to end up in a dependency hell.

## Example

In this example there are two Terraform projects. The first one `create-resources` is used to define an S3 bucket and a DynamoDB table in AWS to be used as a remote backend. The second one `use-remote` showcases how to define a remote backend in the *terraform* configuration. 
> The remote configuration cannot use locals or variables, however it is possible to use [*partial configuration*](https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration). Instead of supplying all required arguments, you can add them one invoking the `init` command, either directly in the command line or by referencing a file.