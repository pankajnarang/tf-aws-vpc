module "basic" {
  source         = "../../."
  business_unit  = "XYZ"
  environment    = "dev"
  project        = "ABC"
  provisioned_by = "pankaj.narang@outlook.com"
  team           = "Engineering"
  # if enable_nat_gateway is set to true, we'll see three more private subnets which will have nat gateway attached with them
  enable_nat_gateway = true
}