# Ansible Task 1

1. Structure
 - Terraform
    - ubuntu-webserver-1
    - debian-webserver-2
    - nginx-load-balancer
  - Ansible
    - lb.yml for configuring load-balancer
    - nginxweb for configuring webserver
    - index.j2 template for updating webpage
    - default.j2 for configuring nginx lb

2. Steps
  - To create following infrastructure we need to clone the repo and update terraform.tfvars file

  - Run following commands to deploy
  ```
  terraform init
  terraform plan
  terraform apply --auto-approve
  ```  
  - Each compute instance has provisioner block to execute ansible commands
  ```
  provisioner "remote-exec" {
    inline = ["echo 'Hello world!'"]
    connection {
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      user        = "vlad"
      private_key = file(var.ssh_key_private)
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i '${self.network_interface.0.access_config.0.nat_ip},' nginxweb.yml"
  }
  ```
