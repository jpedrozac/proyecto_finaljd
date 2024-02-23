
resource "aws_instance" "my_instance" {
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = "t2.micro"     

  subnet_id     = aws_subnet.finaltf1.id  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
  EOF


  security_groups = [aws_security_group.http_sg.id]
}


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

resource "aws_security_group_rule" "http_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.http_sg.id
}