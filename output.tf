output api_endpoint {
  value       = aws_apigatewayv2_stage.api.invoke_url
  description = "The API endpoint"
}

output api_name {
  value       = aws_apigatewayv2_api.api.name
  description = "The API name"
}

output api_gateway_id {
  value       = aws_apigatewayv2_api.api.id
  description = "The API Gateway ID"
}

output "api_gateway_execution_arn" {
  value       = aws_apigatewayv2_api.api.execution_arn
  description = "The API Gateway execution ARN"
}

output "api_gateway_authorizer_ids" {
  value       = aws_apigatewayv2_authorizer.api[*].id
  description = "The API Gateway authorizer ID"
}