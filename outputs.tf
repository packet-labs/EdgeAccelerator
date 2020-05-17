# Output variable definitions

output "deployed_edge_proxies_ipv4" {
  value = packet_device.nginx.*.access_public_ipv4
}

output "deployed_edge_proxies_ipv6" {
  value = packet_device.nginx.*.access_public_ipv6
}
