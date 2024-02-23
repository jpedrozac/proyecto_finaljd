#creación de ECR

resource "aws_ecr_repository" "proyecto_ecr" {
  name                 = "proyecto_final"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
/*
output "demo_app_repo_url" {
  value = aws_ecr_repository.ecrProyFinal.repository_url
}
*/