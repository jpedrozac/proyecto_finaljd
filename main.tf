# Creación del Load Balancer 
module "load_balancer" {
  source = "./modules/load_balancer"

}

# Creación de ECS 
module "ecs" {
  source = "./modules/ecs"

}

# Configuración de S3 y CloudFront
module "s3_cloudfront" {
  source = "./modules/s3_cloudfront"

}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.main.id
  key    = "index.html"
  source = "index.html"
}

resource "aws_s3_bucket" "main" {
  # Configuración del bucket S3
}