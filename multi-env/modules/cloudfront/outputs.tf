output "CloudFrontEndpoint" {
    description = "Endpoint for Cloudfront Distribution."
    value = aws_cloudfront_distribution.CloudFrontDistribution.id
}

output "AlternateDomainNames" {
    description = "Alternate Domain Names (CNAME)."
    value = var.AlternateDomainNames != "" ? var.AlternateDomainNames : null
}