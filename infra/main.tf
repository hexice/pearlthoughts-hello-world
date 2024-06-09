resource "aws_ecs_cluster" "ecs_cluster" {
  name = "pearlthoughts-cluster"
  
  tags = {
    Name = "pearlthoughts-cluster"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "hello-world-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name  = "hello-world-container"
      image = var.image
      cpu   = 256
      memory = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.custom_sg.id] 
    assign_public_ip = true
  }

  
}

resource "aws_security_group" "custom_sg" {
  name        = "hello-world-ecs-service-sg"
  description = "Allow inbound traffic on port 80 from my IP"
  vpc_id      = var.vpc_id 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow HTTP traffic from my IP"
    cidr_blocks = ["103.252.166.140/32"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hello-world-ecs-service-sg"
  }
}

