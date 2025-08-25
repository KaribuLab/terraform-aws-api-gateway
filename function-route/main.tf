data "aws_apigatewayv2_api" "api" {
  api_id = var.api_gateway_id
}

data "aws_lambda_function" "function" {
  count         = length(var.routes)
  function_name = var.routes[count.index].function_name
  qualifier     = var.routes[count.index].function_qualifier == null ? "$LATEST" : var.routes[count.index].function_qualifier
}


resource "aws_apigatewayv2_integration" "api" {
  count            = length(var.routes)
  api_id           = data.aws_apigatewayv2_api.api.id
  integration_uri  = var.routes[count.index].function_qualifier == null ? data.aws_lambda_function.function[count.index].invoke_arn : data.aws_lambda_function.function[count.index].qualified_invoke_arn
  integration_type = "AWS_PROXY"
}

resource "aws_apigatewayv2_route" "api" {
  count              = length(var.routes)
  api_id             = data.aws_apigatewayv2_api.api.id
  route_key          = "${var.routes[count.index].method} ${var.routes[count.index].path}"
  target             = "integrations/${aws_apigatewayv2_integration.api[count.index].id}"
  authorizer_id      = var.authorizer_id
  authorization_type = var.routes[count.index].authorization_type == null ? "NONE" : var.routes[count.index].authorization_type
}

resource "aws_lambda_permission" "api" {
  count         = length(var.routes)
  action        = "lambda:InvokeFunction"
  function_name = var.routes[count.index].function_qualifier == null ? data.aws_lambda_function.function[count.index].function_name : "${data.aws_lambda_function.function[count.index].function_name}:${var.routes[count.index].function_qualifier}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${data.aws_apigatewayv2_api.api.execution_arn}/*/*"
}
