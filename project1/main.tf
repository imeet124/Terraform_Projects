rovider "aws" {
    region = "us-east-1" # set your desired aws region
}

resource "aws_instance" "example"{
 ami          = "ami-0e86e20daehqdb2" # specifiyan appropriate AMI ID
 instance_type = "t2.micro"
 subnet_id = "subnet-09545a31sajkj"  # provide your subnet id here
 key_name = "test1_key"  # provide your  key pair name here
 } 
