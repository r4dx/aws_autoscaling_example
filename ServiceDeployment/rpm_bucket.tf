variable "rpm_bucket_name" {
  default = "autoscaling-test-rpm-bucket"
}

resource "aws_s3_bucket" "rpm_bucket" {
  bucket = "${var.rpm_bucket_name}"
  acl = "public-read"
 
  website {
    index_document = "index.html"
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.rpm_bucket_name}/*"
        }
    ]
}
EOF

}

resource "aws_s3_bucket_object" "rpm" {
  bucket = "${aws_s3_bucket.rpm_bucket.bucket}"
  key = "likesService.rpm"
  source = "${var.path_to_rpm}"
  etag = "${md5(file("${var.path_to_rpm}"))}"
}

output "rpm_link" {
  value = "${aws_s3_bucket.rpm_bucket.website_endpoint}/${aws_s3_bucket_object.rpm.key}"
}