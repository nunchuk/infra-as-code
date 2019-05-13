resource "null_resource" "install_docker" {

  provisioner "remote-exec" {

    connection {
        host     = "${var.host}"
        type     = "ssh"
        user     = "root"
        password = "${var.root_password}"
    }

    inline = [
      "wget -qO- https://get.docker.com/ | sh"
    ]
  }
}

resource "null_resource" "run_mysql" {

  provisioner "remote-exec" {

    connection {
        host     = "${var.host}"
        type     = "ssh"
        user     = "root"
        password = "${var.root_password}"
    }

    inline = [
      "docker run --name wordpress-mysql -v /srv/docker/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=${var.mysql_password} -d mysql:5.7"
    ]
  }
  depends_on = ["null_resource.install_docker"]
}

resource "null_resource" "run_wordpress" {

  provisioner "remote-exec" {

    connection {
        host     = "${var.host}"
        type     = "ssh"
        user     = "root"
        password = "${var.root_password}"
    }

    inline = [
      "docker run --name wordpress -d -p 80:80 -e WORDPRESS_DB_HOST=${var.host} -e WORDPRESS_DB_PASSWORD=${var.mysql_password} wordpress"
    ]
  }
  depends_on = ["null_resource.run_mysql"]
}
