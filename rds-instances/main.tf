resource "aws_db_instance" "db_instances" {
  for_each = { for instance in var.db_instances : instance.name => instance }

  identifier                    = each.value.name
  engine                        = each.value.engine
  engine_version                = each.value.engine_version
  instance_class                = each.value.instance_class
  allocated_storage             = each.value.allocated_storage
  parameter_group_name          = each.value.parameter_group_name
  db_subnet_group_name          = each.value.subnet_group_name
  vpc_security_group_ids        = each.value.security_group_ids
  port                          = each.value.port
  db_name                       = each.value.db_name
  username                      = each.value.username
  password                      = each.value.manage_master_user_password ? null : each.value.password
  manage_master_user_password   = each.value.manage_master_user_password
  master_user_secret_kms_key_id = each.value.master_user_secret_kms_key_id
  storage_encrypted             = each.value.storage_encrypted
  multi_az                      = each.value.multi_az_enabled
  publicly_accessible           = each.value.publicly_accessible
  skip_final_snapshot           = each.value.skip_final_snapshot
  deletion_protection           = each.value.deletion_protection
  backup_retention_period       = each.value.backup_retention_period
  storage_type                  = each.value.storage_type
  max_allocated_storage         = each.value.max_allocated_storage
  iops                          = each.value.iops
  apply_immediately             = each.value.apply_immediately
  auto_minor_version_upgrade    = each.value.auto_minor_version_upgrade

  tags = merge(var.tags, try(each.value.tags, {}))
}
