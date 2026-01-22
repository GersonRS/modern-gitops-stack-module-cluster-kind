terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.10.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3"
    }
  }
}
