

variable "web_dev_instance_count" {
  type        = number
  description = "Number of web instances to deploy. This application requires at least two instances."
  default     = 2

  validation {
    condition     = var.web_dev_instance_count >= 2
    error_message = "This application requires at least two web instances."
  }
}