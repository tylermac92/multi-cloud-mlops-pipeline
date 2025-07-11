terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name = "mlops-rg"
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name = "mlops-vnet"
    address_space = ["10.0.0.0/16"]
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
    name = "mlops-subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
    name = "mlops-aks"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix = "mlops"

    default_node_pool {
        name = "default"
        node_count = 2
        vm_size = "Standard_DS2_v2"
        vnet_subnet_id = azurerm_subnet.subnet.id
    }

    identity {
        type = "SystemAssigned"
    }

    network_profile {
        network_plugin = "azure"
        service_cidr = "10.96.0.0/16"
        dns_service_ip = "10.96.0.10"
        docker_bridge_cidr = "172.17.0.1/16"
    }

    tags = {
        Environment = "dev"
        Project = "mlflow"
    }
}