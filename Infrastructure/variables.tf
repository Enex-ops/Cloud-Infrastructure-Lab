variable "monthly_budget_limit"{
    description = "The maximum budget limit for the month in USD."
    type        = number
    default     = 1
}

variable "alert_email" {
    description = "The email address to send budget alerts to."
    type        = string
    default     = "campage1999@gmail.com"
}
