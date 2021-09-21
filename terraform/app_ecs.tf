#### LOADBALANCER CHANGES ####
resource "aws_lb_listener_rule" "app-routing" {
  listener_arn = aws_alb_listener.app-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-Service.id
  }

  condition {
    host_header {
      values = [var.app_dns_name]
    }
  }
}

resource "aws_alb_target_group" "app-Service" {
  name        = "${local.app_name}-app"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/app/index.php/restapi/languages"
    timeout             = "10"
    interval            = "30"
    matcher             = "200"
    unhealthy_threshold = 10
  }
}

#### ECS SERVICE DEFINITIONS ####
resource "aws_ecs_service" "app-Service" {
  name                    = "${local.app_name}-app"
  cluster                 = aws_ecs_cluster.containers.id
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"
  platform_version        = "1.4.0"
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-app-Service"
    }
  )
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 0
    base              = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
    base              = 0
  }
  task_definition = "${aws_ecs_task_definition.app.family}:${max(
    aws_ecs_task_definition.app.revision,
    data.aws_ecs_task_definition.app.revision,
  )}"

  desired_count = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.app_internal_sg.id]
  }
  # LB needs to be disabled on first run due to 
  # how long the initial run takes to complete.
  # Conditional block?
  load_balancer {
    target_group_arn = aws_alb_target_group.app-Service.id
    container_name   = "${local.app_name}-app"
    container_port   = 80
  }

  lifecycle {
    # create_before_destroy = true
    ignore_changes = [desired_count]
  }
}

#### ECS TASK DEFINITIONS ####
data "aws_ecs_task_definition" "app" {
  task_definition = aws_ecs_task_definition.app.family
  depends_on      = [aws_ecs_task_definition.app]
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${local.app_name}-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.app_task_assume.arn
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-app-task-definition"
    },
  )

  container_definitions = <<DEFINITION
[
  {
    "essential": true,
    "networkMode": "awsvpc",
    "image": "${var.app_image}",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${local.cw_log_group}",
          "awslogs-region": "ap-southeast-2",
          "awslogs-stream-prefix": "${local.app_name}-app"
        }
    },
    "name": "${local.app_name}-app",
    "portMappings": [
        {
            "hostPort": 80,
            "containerPort": 80
        }
    ]
  }
]
DEFINITION

}