moved {
  from = aws_acm_certificate.this
  to   = aws_acm_certificate.this[0]
}