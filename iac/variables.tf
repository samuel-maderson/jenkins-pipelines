variable "jenkins" {
  type = object({
    name                  = string
    user                  = string
    key_name              = string
    jenkins_password_file = string
    instance_type         = string
    ami_id                = string
  })
}