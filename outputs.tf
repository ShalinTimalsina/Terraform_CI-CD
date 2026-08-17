output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
  description = "This is the bucket name"
}

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.static_site.website_endpoint}"
  description = "This is the live domain for the static website"
}

