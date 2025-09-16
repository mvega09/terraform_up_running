output "address" {
  value       = aws_db_instance.example.address
  description = "conecta a la base de datos en este endpoint"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "el puerto para conectarse a la base de datos"
}

output "arn" {
  value       = aws_db_instance.example.arn
  description = "The ARN of the database"
}