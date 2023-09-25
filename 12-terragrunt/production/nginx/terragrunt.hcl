include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/nginx"
}

dependency "vpc" {
  config_path             = "../vpc"
}

inputs = {
  instances               = {
      main =    { instance_type = "t3.micro" }
      backup =  { instance_type = "t2.nano" }
  }

  naming_prefix           = replace(path_relative_to_include(),"/","_")
  subnet_id               = dependency.vpc.outputs.subnets[0]
  vpc_id                  = dependency.vpc.outputs.vpc_id
}