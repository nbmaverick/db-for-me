# read all AZ in ohio
data "aws_availability_zones" "all" {}

output "AZ" {
  value = data.aws_availability_zones.all.names
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.all.names[0]
  tags = {
    Name = "subnet1"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.all.names[1]
  tags = {
    Name = "subnet2"
  }
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = data.aws_availability_zones.all.names[2]
  tags = {
    Name = "subnet3"
  }
}

resource "aws_db_subnet_group" "default" {
  name = "main"
  subnet_ids = [aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id,
  aws_default_subnet.default_az3.id]

  tags = {
    Name = "My DB subnet group"
  }
}

# Security Group

resource "aws_security_group" "db" {
  name        = "DB SG"
  description = "Controls access to the EC2"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create DB

resource "aws_db_instance" "default" {
  allocated_storage     = 10
  db_name               = "mydb"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  username              = "admin"
  password              = "foobarbaz"
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name  = aws_db_subnet_group.default.name
  publicly_accessible = true

  tags = {
    Name = "My DB"
  }
}