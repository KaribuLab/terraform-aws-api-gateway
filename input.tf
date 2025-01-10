variable "name" {
  type        = string
  description = "API Gateway name"

}

variable "stage_name" {
  type        = string
  description = "Stage name"
}

variable "jwt_authorizer" {
  type = object({
    name     = string
    type     = string
    audience = list(string)
    issuer   = string
  })
  description = "JWT Authorizer"
  default     = null
}


variable "routes" {
  type = list(object({
    path               = string
    method             = string
    authorization_type = optional(string)
    function_name      = string
  }))
  description = "API Gateway routes"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "protocol_type" {
  type        = string
  description = "Protocol type"
  default     = "HTTP"

}

variable "custom_domain" {
  type = object({
    name            = string
    certificate_arn = string
    endpoint_type   = string
    security_policy = string
  })
  description = "Custom domain"
  default     = null

}
