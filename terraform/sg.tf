resource "aws_security_group" "loadbalancer_sg" {
  name        = "${local.app_name}_loadbalancer_sg"
  description = "Security Group for the ${local.app_name} loadbalancer"
  vpc_id      = var.vpc_id

  # Web Traffic Ports
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-LB-SecurityGroup"
    }
  )
}


resource "aws_security_group_rule" "moodle_lb_to_app" {
  type                     = "egress"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.moodle_internal_sg.id
  security_group_id        = aws_security_group.loadbalancer_sg.id
}

resource "aws_security_group" "moodle_internal_sg" {
  name        = "${local.app_name}_Moodle_internal_sg"
  description = "Security Group for the ${local.app_name} Moodle internal routing"
  vpc_id      = var.vpc_id

  # Allow only traffic inbound from LB
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    security_groups = [
      aws_security_group.loadbalancer_sg.id,
    ]
  }

  # Allow all egress, as this also allows updates and the like
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-Moodle-LB-SecurityGroup"
    }
  )
}

resource "aws_security_group" "app_lb_sg" {
  name        = "${local.app_name}_app_lb_sg"
  description = "Security Group for the ${local.app_name} app Load Balancer"
  vpc_id      = var.vpc_id

  # Allow only traffic inbound from Service
  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "tcp"

    security_groups = [
      aws_security_group.moodle_internal_sg.id,
    ]
  }

  # Allow only traffic inbound from Service
  ingress {
    from_port = "443"
    to_port   = "443"
    protocol  = "tcp"

    security_groups = [
      aws_security_group.moodle_internal_sg.id,
    ]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-app-SecurityGroup"
    }
  )
}

resource "aws_security_group_rule" "app_lb_to_app" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_internal_sg.id
  security_group_id        = aws_security_group.app_lb_sg.id
}

resource "aws_security_group" "app_internal_sg" {
  name        = "${local.app_name}_app_internal_sg"
  description = "Security Group for the ${local.app_name} app internal routing"
  vpc_id      = var.vpc_id

  # Allow only traffic inbound from LB
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    security_groups = [
      aws_security_group.app_lb_sg.id,
    ]
  }

  # Allow all egress, as this also allows updates and the like
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-app-SecurityGroup"
    }
  )
}

resource "aws_security_group" "efs_internal_sg" {
  name        = "${local.app_name}_EFS_internal_sg"
  description = "Security Group for the ${local.app_name} EFS internal routing"
  vpc_id      = var.vpc_id

  # Allow only traffic inbound from LB
  ingress {
    from_port = "2049"
    to_port   = "2049"
    protocol  = "tcp"

    security_groups = [
      aws_security_group.moodle_internal_sg.id,
    ]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-EFS-SecurityGroup"
    }
  )
}

resource "aws_security_group" "rds_internal_sg" {
  name        = "${local.app_name}_RDS_internal_sg"
  description = "Security Group for the ${local.app_name} RDS internal routing"
  vpc_id      = var.vpc_id

  # Allow only traffic inbound from LB
  ingress {
    from_port = "3306"
    to_port   = "3306"
    protocol  = "tcp"
    /*
    cidr_blocks = [
      "10.0.0.0/8",
    ]
    */
    security_groups = [
      aws_security_group.moodle_internal_sg.id,
    ]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.app_name}-RDS-SecurityGroup"
    }
  )
}