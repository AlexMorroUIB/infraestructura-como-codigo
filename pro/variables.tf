
variable "web_pro_instance_count" {
  type        = number
  description = "Number of web instances to deploy. This application requires at least three instances."
  default     = 3

  validation {
    condition     = var.web_pro_instance_count >= 3
    error_message = "This application requires at least two web instances."
  }
}