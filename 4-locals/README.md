# 4. Avoid repetition with locals

Often you may need to refer to the same expression in multiple places. As ever you should try to follow DRY principles, and repetition is not desirable. 

Through a *locals* block, you can define expressions you can then reference elsewhere in the HCL files. These expressions are evaluated first, and do not change through the execution, so think of them as constants. 

Locals also help you when you want to use dynamic expressions for the default values of variables.

## Example

We want to provide a default value for the prefix used to name resources so we don't have to supply a `project_name` variable. 
As default value we want to use the name of the current folder. This has to be evaluated at runtime so it can be used directly in the *default* section of the variable. 