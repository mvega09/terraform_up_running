output "alb_dns_name" {
  value       = module.hello_world_app.alb_dns_name
  description = "El nombre de dominio del balanceador de carga"
}