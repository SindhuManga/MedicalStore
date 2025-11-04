variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  default     = "My_Key_Pair"
}

variable "ecr_repo_url" {
  description = "ECR repository URL of the Docker image"
  default     = "944731154859.dkr.ecr.us-east-1.amazonaws.com/ecr-repo"
}

variable "security_group_name" {
  description = "Security group name for EC2 instance"
  default     = "jenkins-ec2-sg"
}
