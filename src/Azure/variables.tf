#
# Variaveis de uso mais geral
#
variable "varResourceGroupLocation" {
  default     = "eastus"
  description = "Região onde ficaram os recursos."
}

variable "varResourceGroupName" {
  default = "cc-demoterraformrg"
  description = "Nome do Resource Group"
}

variable "varStorageAccountName" {
  default = "condestorageaccount"
  description = "Nome da Conta de Armazenamento"
}

#
# Variaveis para Questoes de Rede
#
variable "varItemVirtualNetwork" {
  default = "condeVNet"
  description = "Nome da Rede Virtual do Azure"
}

variable "varItemSubnetName" {
  default = "condeSubNet"
  description = "Nome para identificar a Subnet"
}

variable "varItemPublicIPName" {
  default = "condeIPPublic"
  description = "Nome para Identificar o recurso de IP Publico"
}

variable "varItemNetworkGroupName" {
  default = "condeNetworkSecurityGroup"
  description = "Nome para Identificar o grupo"
}

variable "varItemNICName" {
  default = "condeNIC"
  description = "Nome para Identificar a Interface de Rede"
}

variable "varItemNIConfigurationName" {
  default = "conde_nic_configuration"
  description = "Nome para Identificar a configuracao de IP para a Interface de Rede"
}

#
# Variaveis para a Maquina Virtual
#
variable "varItemVMName" {
  default = "condeVM"
  description = "Nome para Identificar o Recurso como Virtual Machine"
}

variable "varItemVMOSDiskName" {
  default = "condeOSDisk"
  description = "Nome para Identificar o recurso de Disk Boot"
}

variable "varItemVMComputerName" {
  default = "CondeVMComputerName"
  description = "Nome para o Computer"
}

variable "varItemVMUserName" {
  default = "azureuser"
  description = "Nome do Usuario para acessar via Admin"
}