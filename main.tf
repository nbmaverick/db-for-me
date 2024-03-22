# read all AZ in ohio
data "aws_availability_zones" "all" {}

output "AZ" {
    value = data.aws_availability_zones.names
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

