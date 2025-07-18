
terraform {
  cloud {
    hostname = "scalr-iacp.scalr.io"
    organization = "edgar-playground"

    workspaces {
      name = "ecnryption-test"
    }
  }
}
