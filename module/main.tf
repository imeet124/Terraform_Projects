provider "aws" {
  region - "us-east-1"
}

module = "ec2_instance"  {
  source = "./modules/ec2_instance"
  ami_value = "provide instance ai value here"
  instance_type_value = "provide your desired instance type"
  subnet_id_value = "provide subnt id here"
  
