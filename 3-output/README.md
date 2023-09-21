# 3. Generating output

It is useful to be able to see information about the changes made after they have been completed. Some of this information will only be available after the process has finished.
For example, we may want to see the public IP of the a EC2 instance; this is only available after the resource has been created.

This is done by defining an *output* block. They can be definied in any `*.tf` file, but the convention is to put them in an `outputs.tf` file.

For each output you can add a description to document its meaning.


## Example

Here we add a new output to show the public IP of the instance that has been created. Notice how when you first execute *apply* it says the output is only available after the change is applied.