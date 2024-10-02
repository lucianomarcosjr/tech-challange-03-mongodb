resource "mongodbatlas_project_ip_access_list" "access_list" {
  project_id = mongodbatlas_project.project.id

  cidr_block = "0.0.0.0/0"
  comment    = "Acesso aberto para testes"
}
