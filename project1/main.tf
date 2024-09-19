provider "aws" {
    region = "us-east-1" # set your desired aws region
}

resources "aws_insatce" "example"{
 ami          = "ami-ncieh24rn2idce" # specifiyan appropriate AMI ID
 instace_type = "t2.micro"
 }
