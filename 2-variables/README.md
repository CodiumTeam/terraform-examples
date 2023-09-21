# 2. Using variables

Often, you want to create the same resources but with some slight variations. You can achieve that by parametrizing hard-coded data in your HCL file.

This is done through a *variable* block. You can define the type of the variable, a description, which will be shown to the user, and can help you document the intent of the variable, and a default value. In more recent versions of Terraform you can also add validation blocks to enforce restrictions for the possible values the variable can take.

Variables can be defined anywhere the `main.tf` file, even after they have been used, as Terraform first reads the whole file. In fact terraform first reads all `*.tf` files, so you could have them in a file of any name. Usually though, all variables are defined in a file `variables.tf`.

You can supply a value for a variable doing `terraform apply -var <name_var>=<value>`. If you do not supply a value for a variable, and it does not have a default one, terraform will prompt you for a value. 
If you need to supply lots of values it is easier to put them in a file, which then you can reference when invoking the apply command. Terraform will automatically pick up variables defined in a `terraform.tfvars` or `*.auto.tfvars`.

Terraform could also populate variables via environment variables, if they are prefixed as `TF_VAR`

## Example

The size of the machine and the prefix to use for the name of the machine have been parametrized. Notice also how there are some restrictions applied to the prefix.
The size of the machine has a default value, so it is not compulsory. However the `project_name` variable requires a value, either by doing `terraform apply -var project_name=ex1` or by adding a `tfvars` file.