resource "aws_iam_server_certificate" "odoo_test" {
#  name_prefix		= "odoo-cert"
  name			= "odoo-cert"
  certificate_body = "${file("secrets/cert.pem")}"
  private_key      = "${file("secrets/key.pem")}"

#  lifecycle {
#    create_before_destroy = true
#  }
}

resource "aws_elb" "elb-odoo" {
  name = "elb-odoo"

#  cross_zone_load_balancing = true
  subnets         = ["${aws_subnet.tier12a.id}","${aws_subnet.tier12b.id}"]
  security_groups = ["${aws_security_group.tier1apps.id}"]
  instances       = ["${aws_instance.odoo.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.odoo_test.arn}"
  }
}
