# Kms
output "KeyId" {
    description = "Key ID"
    value = module.Kms.KeyId
}

output "KeyArn" {
    description = "Key ARN"
    value = module.Kms.KeyArn
}

output "AliasName" {
    description = "Alias Name"
    value = module.Kms.AliasName
}

# Vpc
output "VPCID" {
    description = "A reference to the created VPC."
    value = module.Vpc.VPCID
}

output "VpcCIDR" {
    description = "VPC CIDR block."
    value = module.Vpc.VpcCIDR
}

output "PublicSubnets" {
    description = "A list of the public subnets."
    value = module.Vpc.PublicSubnets
}

output "PrivateSubnetsApp" {
    description = "A list of the app private subnets."
    value = module.Vpc.PrivateSubnetsApp
}

output "PrivateSubnetsDB" {
    description = "A list of the DB private subnets."
    value = module.Vpc.PrivateSubnetsDB
}

output "AllPrivateSubnets" {
    description = "A list of the private subnets."
    value = module.Vpc.AllPrivateSubnets
}

output "AllSubnets" {
    description = "A list of all subnets."
    value = module.Vpc.AllSubnets
}

output "PublicRouteTables" {
    description = "A list of the public route tables."
    value = module.Vpc.PublicRouteTables
}

output "PrivateRouteTables" {
    description = "A list of the private route tables."
    value = module.Vpc.PrivateRouteTables
}

output "AllRouteTables" {
    description = "A list of all route tables."
    value = module.Vpc.AllRouteTables
}

output "PublicSubnet1" {
    description = "A reference to the public subnet in the 1st Availability Zone."
    value = module.Vpc.PublicSubnet1
}

output "PublicSubnet2" {
    description = "A reference to the public subnet in the 2nd Availability Zone."
    value = module.Vpc.PublicSubnet2
}

output "PublicSubnet3" {
    description = "A reference to the public subnet in the 3rd Availability Zone."
    value = module.Vpc.PublicSubnet3
}

output "PublicSubnet1CIDR" {
    description = "A reference to the public subnet CIDR in the 1st Availability Zone."
    value = module.Vpc.PublicSubnet1CIDR
}

output "PublicSubnet2CIDR" {
    description = "A reference to the public subnet CIDR in the 2nd Availability Zone."
    value = module.Vpc.PublicSubnet2CIDR
}

output "PublicSubnet3CIDR" {
    description = "A reference to the public subnet CIDR in the 3rd Availability Zone."
    value = module.Vpc.PublicSubnet3CIDR
}

output "PrivateAppSubnet1" {
    description = "A reference to the private App subnet in the 1st Availability Zone."
    value = module.Vpc.PrivateAppSubnet1
}

output "PrivateAppSubnet2" {
    description = "A reference to the private App subnet in the 2nd Availability Zone."
    value = module.Vpc.PrivateAppSubnet2
}

output "PrivateAppSubnet3" {
    description = "A reference to the private App subnet in the 3rd Availability Zone."
    value = module.Vpc.PrivateAppSubnet3
}

output "PrivateAppSubnet1CIDR" {
    description = "A reference to the private App subnet CIDR in the 1st Availability Zone."
    value = module.Vpc.PrivateAppSubnet1CIDR
}

output "PrivateAppSubnet2CIDR" {
    description = "A reference to the private App subnet CIDR in the 2nd Availability Zone."
    value = module.Vpc.PrivateAppSubnet2CIDR
}

output "PrivateAppSubnet3CIDR" {
    description = "A reference to the private App subnet CIDR in the 3rd Availability Zone."
    value = module.Vpc.PrivateAppSubnet3CIDR
}

output "PrivateDBSubnet1" {
    description = "A reference to the private DB subnet in the 1st Availability Zone."
    value = module.Vpc.PrivateDBSubnet1
}

output "PrivateDBSubnet2" {
    description = "A reference to the private DB subnet in the 2nd Availability Zone."
    value = module.Vpc.PrivateDBSubnet2
}

output "PrivateDBSubnet3" {
    description = "A reference to the private DB subnet in the 3rd Availability Zone."
    value = module.Vpc.PrivateDBSubnet3
}

output "PrivateDBSubnet1CIDR" {
    description = "A reference to the private DB subnet CIDR in the 1st Availability Zone."
    value = module.Vpc.PrivateDBSubnet1CIDR
}

output "PrivateDBSubnet2CIDR" {
    description = "A reference to the private DB subnet CIDR in the 2nd Availability Zone."
    value = module.Vpc.PrivateDBSubnet2CIDR
}

output "PrivateDBSubnet3CIDR" {
    description = "A reference to the private DB subnet CIDR in the 3rd Availability Zone."
    value = module.Vpc.PrivateDBSubnet3CIDR
}

output "NatGateway1EIP" {
    description = "A reference to the NAT Gateway public IP in the 1st Availability Zone."
    value = module.Vpc.NatGateway1EIP
}

output "NatGateway2EIP" {
    description = "A reference to the NAT Gateway public IP in the 2nd Availability Zone."
    value = module.Vpc.NatGateway2EIP
}

output "NatGateway3EIP" {
    description = "A reference to the NAT Gateway public IP in the 3rd Availability Zone."
    value = module.Vpc.NatGateway3EIP
}

# AuroraApplication
output "AppDNSName" {
    description = "The connection endpoint for the DB cluster."
    value = module.AuroraApplication.DNSName
}

output "AppReadDNSName" {
    description = "The reader endpoint for the DB cluster."
    value = module.AuroraApplication.ReadDNSName
}

output "AppSecurityGroupId" {
    description = "The security group used to manage access to RDS Aurora."
    value = module.AuroraApplication.SecurityGroupId
}

# AuroraAudit
output "AuditDNSName" {
    description = "The connection endpoint for the DB cluster."
    value = module.AuroraAudit.DNSName
}

output "AuditReadDNSName" {
    description = "The reader endpoint for the DB cluster."
    value = module.AuroraAudit.ReadDNSName
}

output "AuditSecurityGroupId" {
    description = "The security group used to manage access to RDS Aurora."
    value = module.AuroraAudit.SecurityGroupId
}

# AuroraReport
output "ReportDNSName" {
    description = "The connection endpoint for the DB cluster."
    value = module.AuroraReport.DNSName
}

output "ReportReadDNSName" {
    description = "The reader endpoint for the DB cluster."
    value = module.AuroraReport.ReadDNSName
}

output "ReportSecurityGroupId" {
    description = "The security group used to manage access to RDS Aurora."
    value = module.AuroraReport.SecurityGroupId
}

# ElbAccessLogs
output "BucketName" {
    description = "Bucket name."
    value = module.ElbAccessLogs.BucketName
}

output "BucketArn" {
    description = "Bucket ARN."
    value = module.ElbAccessLogs.BucketArn
}

output "BucketDomainName" {
    description = "Bucket DomainName."
    value = module.ElbAccessLogs.BucketDomainName
}

output "BucketRegionalDomainName" {
    description = "Bucket RegionalDomainName."
    value = module.ElbAccessLogs.BucketRegionalDomainName
}

output "BucketWebsiteURL" {
    description = "Bucket WebsiteURL."
    value = module.ElbAccessLogs.BucketWebsiteURL
}

# WafPublic
output "WebACLArn" {
    description = "WebACL Arn."
    value = module.WafPublic.WebACLArn
}

# AlbPublic
output "PublicLoadBalancerArn" {
    description = "Application Load Balancer."
    value = module.AlbPublic.LoadBalancerArn
}

output "PublicLoadBalancerUrl" {
    description = "The DNS name of Application Load Balancer."
    value = module.AlbPublic.LoadBalancerUrl
}

output "PublicPort80ListenerArn" {
    description = "Application Load Balancer port 80 listener."
    value = module.AlbPublic.Port80ListenerArn
}

output "PublicPort443ListenerArn" {
    description = "Application Load Balancer port 443 listener."
    value = module.AlbPublic.Port443ListenerArn
}

# AlbPrivate
output "PrivateLoadBalancerArn" {
    description = "Application Load Balancer."
    value = module.AlbPrivate.LoadBalancerArn
}

output "PrivateLoadBalancerUrl" {
    description = "The DNS name of Application Load Balancer."
    value = module.AlbPrivate.LoadBalancerUrl
}

output "PrivatePort80ListenerArn" {
    description = "Application Load Balancer port 80 listener."
    value = module.AlbPrivate.Port80ListenerArn
}

output "PrivatePort443ListenerArn" {
    description = "Application Load Balancer port 443 listener."
    value = module.AlbPrivate.Port443ListenerArn
}

# NlbRhds
output "RhdsLoadBalancerArn" {
    description = "Network Load Balancer."
    value = module.NlbRhds.LoadBalancerArn
}

output "RhdsLoadBalancerUrl" {
    description = "The DNS name of Network Load Balancer"
    value = module.NlbRhds.LoadBalancerUrl
}

output "RhdsPortListenerArn" {
    description = "Network Load Balancer port listener ARN"
    value = module.NlbRhds.PortListenerArn
}

# NlbHAproxy
output "HAproxyLoadBalancerArn" {
    description = "Network Load Balancer."
    value = module.NlbHAproxy.LoadBalancerArn
}

output "HAproxyLoadBalancerUrl" {
    description = "The DNS name of Network Load Balancer"
    value = module.NlbHAproxy.LoadBalancerUrl
}

output "HAproxyPortListenerArn" {
    description = "Network Load Balancer port listener ARN"
    value = module.NlbHAproxy.PortListenerArn
}