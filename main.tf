
resource "aws_vpc" "ot_microservices_dev" {
  cidr_block       = "10.0.0.0/25"
  instance_tenancy = "default"
  tags = {
    Name = "ot-micro-vpc"
  }
}

resource "aws_subnet" "database_subnet" {
 vpc_id            = aws_vpc.ot_microservices_dev.id
 cidr_block        = "10.0.0.64/28"
 availability_zone = "us-east-1a"
 tags = {
   Name = "Database Subnet"
 }
}

resource "aws_security_group" "alb_security_group" {
  vpc_id = aws_vpc.ot_microservices_dev.id
  name = "alb-security-group"

  tags = {
    Name = "alb-security-group"
  }
  
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "redis_security_group" {
  vpc_id = aws_vpc.ot_microservices_dev.id
  name = "redis-security-group"

  tags = {
    Name = "redis-security-group"
  }
  
  ingress {
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    security_groups = [aws_security_group.attendance_security_group.id]
  }

  ingress {
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    security_groups = [aws_security_group.employee_security_group.id]
  }

  ingress {
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    security_groups = [aws_security_group.salary_security_group.id]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "employee_security_group" {
  vpc_id = aws_vpc.ot_microservices_dev.id
  name = "employee-security-group"

  tags = {
    Name = "employee-security-group"
  }
  
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "salary_security_group" {
  vpc_id = aws_vpc.ot_microservices_dev.id
  name = "salary-security-group"

  tags = {
    Name = "salary-security-group"
  }
  
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}

# bastion security group

resource "aws_security_group" "bastion_security_group" {
  vpc_id = aws_vpc.ot_microservices_dev.id
  name = "bastion-security-group"

  tags = {
    Name = "bastion-security-group"
  }
  
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "attendance_security_group" {
  vpc_id = aws_vpc.ot_microservices_dev.id
  name = "attendance-security-group"

  tags = {
    Name = "attendance-security-group"
  }
  
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "syclla_security_group" {
  vpc_id = aws_vpc.ot_microservices_dev.id
  name = "syclla-security-group"

  tags = {
    Name = "syclla-security-group"
  }
  
  ingress {
    from_port        = 9042
    to_port          = 9042
    protocol         = "tcp"
    security_groups = [aws_security_group.redis_security_group.id]
  }

  ingress {
    from_port        = 9042
    to_port          = 9042
    protocol         = "tcp"
    security_groups = [aws_security_group.employee_security_group.id]
  }

  ingress {
    from_port        = 9042
    to_port          = 9042
    protocol         = "tcp"
    security_groups = [aws_security_group.salary_security_group.id]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}


# Scylla instance

resource "aws_instance" "syclla_instance" {
  # ami to be replaced with actual ami
  ami           = "ami-0c9826bbab4a4e364"
  subnet_id = aws_subnet.database_subnet.id
  vpc_security_group_ids = [aws_security_group.syclla_security_group.id]
  instance_type = "t2.medium"
  key_name = "Backe"

  tags = {
    Name = "syclla"
  }
}


