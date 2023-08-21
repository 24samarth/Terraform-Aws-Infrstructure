resource "aws_security_group" "rds_security_group" {
  name   = "${var.environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${var.environment}-rds_subnetgroup"
  #only lowercase alphanumeric characters, hyphens, underscores, periods, and spaces allowed in "name"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "rds" {
  allocated_storage = var.allocated_storage
  //db_name = var.db_name 
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  identifier     = "${var.environment}-rds-instance"
  #  Warning: only lowercase alphanumeric characters and hyphens allowed in "identifier"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  skip_final_snapshot    = true

  tags = {
    Name = "${var.environment}-RDS_Instance"
  }
}



