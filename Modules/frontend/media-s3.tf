resource "aws_s3_bucket" "s3Bucket3" {
  depends_on = [aws_cloudfront_origin_access_identity.origin_access_identity2]
  bucket     = "${var.environment}-media-s3bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Sid":"1",
      "Principal": {
        "AWS": ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
      },
      "Action": [ "s3:GetObject" ],
      
      "Resource":["arn:aws:s3:::${var.environment}-media-s3bucket/*"]
    }
  ]
}
EOF
}
resource "aws_s3_bucket_public_access_block" "accessBlock3" {
  depends_on = [aws_s3_bucket.s3Bucket3]

  bucket = aws_s3_bucket.s3Bucket3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "dist3" {
  depends_on = [aws_s3_bucket.s3Bucket3]

  for_each     = fileset("${var.static_assets_directory}", "*")
  bucket       = "${var.environment}-media-s3bucket"
  key          = each.value
  source       = "${var.static_assets_directory}${each.value}"
  etag         = filemd5("${var.static_assets_directory}${each.value}")
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
}
