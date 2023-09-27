# 11. Best practices

### Naming conventions
As ever it is important to use appropriate names, as it can go a long way towards documenting the intent of the code.

In addition, because of how ids in terraform are created, there are further recommendations:
1. Do not add the type of resource to the name. `resource "aws_route_table" "public" {}` instead of ~~`resource "aws_route_table" "public_route_table" {}`~~

1. Use descriptive names for the different resources of the same type. If there is only one resource and there is no better name, use `this`.

1. Use singular nouns for names (since you are naming a single resource).

1. Use underscore `_` instead of dash `-` for names.

1. Prefer lowercase letters and numbers.

1. Name numeric variables with their units (e.g. `ram_size_gb`).

### Formatting

Use a linter, or `terraform fmt` to ensure consistency. 
- Place `for_each` or `count` meta arguments at the top of the resource, followed by a new line.
- Put `tags` at the end, only followed by `depends_on` or `lifecycle`.

### Variables
- Always add `descriptions` and provide `default` values where applicable.

- Use plurals for names of variables that take a *list* or a *map*.

- Order keys in a variable block like this: *description* , *type*, *default*, *validation*.

- Use variable validations whenever possible, even though it has some limitations (for example, you can't reference other variables).

### Other

- Use outputs to expose information. 

- Tag resources.

- Prevent resources with state data from being destroyed inadvertently using `lifecycle { prevent_destroy = true }`.

- Pin versions for providers and for external modules.

- Use `required_version` to indicate the minimum version of Terraform required.

- Auto generate documentation 


> Credits: https://www.terraform-best-practices.com/naming