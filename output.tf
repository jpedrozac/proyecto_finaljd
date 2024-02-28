output "app_url" {
  value = aws_lb.proyectolb.dns_name
}

output "aws_cloudfront_distribution" {
  value = aws_cloudfront_distribution.my_distrib.domain_name
}