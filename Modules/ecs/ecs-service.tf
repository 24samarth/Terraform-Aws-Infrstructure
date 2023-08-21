# NLB Target Group for User Service
resource "aws_lb_target_group" "nlb-user-target-group" {
  name     = "${var.environment}-user-target-group"
  port     = 4001
  protocol = "TCP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/user-api/api-docs/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

#NLB User Service Listener
resource "aws_lb_listener" "user-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4001
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-user-target-group.arn
    type             = "forward"
  }
}

# ECS User Service
resource "aws_ecs_service" "onchain-user-service" {
  name            = "${var.environment}-user-service"
  cluster         = aws_ecs_cluster.onchain.id
  task_definition           = aws_ecs_task_definition.onchain_user_service.arn
  desired_count             = 1
 deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 
 network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
    assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb-user-target-group.arn
    container_name   = "${var.environment}-user"
    container_port   = 4001
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_appautoscaling_target" "user-ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.onchain.name}/${aws_ecs_service.onchain-user-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "user-ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.user-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.user-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.user-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageMemoryUtilization"
   }
 
   target_value       = 80
  }
}
 
resource "aws_appautoscaling_policy" "user-ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.user-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.user-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.user-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageCPUUtilization"
   }
 
   target_value       = 60
  }
}

##################################################

#ELB Target Group for Poll Service
resource "aws_lb_target_group" "nlb-poll-target-group" {
  name     = "${var.environment}-poll-target-group"
  port     = 4002
  protocol = "TCP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/poll-api/v1/health-check"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "nlb-poll-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4002
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-poll-target-group.arn
    type             = "forward"
  }
}


# ECS Service for Poll 
resource "aws_ecs_service" "onchain-poll-service" {
  name            = "${var.environment}-poll-service"
  cluster         = aws_ecs_cluster.onchain.id
  task_definition = aws_ecs_task_definition.onchain_poll_service.arn
  desired_count   = 1
   deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"

 network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
    assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb-poll-target-group.arn
    container_name   = "${var.environment}-poll"
    container_port   = 4002
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_appautoscaling_target" "poll-ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.onchain.name}/${aws_ecs_service.onchain-poll-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.poll-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.poll-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.poll-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageMemoryUtilization"
   }
 
   target_value       = 80
  }
}
resource "aws_appautoscaling_policy" "poll-ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.poll-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.poll-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.poll-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageCPUUtilization"
   }
 
   target_value       = 60
  }
}
##################################################

#ELB Target Group for Reward Service
resource "aws_lb_target_group" "nlb-reward-target-group" {
  name     = "${var.environment}-reward-target-group"
  port     = 4004
  protocol = "TCP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/reward-api/v1/health-check"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "reward-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4004
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-reward-target-group.arn
    type             = "forward"
  }
}


# ECS Service for Reward Service
resource "aws_ecs_service" "onchain-reward-service" {
  name            = "${var.environment}-reward-service"
  cluster         = aws_ecs_cluster.onchain.id
  task_definition = aws_ecs_task_definition.onchain_reward_service.arn
  desired_count   = 1
   deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"

 network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
    assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb-reward-target-group.arn
    container_name   = "${var.environment}-reward"
    container_port   = 4004
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}
resource "aws_appautoscaling_target" "reward-ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.onchain.name}/${aws_ecs_service.onchain-reward-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "reward-ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.reward-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.reward-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.reward-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageMemoryUtilization"
   }
 
   target_value       = 80
  }
}
resource "aws_appautoscaling_policy" "reward-ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.reward-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.reward-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.reward-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageCPUUtilization"
   }
 
   target_value       = 60
  }
}
##################################################

#NLB Target Group for BlockChain Service
resource "aws_lb_target_group" "nlb-blockchain-target-group" {
  name     = "${var.environment}-blockchain-tg"
  port     = 4003
  protocol = "TCP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/blockchain-api/v1/health-check"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "blockchain-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4003
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-blockchain-target-group.arn
    type             = "forward"
  }
}

# ECS Service
resource "aws_ecs_service" "onchain-blockchain-service" {
  name            = "${var.environment}-blockchain-service"
  cluster         = aws_ecs_cluster.onchain.id
  task_definition = aws_ecs_task_definition.onchain_blockchain_service.arn
  desired_count   = 1
   deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"

network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
    assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb-blockchain-target-group.arn
    container_name   = "${var.environment}-blockchain"
    container_port   = 4003
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}
resource "aws_appautoscaling_target" "blockchain-ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.onchain.name}/${aws_ecs_service.onchain-blockchain-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "blockchain-ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.blockchain-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.blockchain-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.blockchain-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageMemoryUtilization"
   }
 
   target_value       = 80
  }
}
resource "aws_appautoscaling_policy" "blockchain-ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.blockchain-ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.blockchain-ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.blockchain-ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageCPUUtilization"
   }
 
   target_value       = 60
  }
}

##################################################