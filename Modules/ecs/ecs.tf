# cluster
resource "aws_ecs_cluster" "onchain" {
  name = "${var.environment}-cluster"
}


# Network Load Balancer (NLB)
resource "aws_lb" "nlb" {
  name               = "${var.environment}-nlb"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id = element(var.private_subnets, 0)
  }
  subnet_mapping {
    subnet_id = element(var.private_subnets, 1)
  }
  subnet_mapping {
    subnet_id = element(var.private_subnets, 2)
  }

  tags = {
    Name = "${var.environment}-nlb"
  }
}