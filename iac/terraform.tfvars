jenkins = {
  name                  = "Jenkins-Server"
  ami_id                = "ami-0c614dee691cbbf37"
  user                  = "ec2-user"
  key_name              = "my-key"
  jenkins_password_file = "/var/lib/jenkins/secrets/initialAdminPassword"
  instance_type         = "t3.medium"
}