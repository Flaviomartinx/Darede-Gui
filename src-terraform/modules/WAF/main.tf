resource "aws_wafv2_web_acl" "waf_prod" {
  name        = var.waf_prod_name
  description = var.waf_prod_description
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.waf_metric_name
    sampled_requests_enabled   = true
  }

  rule {
    name     = var.waf_prod_rule_name
    priority = 1
    statement {
      managed_rule_group_statement {
        name        = var.waf_prod_rule_name
        vendor_name = var.vendor_name
      }
    }

    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = var.waf_prod_rule_name_cors
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = var.waf_sql_rule
    priority = 2

    statement {
      managed_rule_group_statement {
        name        = var.waf_sql_name_rule
        vendor_name = var.vendor_name
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = var.waf_sql_rule
      sampled_requests_enabled   = true
    }
  }
}
