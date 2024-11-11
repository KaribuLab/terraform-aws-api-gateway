locals {
  jwt_authorizer = var.jwt_authorizer == null ? [] : [var.jwt_authorizer]
}

resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = var.protocol_type
  tags          = var.common_tags
}

resource "aws_apigatewayv2_authorizer" "api" {
  count            = length(local.jwt_authorizer)
  api_id           = aws_apigatewayv2_api.api.id
  authorizer_type  = local.jwt_authorizer[count.index].type
  identity_sources = ["$request.header.Authorization"]
  name             = local.jwt_authorizer[count.index].name

  jwt_configuration {
    audience = local.jwt_authorizer[count.index].audience
    issuer   = local.jwt_authorizer[count.index].issuer
  }
}

resource "aws_apigatewayv2_stage" "api" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = var.stage_name
  auto_deploy = true
}

data "aws_lambda_function" "function" {
  count         = length(var.routes)
  function_name = var.routes[count.index].function_name
}

resource "aws_apigatewayv2_integration" "api" {
  count            = length(var.routes)
  api_id           = aws_apigatewayv2_api.api.id
  integration_uri  = data.aws_lambda_function.function[count.index].invoke_arn
  integration_type = "AWS_PROXY"
}

resource "aws_apigatewayv2_route" "api" {
  count              = length(var.routes)
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "${var.routes[count.index].method} ${var.routes[count.index].path}"
  target             = "integrations/${aws_apigatewayv2_integration.api[count.index].id}"
  authorization_type = var.routes[count.index].authorization_type == null ? "NONE" : var.routes[count.index].authorization_type
}

resource "aws_lambda_permission" "api" {
  count         = length(var.routes)
  action        = "lambda:InvokeFunction"
  function_name = var.routes[count.index].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
