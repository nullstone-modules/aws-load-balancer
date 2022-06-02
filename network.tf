// Container apps have clusters, but lambdas do not
// If app does not have cluster, resulting `name` equals `""`
// This allows the `via` in the network stanza to work as if the cluster did not exist
data "ns_app_connection" "cluster" {
  name     = "cluster"
  type     = "cluster/aws-fargate"
  optional = true
}

data "ns_app_connection" "network" {
  name = "network"
  type = "network/aws"
  via  = data.ns_app_connection.cluster.name
}

locals {
  vpc_id     = data.ns_app_connection.network.outputs.vpc_id
  subnet_ids = data.ns_app_connection.network.outputs.public_subnet_ids
}
