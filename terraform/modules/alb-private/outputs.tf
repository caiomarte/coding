output "LoadBalancerArn" {
    description = "Application Load Balancer."
    value = aws_lb.LoadBalancer.arn
}

output "LoadBalancerUrl" {
    description = "The DNS name of Application Load Balancer."
    value = aws_lb.LoadBalancer.dns_name
}

output "Port80ListenerArn" {
    description = "Application Load Balancer port 80 listener."
    value = aws_lb_listener.Port80Listener.arn
}

output "Port443ListenerArn" {
    description = "Application Load Balancer port 443 listener."
    value = aws_lb_listener.Port443Listener.arn
}