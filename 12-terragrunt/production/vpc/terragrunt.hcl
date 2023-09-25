include "root" {
  path = find_in_parent_folders()
}

terraform {
    source = "../../modules/vpc"
}

inputs = {
    availability_zone_count = 2
    
    naming_prefix           = replace(path_relative_to_include(),"/","_")
}