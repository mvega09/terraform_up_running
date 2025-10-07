output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "El nombre de dominio del balanceador de carga"
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "El nombre del Grupo de Auto Escalado"
}

output "instance_security_group_id" {
  value       = module.asg.instance_security_group_id
  description = "El ID del Grupo de Seguridad de la Instancia EC2"
}

