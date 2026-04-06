import {
  to = kubernetes_namespace.demo
  id = "cortex-drift-demo"
}

import {
  to = aws_s3_bucket.example
  id = "my-cortex-demo-bucket-unique-id"
}

import {
  to = kubernetes_deployment.nginx
  id = "cortex-drift-demo/nginx-deployment"
}

import {
  to = kubernetes_service.nginx
  id = "cortex-drift-demo/nginx-service"
}
