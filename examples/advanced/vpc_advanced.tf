module "advanced" {
  source                              = "github.com/pankajnarang/tf-aws-vpc.git?ref=v0.0.1"
  business_unit                       = "XYZ"
  environment                         = "dev"
  project                             = "ABC"
  provisioned_by                      = "pankaj.narang@outlook.com"
  team                                = "Engineering"
  availability_zones                  = ["us-east-1a"]
  private_subnet_cidr_blocks          = ["10.0.8.0/21"]
  public_subnet_cidr_blocks           = ["10.0.208.0/21"]
  private_subnet_cidr_blocks_with_nat = ["10.0.104.0/21"]
  # if enable_nat_gateway is set to true, we'll see three more private subnets which will have nat gateway attached with them
  enable_nat_gateway = true
}