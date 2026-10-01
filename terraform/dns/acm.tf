data "aws_route53_zone" "this" {
  zone_id = "Z018123937DY4QT4XC9OU" # the Registrar-created, actually-delegated zone
}

resource "aws_acm_certificate" "this" {
  domain_name               = "pokefinder.net"
  subject_alternative_names = ["*.pokefinder.net"]
  validation_method         = "DNS"
}

locals {
  cert_validations = distinct([
    for dvo in aws_acm_certificate.this.domain_validation_options : {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  ])
}

resource "aws_route53_record" "cert_validation" {
  for_each = { for cv in local.cert_validations : cv.name => cv }

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
