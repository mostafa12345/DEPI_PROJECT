# DevOps Project: Node.js Application with MongoDB


![alt text2](<./DEPI_PROJECT.gif>)
This project demonstrates the complete DevOps lifecycle, from building and containerizing a Node.js application to deploying it using a full CI/CD pipeline, along with infrastructure provisioning and configuration management.


## Prerequisites

Before deploying this infrastructure, ensure the following:

- **Docker and Docker Compose** is installed and configured .
- **Terraform** is installed and configured .
- **Jenkins** is installed for CI/CD .
- **Ansible** is installed and configured .
- An **AWS account** with appropriate access rights.
- **SSH key pairs** for secure access to instances (public and private keys).
- **Basic knowledge** of Terraform and AWS networking concepts.

## Architecture Overview

This project showcases a full DevOps lifecycle for a Node.js application connected to a MongoDB database. It includes:

- **Custom VPC**: Provides an isolated network environment with public and private subnets for different tiers of the infrastructure.
- **Public Subnets**: Hosts internet-accessible resources like the Bastion host and NAT gateway.
- **Docker**: Containerizing the application with Docker and Docker Compose.
- **Jenkins**: Setting up a CI/CD pipeline to build, test, and push the Docker image to Docker Hub.
- **Terraform**:Using Terraform to provision cloud infrastructure.
- **Ansible**:Using Ansible for server configuration and automated deployment of the application.
This architecture ensures a highly secure and isolated environment for critical applications with proper routing through NAT and Internet Gateways.

## AWS Resources

### VPC

- **CIDR Block**: The VPC spans a network range of `10.0.0.0/16`, ensuring enough IP address space for current and future resources.
- **Name**: The VPC is named `Depi_vpc` to identify its role within the project.
- **Region**: All resources are deployed in the `us-east-1` region.

### Subnets

The VPC is divided into multiple subnets for various purposes:

- **Public Subnets**:
  - These subnets host the Bastion host and NAT Gateway, allowing access to private subnets without exposing them to the internet.
  - Three public subnets are provisioned (`10.0.3.0/24`, `10.0.4.0/24`, `10.0.5.0/24`).

### Internet Gateway

- An **Internet Gateway** is attached to the VPC to enable outbound internet access for public subnets.
- Resources such as the Bastion host use this gateway to provide administrative access.


### Jenkins Server

- **Purpose**: The Jenkins server automates CI/CD tasks for deployments.
- **Location**: Deployed in a private subnet, ensuring it is not publicly accessible.
- **Instance Details**: EC2 instance (t2.micro) with relevant security configurations to access application servers and repositories.

### Ansible

- Configuring the server post-infrastructure setup.
- Deploying the Node.js application and setting up the required environment variables.


## Conclusion

This project demonstrates the full DevOps lifecycle for a Node.js application, from development to production. By containerizing the app with Docker, automating the deployment process with Jenkins and Terraform
