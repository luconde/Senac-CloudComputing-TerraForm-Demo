resource "azurerm_resource_group" "rg" {
  location = var.varResourceGroupLocation
  name     = var.varResourceGroupName
}

# Cria a Virtual Network do Azure
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = var.varItemVirtualNetwork
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Cria a subnet no Virtual Network
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = var.varItemSubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Cria o endereço IP público que será alocado na Virtual Machine
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = var.varItemPublicIPName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Cria o Grupo de segurança e libera a porta 22 para acesso remoto via SSH
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = var.varItemNetworkGroupName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Cria a Interface de Rede
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = var.varItemNICName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "conde_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Conecta o grupo de segurança com a Interface de Rede
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create a conta de armazenamento
resource "azurerm_storage_account" "my_storage_account" {
  name                     = var.varStorageAccountName
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Cria e mostra a chave SSH
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Cria a Maquina Virtual
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = var.varItemVMName
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = var.varItemVMOSDiskName
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = var.varItemVMComputerName
  admin_username                  = var.varItemVMUserName
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.varItemVMUserName
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}