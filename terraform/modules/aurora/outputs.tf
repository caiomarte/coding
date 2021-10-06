output "DNSName" {
    description = "The connection endpoint for the DB cluster."
    value = aws_rds_cluster.DBCluster.endpoint
}

output "ReadDNSName" {
    description = "The reader endpoint for the DB cluster."
    value = aws_rds_cluster.DBCluster.reader_endpoint
}

output "SecurityGroupId" {
    description = "The security group used to manage access to RDS Aurora."
    value = aws_security_group.ClusterSecurityGroup.id
}