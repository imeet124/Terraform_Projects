# Define the aws provider configuration.
provider "aws" {
    region = "us-east-1" # replace with your aws region
}

variable "cidr" {
    default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
    key_name = "terraform-test" # replace with your EC2 aws_key_pair.
    public_key = file("~/.ssh/id_rsa.pub") # replace wih your public key file
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

resource "aws_subnet" "subtest" {
    vpc_id                  = aws_vpc.myvpc.id
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
}

resource 'aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id


    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rta1" {
    subnet_id       = aws_subnet.sub1.id
    route_table_id  = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
    name = "web"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description = "HTTP from vpc"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        descritpion = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "web-sg"
    }
}

resources "aws_instance" "server" {
    ami                     =  "provide your ami from aws"
    instance                = "provide your desired instance type"
    key_name                = provide your key name here
    vpc_security_groups_ids = [aws_security_group.webSg.id]
    subnet_id               = aws_subnet.sub1.id


    connection {
        type        = "ssh"
        user        = "ubuntu" $ replace with an appropriate username for yor EC2 instance
        private_key = file("~/.ssh/id_rsa") # replace with the path to your private key
        host        = self.public_ip
    }

    # file provisioner to copy a file local to the reemote EC2 instance
    provisioner "file"  {
        souce      = "app.py" # replace with the path your local file
        desination = "/home/ubuntu/app.py" # replace with the path on the remote instance
        }

    provisioner "remote-exec" {
        inline = [
            "echo 'Hello from the remote instance'",
            "sudo apt update -y" 
            "sudo apt-get install -y pytho-pip",
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py &",
        ]
    }
}



 
