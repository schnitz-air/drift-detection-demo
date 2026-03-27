variable "namespace" {
  description = "The Kubernetes namespace to deploy the demo resources into"
  type        = string
  default     = "cortex-drift-demo"
}

variable "replicas" {
  description = "The number of replicas for the Nginx deployment"
  type        = number
  default     = 2
}
