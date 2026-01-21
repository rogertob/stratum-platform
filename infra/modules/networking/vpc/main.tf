# Using `this` when it creates a single instance of the resource
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}"
    }
  )
}

# Create Internet Gateway 
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-igw"
    }
  )
}

# Manage default VPC secruity group 
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
  # No ingress traffic allowed
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-default"
    },
  )
}

# Subnets
## Private  Application Subnet
resource "aws_subnet" "app" {
  for_each                = var.app_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-app-pvt-${each.value.availability_zone}"
    }
  )
}
## Public Subnets
resource "aws_subnet" "web" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-public-${each.value.availability_zone}"
    }
  )
}

## Private DB subnets
resource "aws_subnet" "data" {
  for_each                = var.data_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-data-pvt-${each.value.availability_zone}"
    }
  )
}

# Nat Gateway for Application subnets
resource "aws_nat_gateway" "this" {
  for_each = var.create_nat_gw_regional ? { enabled = true } : {}
  vpc_id            = aws_vpc.this.id
  availability_mode = "regional"

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-regional-natgw"
    }
  )
}

# Routes
## App route table & association
### When using a conditional for a resource creation then referenced somehwere else we can use a dynamic resource
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.this.id
  
  dynamic "route" {
    for_each = var.create_nat_gw_regional ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this["enabled"].id
    }
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-app-rtb"
    }
  )
}

resource "aws_route_table_association" "app" {
  for_each = aws_subnet.app
  route_table_id =  aws_route_table.app.id
  subnet_id = each.value.id
}

## Public route table 
resource "aws_route_table" "web" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-public-rtb"
    }
  )
}

resource "aws_route_table_association" "web" {
  for_each = aws_subnet.web
  route_table_id =  aws_route_table.web.id
  subnet_id = each.value.id
}

## Data route table 
resource "aws_route_table" "data" {
  vpc_id = aws_vpc.this.id

  route = []

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name}-${var.environment}-data-rtb"
    }
  )
}

resource "aws_route_table_association" "data" {
  for_each = aws_subnet.data
  route_table_id =  aws_route_table.data.id
  subnet_id = each.value.id
}




