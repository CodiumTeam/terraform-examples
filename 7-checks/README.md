# 7. Verifying with checks, pre-conditions, post-conditions

Sometimes it is useful to verify the state of the system after the changes have been executed. A *check* block allows you to define a verification with one or more assertions.

Checks are executed after every `plan` or `apply` operation, but they won't affect the final status of the operation, they are purely informative. 

In addition, a check block can contain a data source definition, *scoped* to that particular check. This means it is executed only at the time of the check, and is not available outside the check. If this data source references another resource, it will be invoked after the resource is available. 
If the data source requires the existence of a resource it does not reference directly, one can use the `depends_on` meta-argument to indicate that dependency.

Each assertion within the check block contains an expression that must return true for the check to pass, and a message that gets displayed when the assertion fails.

## Pre and post conditions

There is another type of validation check that can be performed with Terraform, within an object block. This is created inside a *lifecycle* block within the object. It is available for resources, data sources and outputs. 
In this lifecycle block you can add a *precondition* and/or a *postcondition*. They both have an expression that must return true, and an error message. They difference is that one is executed before evaluating the object and the other after. As opposed to checks, if they fail they stop any further processing.

All this validations can be executed continuously in the Terraform Cloud.

## Example

In this example, the ubuntu instance is configured as an nginx server. Notice how the `user_data` argument is used to provide a script to install nginx. This is done as a HEREDOC, but in other cases, when the script is longer, it may be better to include a reference to a file in the repository.

A check has been added verifying that the server responds to an HTTP request with a 200. This is done after the resource has been created.
However, the check fails, but since check is informative only, it does not prevent from Terraform returning a successful exit code.
The check fails the first time because even though the instance is running, it does not wait for the cloud-init script to finish executing, so the HTTP request is executed before nginx is installed.
There are techniques to prevent this from happening, but they involve higher complexity. For example the initialization script can update a tag in the EC2 instance, and Terraform can have a script blocking the execution until that tag is present.