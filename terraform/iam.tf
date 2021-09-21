data "aws_iam_role" "ecs-service-role" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_iam_role" "ecs_task_assume" {
  name = "${local.app_name}-ecs_task_assume"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "ecs_task_assume" {
  name = "${local.app_name}-ecs_task_assume"
  role = aws_iam_role.ecs_task_assume.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
             "Effect": "Allow",
             "Action": [
                 "ssm:DescribeParameters"
             ],
             "Resource": "*"
         },
         {
             "Sid": "GetParam",
             "Effect": "Allow",
             "Action": [
                 "ssm:GetParameters"
             ],
             "Resource": [
                 "arn:aws:ssm:ap-southeast-2:${data.aws_caller_identity.current.account_id}:parameter/tst/coderunner/*"
             ]
         }
    ]
}
EOF

}

resource "aws_iam_role" "app_task_assume" {
  name = "${local.app_name}-app_task_assume"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "app_task_assume" {
  name = "${local.app_name}-app_task_assume"
  role = aws_iam_role.app_task_assume.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}