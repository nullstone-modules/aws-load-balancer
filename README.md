# HTTP Load Balancer

This module serves traffic to an ECS/Fargate (Nullstone) application through an HTTP Load Balancer.

## Configuration

Traffic is served to the port specified in the application's `port` variable.

The module creates an S3 Bucket to store the Load Balancer's access logs. 

## SSL

If `var.enable_https` is enabled, a subdomain is required and used to provision an SSL Certificate.
Once provisioned, the SSL Certificate is attached to the Load Balancer listening on port 443.
SSL Termination is performed at the Load Balancer -- traffic from the Load Balancer to the application is performed over HTTP.

If enabled, a secondary Load Balancer listener is configured on port 80 to redirect `http://<subdomain>` to `https://<subdomain>`.
This ensures users connect appropriately to the HTTPS listener. 

## Security

When SSL is enabled, the Load Balancer allows traffic from the internet to port 443 and port 80.
If not, traffic is allowed from the internet to port 80.

Traffic from the Load Balancer to the Application is allowed *only* on the application's port.

## Health Checks

Health checks are performed on the application's port (i.e. `var.port`) using the configurable health check inputs.

For more details about configuring health checks on an AWS Load Balancer, see the AWS documentation:
<a href="https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-healthchecks.html" target="_blank">Configuring Health Checks</a>
