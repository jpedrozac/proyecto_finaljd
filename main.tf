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