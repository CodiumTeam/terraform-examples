# 5. Query information using data sources

Sometimes you require access to information that may change. For example you may need to get the list of AWS Availability Zones, but those may change depending of the region in use.

Terraform providers can support this scenario with data sources. Defined through a *data* block, they provide a way of querying information about the system. Each provider will offer a different set of data sources.

In addition terraform itself, offers some data sources, which for example allow you to query the state of a different Terraform project.

In some ways a data source is analogous to a resource, it accepts some input arguments and has some output arguments. The main difference is that a data source will never make any changes to the underlying system, it only queries its state.

## Example

This example uses a data source to avoid hardcoding the AMI of the instance to create. The AWS provider offers a data source that can query the AMIs available, which then can be filtered by various criteria. In this case we use a filter for the name and the owner of the image.
