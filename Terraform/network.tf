resource "aws_vpc" "main" {
  cidr_block = var.VPC_CIDR_block

  tags = {
    Name = "Project VPC"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  count  = length(var.public_subnet_cidrs)


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Public Route Table ${count.index + 1}"
  }
}
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}

resource "aws_subnet" "public_subnet" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.AZs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }

}

#give nat gateway elastic IP to enable outbound traffic.
resource "aws_eip" "elastic_IP" {
  # this just needs to be created no need for an argument the VPC argument

  count = length(var.private_subnet_cidrs)
}

resource "aws_nat_gateway" "demo-nat-gateway" {

  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.elastic_IP[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id


  tags = {
    Name = "Demo NAT Gateway ${count.index + 1}"
  }

  # For proper ordering.
  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  count  = length(var.public_subnet_cidrs)

  route {
    cidr_block     = "0.0.0.0/0" # Allow outbound access to all IPs
    nat_gateway_id = aws_nat_gateway.demo-nat-gateway[count.index].id
  }

  tags = {
    Name = "Private Route Table ${count.index + 1}"
  }
}
resource "aws_route_table_association" "private_subnet_asso" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.AZs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}
resource "aws_db_subnet_group" "postgres_db_subnet_group" {
  name        = "postgres-db-subnet-group"
  subnet_ids  = aws_subnet.private_subnet[*].id
  description = "Private Subnet Group for PostgreSQL"
}
