# Load Balancer
resource "aws_lb" "proyectolb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http_sg.id]
  subnets            = [aws_subnet.finaltf1.id, aws_subnet.finaltf2.id]
}

resource "aws_lb_target_group" "proyectolbtg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.finaltf.id
}

resource "aws_lb_listener" "proyectolistener" {
  load_balancer_arn = aws_lb.proyectolb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proyectolbtg.arn
  }

}
# S3
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = data.aws_s3_bucket.proyecto_bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = data.aws_s3_bucket.proyecto_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "cdn-oac-bucket-policy" {
  bucket = data.aws_s3_bucket.proyecto_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}
#Cloudfront
resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = "CloudFront S3 OAC"
  description                       = "Cloud Front S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_distribution" "my_distrib" {
  enabled = true
  origin {
    domain_name              = data.aws_s3_bucket.proyecto_bucket.bucket_regional_domain_name
    origin_id                = "bucketPrimary"
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "bucketPrimary"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  depends_on = [data.aws_s3_bucket.proyecto_bucket, aws_cloudfront_origin_access_control.cloudfront_s3_oac]
}
#ECS
resource "aws_ecs_cluster" "proyecto_cluster" {
  name = "proyecto"
}
resource "aws_ecs_cluster_capacity_providers" "proyecto-clustercp" {
  cluster_name       = aws_ecs_cluster.proyecto_cluster.name
  capacity_providers = ["FARGATE"]
  depends_on         = [aws_ecs_cluster.proyecto_cluster]
}
resource "aws_ecs_task_definition" "proyecto-svctd" {
  family                   = var.name-01
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  network_mode = "awsvpc"
  cpu          = 256
  memory       = 512
container_definitions = jsonencode([
  {
    name          = "conteinerProyectoFinal",
    image         = "${aws_ecr_repository.proyecto_ecr.repository_url}:latest",
    cpu           = 256 
    memory        = 512
    essential     = true,
    portMappings  = [{ containerPort = 80, hostPort = 80 }],
  }
  ])

}
resource "aws_ecs_service" "proyecto-svc" {
  name                = var.name-01
  cluster             = aws_ecs_cluster.proyecto_cluster.id
  task_definition     = aws_ecs_task_definition.proyecto-svctd.arn
  desired_count       = 0
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  network_configuration {
    security_groups  = [aws_security_group.http_sg.id]
    subnets          = [aws_subnet.finaltf1.id, aws_subnet.finaltf2.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.proyectolbtg.id
    container_name   = var.name-01
    container_port   = var.containerPort-01    
  }
  depends_on = [aws_ecs_cluster.proyecto_cluster, aws_ecs_task_definition.proyecto-svctd, aws_security_group.http_sg, aws_subnet.finaltf1, aws_subnet.finaltf2, aws_lb_target_group.proyectolbtg]
}


