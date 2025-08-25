# Terraform AWS API Gateway

Este módulo crea un API Gateway v2 HTTP con soporte para autenticación JWT, dominios personalizados y rutas que se conectan a funciones Lambda.

## Módulo Principal

### Inputs

| Name           | Type         | Description                              | Required |
| -------------- | ------------ | ---------------------------------------- | -------- |
| name           | string       | API Gateway name                         | yes      |
| stage_name     | string       | API Gateway Stage                        | yes      |
| protocol_type  | string       | Protocol type (default: "HTTP")         | no       |
| jwt_authorizer | object       | [JWT Authorizer Object](#jwt-authorizer) | no       |
| custom_domain  | object       | [Custom Domain Object](#custom-domain)   | no       |
| common_tags    | map(string)  | Common tags                              | yes      |

### JWT Authorizer

| Name     | Type         | Description     | Required |
| -------- | ------------ | --------------- | -------- |
| name     | string       | Authorizer name | yes      |
| type     | string       | Authorizer type | yes      |
| audience | list(string) | Audience list   | yes      |
| issuer   | string       | Issuer          | yes      |



### Custom Domain

| Name            | Type   | Description                                               | Required |
| --------------- | ------ | --------------------------------------------------------- | -------- |
| name            | string | Domain name                                               | yes      |
| certificate_arn | string | ACM Certificate ARN                                       | yes      |
| endpoint_type   | string | Endpoint type for API Gateway **(Valid value: REGIONAL)** | yes      |
| security_policy | string | Certificate protocol                                      | yes      |


### Outputs

| Name                      | Type         | Description                  |
| ------------------------- | ------------ | ---------------------------- |
| api_endpoint              | string       | The API endpoint URL         |
| api_name                  | string       | The API Gateway name         |
| api_gateway_id            | string       | The API Gateway ID           |
| api_gateway_execution_arn | string       | The API Gateway execution ARN |
| api_gateway_authorizer_ids| list(string) | The API Gateway authorizer IDs |

## Submódulo function-route

Este submódulo permite agregar rutas y integraciones con funciones Lambda a un API Gateway existente.

### Inputs

| Name           | Type         | Description                  | Required |
| -------------- | ------------ | ---------------------------- | -------- |
| api_gateway_id | string       | API Gateway ID               | yes      |
| routes         | list(object) | [List of routes](#routes-1)  | yes      |
| authorizer_id  | string       | Authorizer ID                | no       |
| common_tags    | map(string)  | Common tags                  | yes      |

### Routes

| Name               | Type             | Description                  | Required |
| ------------------ | ---------------- | ---------------------------- | -------- |
| path               | string           | Path to server requests      | yes      |
| method             | string           | HTTP method to serve request | yes      |
| authorization_type | optional(string) | Authorization type           | no       |
| function_name      | string           | Lambda function name         | yes      |
| function_qualifier | optional(string) | Lambda function qualifier    | no       |

### Outputs

| Name                   | Type         | Description                   |
| ---------------------- | ------------ | ----------------------------- |
| route_ids              | list(string) | The API Gateway route IDs     |
| integration_ids        | list(string) | The API Gateway integration IDs |
| lambda_permission_ids  | list(string) | The Lambda permission IDs     |

## Uso

### Módulo principal solamente

```hcl
module "api_gateway" {
  source = "path/to/terraform-aws-api-gateway"
  
  name        = "my-api"
  stage_name  = "prod"
  common_tags = {
    Environment = "production"
    Project     = "my-project"
  }
  
  jwt_authorizer = {
    name     = "jwt-auth"
    type     = "JWT"
    audience = ["api.example.com"]
    issuer   = "https://auth.example.com"
  }
  
  custom_domain = {
    name            = "api.example.com"
    certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/..."
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
```

### Con submódulo function-route

```hcl
module "api_gateway" {
  source = "path/to/terraform-aws-api-gateway"
  
  name        = "my-api"
  stage_name  = "prod"
  common_tags = {
    Environment = "production"
    Project     = "my-project"
  }
}

module "api_routes" {
  source = "path/to/terraform-aws-api-gateway//function-route"
  
  api_gateway_id = module.api_gateway.api_gateway_id
  authorizer_id  = module.api_gateway.api_gateway_authorizer_ids[0]
  
  routes = [
    {
      path               = "/users"
      method             = "GET"
      authorization_type = "JWT"
      function_name      = "my-users-function"
    },
    {
      path               = "/users/{id}"
      method             = "POST"
      authorization_type = "JWT"
      function_name      = "my-user-update-function"
      function_qualifier = "prod"
    }
  ]
  
  common_tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```