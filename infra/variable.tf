variable "vpc_id" {
    description = "VPC ID"
    type = string

    default = "vpc-072deafed8194baf3"
}

variable "subnet_ids" {
    description = "list of subnet ids"
    type = list(string)

    default = [ "subnet-0651a1d40f169d587", "subnet-0689f583b79cc24a6" ]
}

variable "image" {
    description = "details of the docker image"
    type = string

    default = "hexice/pearlthoughts-hello-world:1.0"  
}