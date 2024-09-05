# Terraform AWS Function

This module creates a straightforward API Gateway v2 Proxy that trigger a Lambda Function.

## Inputs

| Name          | Type         | Description                | Required |
| ------------- | ------------ | -------------------------- | -------- |
| function_name | string       | Name of lambda function    | yes      |
| stage_name    | string       | API Gateway Stage          | yes      |
| routes        | list(object) | [List of routes](#routes)  | yes      |
| invoke_arn    | string       | Lambda function invoke ARN | yes      |
| common_tags   | map(string)  | Common tags                | yes      |

### Routes

| Name   | Type   | Description                  | Required |
| ------ | ------ | ---------------------------- | -------- |
| path   | string | Path to server requests      | yes      |
| method | string | HTTP method to serve request | yes      |

## Outputs

| Name          | Type   | Description          |
| ------------- | ------ | -------------------- |
| function_name | string | Lambda function name |
| invoke_arn    | string | Function invoke ARN  |
| lambda_arn    | string | Function ARN         |