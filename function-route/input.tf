variable "api_gateway_id" {
  type        = string
  description = "API Gateway name"
}

variable "routes" {
  type = list(object({
    path               = string
    method             = string
    authorization_type = optional(string)
    function_name      = string
    function_qualifier = optional(string)
  }))
  description = "API Gateway routes"
}

variable "authorizer_id" {
  type        = string
  description = "Authorizer ID"
  default     = null
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}
