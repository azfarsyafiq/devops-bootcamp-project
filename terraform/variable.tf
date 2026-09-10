variable "az" {
  description = "Availability Zone untuk semua subnet"
  type        = string
  default     = "ap-southeast-1a"
}

variable "key_name" {
  description = "Nama key pair AWS untuk SSH access"
  type        = string
}

variable "web_server_private_ip" {
  description = "Private IP untuk web server"
  type        = string
  default     = "10.0.0.5"
}

variable "ansible_controller_private_ip" {
  description = "Private IP untuk ansible controller"
  type        = string
  default     = "10.0.0.135"
}

variable "monitoring_server_private_ip" {
  description = "Private IP untuk monitoring server"
  type        = string
  default     = "10.0.0.136"
}