#AWS Configs
provider "aws" {
    region = "us-east-2"
}

# Tipos de Environment para tag:PROJETO [0,1,2]
variable "projeto" {
    type = "list"
    default = ["PROD","HOMOLOG","SHARED"]  
}

variable "name" {
    type = "string"
    default = "master-k8s-desenvolvimento"
}
variable "dns" {
    type = "string"
    default = "internal-service.com.br"
}

## K8S Master
resource "aws_instance" "k8s-master" {
    count = 1
    ami = "ami-0d8f6eb4f641ef691"
    instance_type = "t2.micro"
    tags = {
        Name = "${format("${var.name}-%02d",count.index+1)}"
        PROJETO = "COMUM-${var.projeto[2]}"
        DNS = "${format("${var.name}-%02d",count.index+1)}"
    }
    key_name = "portabilidade-ohio"
    user_data = <<-EOF
                    #!/bin/bash
                    hostname = "${format("${var.name}-%02d",count.index+1)}"
                    echo $hostname > /home/cf-syn.txt 
                    netFile="/etc/sysconfig/network" 
                    sed -i "s/HOSTNAME=.*/HOSTNAME=$hostname/" $netFile 
                    yum update -y
                    EOF
}