resource "aws_db_instance" "postgres" {
  allocated_storage       = 20 # gigabytes
  backup_retention_period = 7  # in days
  db_subnet_group_name    = var.db_subnet_name
  engine                  = "postgres"
  engine_version          = "14.4"
  identifier              = "${var.prefix}-${terraform.workspace}-db-pg"
  instance_class          = "db.t3.micro"
  multi_az                = false
  db_name                 = "postgres"
  parameter_group_name    = aws_db_parameter_group.pg.name
  username                = var.username
  password                = var.password
  port                    = 5432
  publicly_accessible     = true
  storage_encrypted       = true
  storage_type            = "gp2"

  deletion_protection = var.deletion_protection # Set to true in production

  vpc_security_group_ids = [var.security_group_id]
}

resource "aws_db_parameter_group" "pg" {
  family = "postgres14"
}

