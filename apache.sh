 #!/bin/bash
<<EOF
yum install -y httpd
systemctl start httpd
systemctl enable httpd
aws s3 cp s3://${aws_s3_bucket.apache.bucket}/index.html /var/www/html/
EOF
