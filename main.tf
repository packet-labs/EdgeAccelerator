
provider "packet" {
  auth_token = var.packet_auth_token
}

# listen on both IPv4 and IPv6
data "template_file" "reverse-proxy-conf" {

  template =<<EOT
server {
    listen [::]:80;
    listen 80;
    location / {
        proxy_pass $${origin_url};
    }
}
EOT

  vars = {
    origin_url = var.origin_url
  }
}

resource "packet_device" "nginx" {
  depends_on       = [packet_ssh_key.packet_key]

  plan             = "c3.medium.x86"
  project_id       = var.packet_project_id

  count            = length(var.edges)

  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"

  facilities       = [var.edges[count.index]]
  hostname         = format("nginx-%s",var.edges[count.index])

  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get -y update", 
      "apt-get -y install nginx",
      "unlink /etc/nginx/sites-enabled/default",
    ]
  }

  provisioner "file" {
    content     = data.template_file.reverse-proxy-conf.rendered
    destination = "/etc/nginx/sites-enabled/reverse-proxy.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "service nginx restart",
    ]
  }
}
