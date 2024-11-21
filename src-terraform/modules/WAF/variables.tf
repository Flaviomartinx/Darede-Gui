variable "waf_prod_name" {
  description = "Nome do WAF Web ACL"
  type        = string
  default = "my-waf-prod"
}

variable "waf_prod_description" {
  description = "Descrição do WAF Web ACL"
  type        = string
  default = "WAF Web ACL for production"
}

variable "waf_metric_name" {
  description = "Nome do métrico no CloudWatch para o WAF"
  type        = string
  default = "my-waf-metrics"
}

variable "waf_prod_rule_name" {
  description = "Nome da regra para Core Rule Set"
  type        = string
  default = "AWSManagedRulesCommonRuleSet"
}

variable "waf_prod_rule_name_cors" {
  type    = string
  default = "aws_managed_rules_crs"
}

variable "waf_sql_rule" {
  description = "Nome da regra de SQL Injection"
  type        = string
  default = "SQLInjectionRule"
}

variable "waf_sql_name_rule" {
  description = "Nome do conjunto de regras gerenciadas para SQL"
  type        = string
  default = "AWSManagedRulesSQLiRuleSet"
}

variable "vendor_name" {
  description = "Nome do fornecedor da regra gerenciada (ex: AWS, OWASP)"
  type        = string
  default     = "AWS"
}