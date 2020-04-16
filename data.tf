data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "Axis"
    workspaces = {
      name = "aws_vpc"
    }
  }
}

# data.terraform_remote_state.vpc.outputs.vpc_id
# data.terraform_remote_state.vpc.outputs.public_subnets
# data.terraform_remote_state.vpc.outputs.private_subnets
# data.terraform_remote_state.vpc.outputs.database_subnets


// resource "random_shuffle" "public_subnets" {
//   input = [data.terraform_remote_state.vpc.outputs.public_subnets]
//   result_count = 1
// }

// resource "random_shuffle" "private_subnets" {
//   input = [data.terraform_remote_state.vpc.outputs.private_subnets]
//   result_count = 1
// }

// resource "random_shuffle" "database_subnets" {
//   input = [data.terraform_remote_state.vpc.outputs.database_subnets]
//   result_count = 1
// }