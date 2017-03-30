variable "identifier" {
  default     = "odoo-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.6.22"
    postgres = "9.6.2"
  }
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  default     = "mydb"
  description = "mydb name"
}

variable "username" {
  default     = "dbadmin"
  description = "dbadmin username"
}

variable "password" {
  description = "password, provide through your ENV variables"
}
