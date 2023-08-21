
resource "aws_api_gateway_vpc_link" "vpc_link" {
 name        = "${var.environment}-vpc-link"
 target_arns = [ aws_lb.nlb.arn ]
}

resource "aws_api_gateway_rest_api" "apigateway" {
  name        = "${var.environment}-api-gateway"
  description = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

################################################################3
resource "aws_api_gateway_resource" "user-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "user-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "user-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.user-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "user-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.user-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "user-integration" {
  http_method             = aws_api_gateway_method.user-method.http_method
  resource_id             = aws_api_gateway_resource.user-proxy.id
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:4001/{proxy+}"
  integration_http_method = "ANY"


  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}
#################################################################
resource "aws_api_gateway_resource" "poll-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "poll-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "poll-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.poll-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "poll-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.poll-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "poll-integration" {
  http_method             = aws_api_gateway_method.poll-method.http_method
  resource_id             = aws_api_gateway_resource.poll-proxy.id
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:4002/{proxy+}"
  integration_http_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}

#################################################################
resource "aws_api_gateway_resource" "blockchain-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "blockchain-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "blockchain-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.blockchain-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "blockchain-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.blockchain-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "blockchain-integration" {
  http_method             = aws_api_gateway_method.blockchain-method.http_method
  resource_id             = aws_api_gateway_resource.blockchain-proxy.id
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:4003/{proxy+}"
  integration_http_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}
#################################################################
resource "aws_api_gateway_resource" "reward-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "reward-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "reward-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.reward-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "reward-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.reward-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "reward-integration" {
  http_method             = aws_api_gateway_method.reward-method.http_method
  resource_id             = aws_api_gateway_resource.reward-proxy.id
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:4004/{proxy+}"
  integration_http_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}
#######################################################333333
# Create a deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.user-integration, aws_api_gateway_integration.blockchain-integration, aws_api_gateway_integration.poll-integration, aws_api_gateway_integration.reward-integration]
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  # stage_name
}
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  stage_name    = "${var.environment}"
}
