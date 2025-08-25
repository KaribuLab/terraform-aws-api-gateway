output "route_ids" {
  value       = aws_apigatewayv2_route.api[*].id
  description = "The API Gateway route IDs"
}

output "integration_ids" {
  value       = aws_apigatewayv2_integration.api[*].id
  description = "The API Gateway integration IDs"
}

output "lambda_permission_ids" {
  value       = aws_lambda_permission.api[*].id
  description = "The Lambda permission IDs"
}