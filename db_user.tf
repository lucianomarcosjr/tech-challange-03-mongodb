resource "mongodbatlas_database_user" "db_user" {
  username           = var.mongodb_user
  password           = var.mongodb_password
  auth_database_name = "admin"
  project_id         = mongodbatlas_project.project.id

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}
