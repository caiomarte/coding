output "BucketName" {
    description = "Bucket name."
    value = aws_s3_bucket.AccessLogs.id
}

output "BucketArn" {
    description = "Bucket ARN."
    value = aws_s3_bucket.AccessLogs.arn
}

output "BucketDomainName" {
    description = "Bucket DomainName."
    value = aws_s3_bucket.AccessLogs.bucket_domain_name
}

output "BucketRegionalDomainName" {
    description = "Bucket RegionalDomainName."
    value = aws_s3_bucket.AccessLogs.bucket_regional_domain_name
}

output "BucketWebsiteURL" {
    description = "Bucket WebsiteURL."
    value = aws_s3_bucket.AccessLogs.website_domain
}