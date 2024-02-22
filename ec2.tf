# Crear una instancia EC2
resource "aws_instance" "my_instance" {
  ami           = "ami-0440d3b780d96b29d"  # Especifica la AMI de tu elección
  instance_type = "t2.micro"      # Especifica el tipo de instancia

  subnet_id     = aws_subnet.finaltf1.id  # Asigna la instancia a una de las subredes públicas creadas
  # key_name      = "my-key-pair"  # Especifica el nombre de tu par de claves SSH

  # Configura los detalles de la instancia según tus necesidades
  # Por ejemplo, puedes especificar la configuración de usuario, almacenamiento, etc.
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
  EOF

  # Asigna un Security Group que permita el tráfico HTTP (puerto 80) desde cualquier dirección
  security_groups = [aws_security_group.http_sg.id]
}

# Crear un Security Group para permitir el tráfico HTTP
resource "aws_security_group" "http_sg" {
  name        = "allow-http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.finaltf.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear una regla de salida para permitir todo el tráfico
resource "aws_security_group_rule" "http_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.http_sg.id
}