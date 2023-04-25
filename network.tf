data "ns_app_connection" "cluster_namespace" {
  name     = "cluster-namespace"
  contract = "cluster-namespace/aws/ecs:*"
}

data "ns_app_connection" "cluster" {
  name     = "cluster"
  contract = "cluster/aws/ecs:*"
  via      = data.ns_app_connection.cluster_namespace.name
}

data "ns_app_connection" "network" {
  name     = "network"
  contract = "network/aws/vpc"
  via      = "${data.ns_app_connection.cluster_namespace.name}/${data.ns_app_connection.cluster.name}"
}

locals {
  vpc_id     = data.ns_app_connection.network.outputs.vpc_id
  subnet_ids = data.ns_app_connection.network.outputs.public_subnet_ids
}
