# Create an Public EC2 instance
resource "aws_instance" "public_instance" {
  ami           = var.AMI
  instance_type = var.instance_type # make this a variable
  key_name      = var.ssh_file
  count         = length(var.public_subnet_cidrs)

  subnet_id                   = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.ec2_Public_SG.id]
  associate_public_ip_address = true

  #install docker on startup
  user_data = <<-EOF
    #!/bin/bash
    apt update && apt install -y docker.io
    systemctl start docker
    systemctl enable docker
    usermod -aG docker $USER
    newgrp docker
  EOF

  #   specify the root volume for horizontal scaling
  root_block_device {
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }

  tags = {
    Name = "Django app ${count.index + 1}"
  }

}

resource "aws_db_instance" "postgres_db" {
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_storage
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  port                   = 5432
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.postgres_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_Private_SG.id]
  multi_az               = true
}


