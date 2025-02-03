provider "aws" {
  region = "us-east-1"
}

provider "time" {}

module "jenkins_instance" {
  source = "./src/modules/jenkins"

  jenkins = {
    name = var.jenkins.name
    user                  = var.jenkins.user
    key_name              = var.jenkins.key_name
    jenkins_password_file = var.jenkins.jenkins_password_file
    instance_type         = var.jenkins.instance_type
    ami_id                = var.jenkins.ami_id
  }
}