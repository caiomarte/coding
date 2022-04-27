output "KeyId" {
    description = "Key ID"
    value = aws_kms_key.Key.id
}

output "KeyArn" {
    description = "Key ARN"
    value = aws_kms_key.Key.arn
}

output "AliasName" {
    description = "Alias Name"
    value = aws_kms_alias.KeyAlias.name
}