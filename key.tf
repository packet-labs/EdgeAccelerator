resource "tls_private_key" "key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "packet_ssh_key" "packet_key" {
  name       = "edgeaccelerator-deployment-key"
  public_key = tls_private_key.key.public_key_openssh
}

