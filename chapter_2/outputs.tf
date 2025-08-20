// Output: Muestra la dirección IP pública de la instancia EC2 creada.
// Esto permite acceder fácilmente al servidor web desde el navegador.
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the web server"
}