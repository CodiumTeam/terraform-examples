# 8. Encapsulate your code in modules

There is no limit to the size or number of *.tf files in your project. However as the complexity grows, it is beneficial to structure your code using modules. In fact it is useful to build your code in modules even with moderately simple projects.

Advantages of writing your code using modules:
- Better code organization. You isolate your code according to their function and store it in folders.
- Encapsulate your code - avoid name clashes, or unintended consequences when changing a part of your code.
- Re-use. Instead of copy and paste, or re-writing the same blocks over and over, just referencing them as a module. 
- Consistency and best practices - ensure the same type of resources are always created in the same manner and according to the agreed ways.
- Self-service - other teams or people can use the module without having to understand its inner workings and details.

Since a module encapsulates the code, it needs to define specific outputs for all the information the module should expose to its consumers. 

## Refactoring your code

When you refactor your code into modules, it is likely the the ID of your resources will change.  When you next apply changes Terraform will delete the resource with the old ID and create a new (potentially identical) one with the new ID.

To avoid the downtime associated with the recreation of resources, you can use the `moved` configuration block to inform Terraform of the mapping between the old and new IDs so the resource is not re-created unnecessarily. It also documents how resources how evolved over time.

```terraform
moved {
  from = aws_instance.example
  to = module.ec2_instance.aws_instance.example
}
```

## Example

In the previous example there were three steps involved in the creation of the NGINX server: 1) Create a security group exposing port 80; 2) Find out the correct AMI; 3) Create the actual instance. This three steps have been encapsulated in a module.

Notice how the module sits in its own folder, within the *modules* folder. It defines a series of variables (inputs) and outputs. The module is then invoked in the `main.tf` file, passing values for the variables. In addition the module's outputs can be referenced in the root output, otherwise the values would not be displayed back to the user.

To make the module more useful, it also allows creating multiple instances. This could have been done by invoking the module with the [`for_each`](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) meta argument. In this case, the data source querying the AMI, and the security group, could be re-used, even when creating multiple servers, so a different approach has been chosen.
Instead the module accepts a map as input variable. A map is just a series of key-values. It then understands each key in the map, is the name of a server to be created; and the value its properties.

To implement this, a `for_each` meta argument is added to the `aws_instance` resource. This indicates that it needs to be evaluated for each key in the map. Then the `each` object can be used to reference the distinct keys and values through the `each.key` and `each.value` attributes.
A `for_each` meta argument can also accept a set of strings. It is important to note it does not accept a *list* since it requires each value to be different, as it is used to index the different objects produced. You can convert a list to a set with the [`toset`](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each#using-sets) function.
