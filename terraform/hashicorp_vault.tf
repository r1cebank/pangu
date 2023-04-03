module "hashicorp_vault" {
  source = "./modules/xenvm"
  count  = 1

  vm_description = "Hashicorp Vault Host"
  vm_name        = "hashicorp-vault-${count.index}"
  cpus           = var.hashicorp_vault_resources.cpus
  max_memory     = var.hashicorp_vault_resources.memory_max
  disk_size      = var.hashicorp_vault_resources.disk_size
  sr_id          = data.xenorchestra_sr.sr_sata.id
  network_id     = data.xenorchestra_network.network.id
  template_id    = data.xenorchestra_template.vm_template_2204.id
  affinity_host  = data.xenorchestra_host.cerulean.id

  cloud_config_file         = "resource/hashicorp_vault_cloudconfig.tftpl"
  cloud_network_config_file = "resource/networkconfig_static.tftpl"
  cloud_network_config_args = {
    ip_address      = element(var.hashicorp_vault_resources.ips, count.index),
    subnet_mask     = "255.255.255.0"
    gateway_address = "192.168.1.1"
    dns_server1     = "1.1.1.1"
  }
  mac_address = element(slice(var.vm_macs, var.hashicorp_vault_resources.mac_pool.start, var.hashicorp_vault_resources.mac_pool.end), count.index)

  tags = [
    "vault"
  ]
}
