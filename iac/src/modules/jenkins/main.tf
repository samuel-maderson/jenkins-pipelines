resource "time_sleep" "wait_150_seconds" {
  # Delay for 10 seconds
  create_duration = "${local.timeout}s"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "${var.jenkins.name}-group"
  description = "Allow SSH and Jenkins"

  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = local.jenkins_port
    to_port     = local.jenkins_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami             = var.jenkins.ami_id # Replace with your preferred AMI ID
  instance_type   = var.jenkins.instance_type
  key_name        = var.jenkins.key_name # Replace with your key pair name
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-17-amazon-corretto
              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install -y jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              sudo yum install -y docker
              sudo systemctl enable --now docker
              sudo usermod -aG docker jenkins
              sudo systemctl restart jenkins
              EOF

  tags = {
    Name = var.jenkins.name
  }
}

resource "null_resource" "read_jenkins_password" {
  connection {
    type        = "ssh"
    host        = "${aws_instance.jenkins.public_ip}"
    user        = var.jenkins.user
    private_key = file("${var.jenkins.key_name}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cat ${var.jenkins.jenkins_password_file}"
    ]
  }

  depends_on = [ aws_instance.jenkins, time_sleep.wait_150_seconds ]
}

output "my_instance_ip" {
    value = aws_instance.jenkins.public_ip
}