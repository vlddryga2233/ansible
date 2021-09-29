# Ansible Task 1

1. Structure
 - Terraform
    - ubuntu-webserver-1
    - debian-webserver-2
    - nginx-load-balancer
  - Ansible
    - [lb.yml](./lb.yml) for configuring load-balancer
    - [nginxweb](./nginxweb.yml) for configuring webserver
    - roles folder which contain ansible code for reusing
     - [configure_load_balancer](./roles/configure_load_balancer) (create config file for nginx)
     - [deploy_fortune](./roles/deploy_fortune) (deploy python app ang configure webserver)
     - [deploy_nginx](./roles/deploy_nginx) (install nginx)
     - [install_fcgiwrap_and_fortune](./roles/install_fcgiwrap_and_fortune) (install following programs )

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
