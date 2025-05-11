resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = "${aws_ecr_repository.api.repository_url}:latest"
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "ASPNETCORE_URLS",
          value = "http://+:80"
        },
        {
          name  = "ASPNETCORE_ENVIRONMENT",
          value = "Development"
        },
        {
          name  = "Jwt__ExpiryHours",
          value = "1"
        },
        {
          name  = "Jwt__Issuer",
          value = "StellarPathAPI"
        },
        {
          name  = "Jwt__Audience",
          value = "StellarPathUser"
        }
      ]
      secrets = [
        {
          name      = "GoogleAuth__ClientId"
          valueFrom = aws_secretsmanager_secret.google_client_id.arn
        },
        {
          name      = "Jwt__SecretKey"
          valueFrom = aws_secretsmanager_secret.jwt_secret.arn
        },
        {
          name      = "ConnectionStrings__DefaultConnection"
          valueFrom = aws_secretsmanager_secret.db_connection.arn
        },

        {
          name      = "Nasa__ApiKey"
          valueFrom = aws_secretsmanager_secret.api_key_1.arn
        },
        {
          name      = "PlanetsAPI__ApiKey"
          valueFrom =  aws_secretsmanager_secret.api_key_2.arn
          
          

        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}",
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = "ecs"
        }
      }
      essential = true
    }
  ])
}

resource "aws_ecs_service" "api" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = var.app_name
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7
}
