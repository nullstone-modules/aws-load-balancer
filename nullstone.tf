terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "cluster" {
  name = "cluster"
  type = "cluster/aws-fargate"
}

data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
  via  = data.ns_connection.cluster.name
}

data "ns_connection" "subdomain" {
  name     = "subdomain"
  type     = "subdomain/aws"
  optional = true
}

locals {
  vpc_id            = data.ns_connection.network.outputs.vpc_id
  subnet_ids        = data.ns_connection.network.outputs.public_subnet_ids
  cert_arn          = try(data.ns_connection.subdomain.outputs.cert_arn, "")
  subdomain_zone_id = try(data.ns_connection.subdomain.outputs.zone_id, "")
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = data.ns_connection.cluster.outputs.cluster_name
}
