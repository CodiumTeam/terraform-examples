project_name = "nginx_prod"
instances = {
  main   = {}
  backup = { instance_type = "t3.micro" }
}