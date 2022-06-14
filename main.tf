terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.22.0"
    }
  }
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
}

resource "snowflake_database" "db" {
  provider = snowflake.sys_admin
  name     = "AYUSHI_CLONE_1"
}

resource "snowflake_warehouse" "warehouse" {
  provider       = snowflake.sys_admin
  name           = "AYUSHI_WH_1"
  warehouse_size = "large"

  auto_suspend = 60
}
