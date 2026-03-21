data "ns_connection" "notification" {
  name     = "notification"
  contract = "datastore/aws/notification"
  optional = true
}

locals {
  notification_arn = try(data.ns_connection.notification.outputs.notification_arn, "")
  enable_alarms    = local.notification_arn != ""
}
