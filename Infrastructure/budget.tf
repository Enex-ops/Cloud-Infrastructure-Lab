resource "aws_budgets_budget" "monthly_cost" {
  name         = "lab-cloud-monthly-budget"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_limit
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 75
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"

    subscriber_email_addresses = [
      var.alert_email
    ]
  }
}
