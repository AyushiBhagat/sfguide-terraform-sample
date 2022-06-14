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

provider "snowflake" { 
 alias = "security_admin"
 role  = "SECURITYADMIN"
 }


 resource "snowflake_role" "role" {
     provider = snowflake.security_admin
     name     = "TF_DEMO_SVC_ROLE"
 }


 resource "snowflake_database_grant" "grant" {
     provider          = snowflake.security_admin
     database_name     = snowflake_database.db.name
     privilege         = "USAGE"
     roles             = [snowflake_role.role.name]
     with_grant_option = false
 }


 resource "snowflake_schema" "schema" {
     provider   = snowflake.sys_admin
     database   = snowflake_database.db.name
     name       = "TF_DEMO"
     is_managed = false
 }


 resource "snowflake_schema_grant" "grant" {
     provider          = snowflake.security_admin
     database_name     = snowflake_database.db.name
     schema_name       = snowflake_schema.schema.name
     privilege         = "USAGE"
     roles             = [snowflake_role.role.name]
     with_grant_option = false
 }

 resource "snowflake_table_grant" "grant" {
     provider          = snowflake.security_admin
     on_existing       = true 
     database_name     = snowflake_database.db.name
     schema_name       = snowflake_schema.schema.name
     privilege         = "SELECT"
     roles             = [snowflake_role.role.name]
     with_grant_option = false
 }


  resource "snowflake_warehouse_grant" "grant" {
     provider          = snowflake.security_admin
     warehouse_name    = snowflake_warehouse.warehouse.name
     privilege         = "USAGE"
     roles             = [snowflake_role.role.name]
     with_grant_option = false
 }

 resource "snowflake_role" "other_role" {
  provider = snowflake.security_admin 
  name = "terraform_test_rl"
}

 resource "snowflake_role_grants" "grants" {
     provider  = snowflake.security_admin
     role_name = snowflake_role.role.name
     roles     = ["${snowflake_role.other_role.name}"]
 }
