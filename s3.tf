resource "aws_s3_bucket" "example" {
  bucket = "mybucketjd20240223"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_iam_policy_document" "s3_bucket_policy" {

  policy_id = "PolicyForCloudFrontPrivateContent"
  version   = "2008-10-17"

  statement {

    sid     = "AllowCloudFrontServicePrincipal"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = [

      "${aws_s3_bucket.example.arn}/*",

    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.my_distrib.arn]
    }
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}
#resource "aws_s3_bucket_public_access_block" "this" {

   #bucket                  = aws_s3_bucket.example.id

  #block_public_acls       = true
  #block_public_policy     = true
  #ignore_public_acls      = true
  #restrict_public_buckets = true

#}
#S3 ACL
 # resource "aws_s3_bucket_acl" "exampleacl" {
  #bucket = aws_s3_bucket.example.id
  #acl    = "private"
#}
#resource "aws_s3_bucket_public_access_block" "block_public_access" {
 # bucket = aws_s3_bucket.example.id


  #block_public_acls       = true
  #block_public_policy     = true
  #ignore_public_acls      = true
  #restrict_public_buckets = true
#}

resource "aws_s3_object" "index_object" {
  bucket = aws_s3_bucket.example.id
  key    = "index.html"
  source = "${path.module}/index.html"
  etag   = filemd5("${path.module}/index.html")
  content_type = "text/html"
}



