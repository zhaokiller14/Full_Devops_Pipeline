variable "cluster_name" {
  description = "Name of the KinD cluster"
  type        = string
  default     = "tp4-cluster"
}

variable "control_plane_port" {
  description = "Port to expose on the host machine"
  type        = number
  default     = 30080
}

variable "kubernetes_version" {
  description = "Kubernetes version for KinD cluster"
  type        = string
  default     = "v1.28"
}
