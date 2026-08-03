output "name_servers" {
  value       = aws_route53_zone.root.name_servers
  description = "Nameservers to be used with domain provider"
}

output "zone_id" {
  value       = aws_route53_zone.root.zone_id
}