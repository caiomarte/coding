output "LoadBalancerArn" {
    description = "Network Load Balancer."
    value = aws_lb.LoadBalancer.arn
}

output "LoadBalancerUrl" {
    description = "The DNS name of Network Load Balancer"
    value = aws_lb.LoadBalancer.dns_name 
}

output "PortListenerArn" {
    description = "Network Load Balancer port listener ARN"
    value = aws_lb_listener.PortListener.arn
}