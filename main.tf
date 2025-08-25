locals {
  jwt_authorizer = var.jwt_authorizer == null ? [] : [var.jwt_authorizer]
}

resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = var.protocol_type
  tags          = var.common_tags
}

resource "aws_apigatewayv2_domain_name" "api" {
  count       = var.custom_domain == null ? 0 : 1
  domain_name = var.custom_domain.name
  domain_name_configuration {
    certificate_arn = var.custom_domain.certificate_arn
    endpoint_type   = var.custom_domain.endpoint_type
    security_policy = var.custom_domain.security_policy
  }
}

resource "aws_apigatewayv2_api_mapping" "api" {
  count       = var.custom_domain == null ? 0 : 1
  api_id      = aws_apigatewayv2_api.api.id
  domain_name = aws_apigatewayv2_domain_name.api[count.index].domain_name
  stage       = aws_apigatewayv2_stage.api.name
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
