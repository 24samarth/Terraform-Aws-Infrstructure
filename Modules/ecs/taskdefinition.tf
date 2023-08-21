resource "aws_ecs_task_definition" "onchain_user_service" {
  family                = "${var.environment}-user"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
  memory                   = 512
container_definitions = <<DEFINITION
[
  {
    "name": "${var.environment}-user",
    "image": "${var.user_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 4001,
        "hostPort": 4001
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-user-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      }
  }
  
]
DEFINITION

  execution_role_arn = aws_iam_role.task-definition-role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

#Task definition Poll Service
resource "aws_ecs_task_definition" "onchain_poll_service" {
  family                = "${var.environment}-poll"
      network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
  memory                   = 512
  container_definitions = <<DEFINITION
[
  {
    "name": "${var.environment}-poll",
    "image": "${var.poll_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 4002,
        "hostPort": 4002
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-poll-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION
execution_role_arn = aws_iam_role.task-definition-role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

#Task definition Reward Service
resource "aws_ecs_task_definition" "onchain_reward_service" {
  family                = "${var.environment}-reward"
      network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
  memory                   = 512
  container_definitions = <<DEFINITION
[
  {
    "name": "${var.environment}-reward",
    "image": "${var.reward_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 4004,
        "hostPort": 4004
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-reward-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION
execution_role_arn = aws_iam_role.task-definition-role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

#Task definition UAT BlockChain Service
resource "aws_ecs_task_definition" "onchain_blockchain_service" {
  family                = "${var.environment}-blockchain"
      network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
  memory                   = 512
  container_definitions = <<DEFINITION
[
  {
    "name": "${var.environment}-blockchain",
    "image": "${var.blockchain_image}",
    "command": ["/bin/sh", "-c", "npm run pm2"],
    "portMappings": [
      {
        "containerPort": 4003,
        "hostPort": 4003
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-blockchain-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION
execution_role_arn = aws_iam_role.task-definition-role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}