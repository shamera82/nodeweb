## All the variables

# for provider
variable "profile" {
  description = "The AWS Profile to be deployed against"
}
variable "region" {
  description = "The AWS Region to be deployed against"
  default     = "us-west-2"
}

# for ecs
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "EcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

# app 
variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "app:latest"
}

variable "env_variables_app"{
  description = "Docker image to run in the ECS cluster"
  default = [
    {
      "name": "MYSQL_DATABASE",
      "value": "mydb"
    },
    {
      "name": "MYSQL_ROOT_USER",
      "value": "root"
    },
    {
      "name": "MYSQL_ROOT_PASSWORD",
      "value": "password"
    },
    {
      "name": "MYSQL_HOST"
      "value": "nodedbserver"
    },
    {
      "name": "APP_SVR_NAME"
      "value": "nodeappserver"
    }
  ]
}
variable "app_count" {
  description = "Number of app docker containers to run"
  default     = 1
}

variable "fargate_cpu_app" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory_app" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "health_check_path_app" {
  default = "/"
}

# web
variable "web_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "web:latest"
}

variable "web_count" {
  description = "Number of web docker containers to run"
  default     = 1
}

variable "fargate_cpu_web" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory_web" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "health_check_path_web" {
  default = "/"
}

# db
variable "db_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "db:latest"
}

variable "db_count" {
  description = "Number of db docker containers to run"
  default     = 1
}

variable "fargate_cpu_db" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory_db" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "health_check_path_db" {
  default = "/"
}