# This generates a Random Unique id for my s3 bucket be unique globally
resource "random_id" "unique_value" {
  byte_length = 8
}


# Create a S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "website-bucket-${random_id.unique_value.hex}"

  tags = {
    Name = "Static_website"
  }
}

# Upload Html file
resource "aws_s3_object" "html_file" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = "${path.module}/RiverBankinn/index.html"
  content_type = "text/html"


}

# Local Processing for uploading images in bulk
locals {
  all_images = fileset("${path.module}/RiverBankinn/Images", "**")

  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "Images/png"
    jpg  = "Images/jpeg"
    jpeg = "Images/jpeg"
    gif  = "Images/gif"
    webp = "Images/webp"
  }
}

# Uploading Images
resource "aws_s3_object" "images" {
  for_each = toset(local.all_images)
  bucket   = aws_s3_bucket.my_bucket.id
  key      = "Images/${each.value}"
  source   = "${path.module}/RiverBankinn/Images/${each.value}"

  content_type = lookup(
    local.mime_types,
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
}


# Allow Public Access 
resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Add the get object policy
resource "aws_s3_bucket_policy" "web_access_policy" {
  bucket = aws_s3_bucket.my_bucket.id


  depends_on = [aws_s3_bucket_public_access_block.allow_public_access]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}


# Enable Static website hosting with my root file as index.html
resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }
}


