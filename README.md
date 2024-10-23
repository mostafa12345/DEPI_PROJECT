# Terraform Infrastructure Setup for DEPI Graduation Project


![alt text2](<./DEPI_PROJECT.gif>)
This documentation provides an overview of the infrastructure created using Terraform for an AWS-based deployment. The architecture consists of a custom VPC with both public and private subnets, along with instances for Jenkins, Prometheus, and a Bastion host. This setup supports scalability, secure networking, and monitoring.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Architecture Overview](#architecture-overview)
- [AWS Resources](#aws-resources)
  - [VPC](#vpc)
  - [Subnets](#subnets)
  - [Internet Gateway](#internet-gateway)
  - [NAT Gateway](#nat-gateway)
  - [Bastion Host](#bastion-host)
  - [Jenkins Server](#jenkins-server)
  - [Prometheus Server](#prometheus-server)
  - [RDS Subnets and Security](#rds-subnets-and-security)
- [Security and Access Control](#security-and-access-control)
- [Conclusion](#conclusion)

## Prerequisites

Before deploying this infrastructure, ensure the following:

- **Terraform** is installed and configured (v1.0.0 or higher).
- An **AWS account** with appropriate access rights.
- **SSH key pairs** for secure access to instances (public and private keys).
- **Basic knowledge** of Terraform and AWS networking concepts.

## Architecture Overview

The AWS architecture built using Terraform consists of:

- **Custom VPC**: Provides an isolated network environment with public and private subnets for different tiers of the infrastructure.
- **Public Subnets**: Hosts internet-accessible resources like the Bastion host and NAT gateway.
- **Private Subnets**: Secured subnets where critical applications, such as Jenkins and Prometheus, are hosted. These are not directly accessible from the internet.
- **RDS Subnet Group**: Separate subnets designated for the database layer, isolated for security.

This architecture ensures a highly secure and isolated environment for critical applications with proper routing through NAT and Internet Gateways.

## AWS Resources

### VPC

- **CIDR Block**: The VPC spans a network range of `10.0.0.0/16`, ensuring enough IP address space for current and future resources.
- **Name**: The VPC is named `Depi_vpc` to identify its role within the project.
- **Region**: All resources are deployed in the `us-east-1` region.

### Subnets

The VPC is divided into multiple subnets for various purposes:

- **Private Subnets**:

  - These are used for hosting application instances like Jenkins and Prometheus.
  - Three subnets are dedicated to general private resources (`10.0.0.0/24`, `10.0.1.0/24`, `10.0.2.0/24`).
  - Three more subnets are allocated for RDS database resources (`10.0.6.0/24`, `10.0.7.0/24`, `10.0.8.0/24`).

- **Public Subnets**:
  - These subnets host the Bastion host and NAT Gateway, allowing access to private subnets without exposing them to the internet.
  - Three public subnets are provisioned (`10.0.3.0/24`, `10.0.4.0/24`, `10.0.5.0/24`).

### Internet Gateway

- An **Internet Gateway** is attached to the VPC to enable outbound internet access for public subnets.
- Resources such as the Bastion host use this gateway to provide administrative access.

### NAT Gateway

- A **NAT Gateway** is set up in one of the public subnets, providing secure outbound internet access to resources in the private subnets without exposing them to direct internet traffic.
- The NAT Gateway is crucial for allowing the Jenkins and Prometheus servers to download necessary updates and communicate with external services while remaining secure.

### Bastion Host

- **Purpose**: The Bastion host serves as a jump box for SSH access to instances in private subnets.
- **Instance Details**: A lightweight EC2 instance (t2.micro) running in the public subnet, configured with security rules to allow only SSH traffic (port 22).
- **Access**: Administrators access private instances through this host.

### Jenkins Server

- **Purpose**: The Jenkins server automates CI/CD tasks for deployments.
- **Location**: Deployed in a private subnet, ensuring it is not publicly accessible.
- **Instance Details**: EC2 instance (t2.micro) with relevant security configurations to access application servers and repositories.

### Prometheus Server

- **Purpose**: Prometheus is used for monitoring the health and performance of the infrastructure and applications.
- **Location**: Hosted in a private subnet to protect monitoring data from external exposure.
- **Instance Details**: EC2 instance (t2.micro) configured with security rules to allow internal access.

### RDS Subnets and Security

- **Subnets**: The RDS database (not provisioned by this Terraform setup but planned) will be hosted in its own private subnets, ensuring that database traffic is isolated from the application and internet traffic.
- **Security Group**: A security group is configured to only allow internal MySQL traffic (port 3306) between the RDS instances and application servers within the VPC.

## Security and Access Control

- **Bastion Host**: Only administrators with SSH key pairs can access the Bastion host, which acts as the sole entry point to private resources.
- **Private Subnets**: Instances in private subnets are only accessible via the Bastion host or through internally routed traffic (e.g., from the NAT Gateway).
- **Security Groups**: Custom security groups are implemented to control traffic between public and private subnets, restricting unnecessary access while allowing necessary communication (e.g., HTTP, SSH, MySQL).

## Conclusion

This Terraform infrastructure provides a robust, secure, and scalable foundation for deploying critical applications on AWS. By isolating resources into public and private subnets, and utilizing security groups, NAT gateways, and a Bastion host, this architecture ensures that applications are protected while remaining accessible for administrative purposes.
