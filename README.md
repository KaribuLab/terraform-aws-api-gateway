# Terraform AWS Function

This module creates a straightforward API Gateway v2 Proxy that trigger a Lambda Function.

## Inputs

| Name           | Type         | Description                              | Required |
| -------------- | ------------ | ---------------------------------------- | -------- |
| name           | string       | API Gateway name                         | yes      |
| stage_name     | string       | API Gateway Stage                        | yes      |
| jwt_authorizer | object       | [JWT Authorizer Object](#jwt-authorizer) | no       |
| routes         | list(object) | [List of routes](#routes)                | yes      |
| custom_domain  | object       | [Custom Domain Object](#custom-domain)   | no       |
| common_tags    | map(string)  | Common tags                              | yes      |

### JWT Authorizer

| Name     | Type         | Description     | Required |
| -------- | ------------ | --------------- | -------- |
| name     | string       | Authorizer name | yes      |
| type     | string       | Authorizer type | yes      |
| audience | list(string) | Audience list   | yes      |
| issuer   | string       | Issuer          | yes      |

### Routes

| Name               | Type             | Description                  | Required |
| ------------------ | ---------------- | ---------------------------- | -------- |
| path               | string           | Path to server requests      | yes      |
| method             | string           | HTTP method to serve request | yes      |
| authorization_type | optional(string) | Authorization type           | no       |
| function_name      | string           | Lambda function name         | yes      |

### Custom Domain

| Name            | Type   | Description                                               | Required |
| --------------- | ------ | --------------------------------------------------------- | -------- |
| name            | string | Domain name                                               | yes      |
| certificate_arn | string | ACM Certificate ARN                                       | yes      |
| endpoint_type   | string | Endpoint type for API Gateway **(Valid value: REGIONAL)** | yes      |
| security_policy | string | Certificate protocol                                      | yes      |


## Outputs

| Name          | Type   | Description          |
| ------------- | ------ | -------------------- |
| function_name | string | Lambda function name |
| invoke_arn    | string | Function invoke ARN  |
| lambda_arn    | string | Function ARN         |