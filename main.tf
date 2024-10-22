resource "aws_vpc" "my_vpc" {
  cidr_block = var.dev_vpc1_cidr_block
  tags = {
    Name = "my_vpc"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.dev_subnet1_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}


resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.dev_subnet2_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet2"
  }
}


resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Alternatively, you can use this rule to allow all protocols (TCP, UDP, ICMP)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_traffic"
  }
}

resource "aws_instance" "ec2_instance1" {
  ami           = "ami-0a3c3a20c09d6f377" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet1.id
  security_groups = [aws_security_group.my_sg.id]
  associate_public_ip_address = true
  key_name               = "test"

  tags = {
    Name = "ec2_instance1"
  }
}

# Data source to fetch existing Elastic IP
data "aws_eip" "existing_eip" {
  public_ip = "174.129.40.107"  # Replace with your Elastic IP address
}

# Create the EC2 instance
resource "aws_instance" "ec2_instance2" {
  ami                    = "ami-0a3c3a20c09d6f377" 
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.public_subnet2.id
  security_groups       = [aws_security_group.my_sg.id]
  associate_public_ip_address = false  # Set to false because we'll use the Elastic IP
  key_name               = "test"

  tags = {
    Name = "ec2_instance2"
  }
}

# Associate the existing Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_association" {
  instance_id   = aws_instance.ec2_instance2.id
  allocation_id  = data.aws_eip.existing_eip.id
}
