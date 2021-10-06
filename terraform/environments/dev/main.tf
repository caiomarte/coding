module "Msk" {
    source = "../../modules/msk"

    AWSRegion = var.AWSRegion

    cluster_name = var.MskClusterName
    instance_type = var.MskInstanceType
    kafka_version = var.MskKafkaVersion
    number_of_broker_nodes = var.MskNumberOfNodes
    ebs_volume_size = var.MskEBSVolumeSize
    vpc_id = var.VPCID
    vpc_cidr_blocks = var.VpcCIDR
    subnet_az1 = var.PrivateAppSubnet1
    subnet_az2 = var.PrivateAppSubnet2
    subnet_az3 = var.PrivateAppSubnet3
    kms_arn = var.KMSArn
}

module "Elasticsearch" {
    source = "../../modules/elasticsearch"

    AWSRegion = var.AWSRegion

    domain_name = var.EsDomainName
    elasticsearch_version = var.EsElasticsearchVersion
    instance_type = var.EsInstanceType
    instance_count = var.EsInstanceCount
    zone_awareness_enabled = var.EsZoneAwarenessEnabled
    dedicated_master_enabled = var.EsDedicatedMasterEnabled
    dedicated_master_type = var.EsDedicatedMasterType
    dedicated_master_count = var.EsDedicatedMasterCount
    secret_name = var.EsSecretName
    volume_size = var.EsVolumeSize
    volume_type = var.EsVolumeType
    vpc_id = var.VPCID
    vpc_cidr_blocks = var.VpcCIDR
    subnet_az1 = var.PrivateAppSubnet1
    subnet_az2 = var.PrivateAppSubnet2
    kms_arn = var.KMSArn
}

module "Efs" {
    source = "../../modules/efs"

    AWSRegion = "sa-east-1"

    file_system_name = var.EfsFileSystemName
    performance_mode = var.EfsPerformanceMode
    throughput_mode = var.EfsThroughputMode
    file_share_port = var.EfsFileSharePort
    provisioned_throughput_in_mibps = var.EfsProvisionedThroughputInMibps
    vpc_id = var.VPCID
    vpc_cidr_blocks = var.VpcCIDR
    subnet_az1 = var.PrivateAppSubnet1
    subnet_az2 = var.PrivateAppSubnet2
    subnet_az3 = var.PrivateAppSubnet3
    kms_arn = var.KMSArn
}

module "SecurityHub" {
    source = "../../modules/securityhub"

    AWSRegion = var.AWSRegion
}

module "GuardDuty" {
    source = "../../modules/guardduty"

    AWSRegion = var.AWSRegion
}