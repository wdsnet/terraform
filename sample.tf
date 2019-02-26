resource "ibm_compute_vm_instance" "vm1" {
  hostname             = "vm1"
  domain               = "example.com"
  os_reference_code    = "UBUNTU_16_64"
  datacenter           = "dal03"
  network_speed        = 100
  hourly_billing       = true
  private_network_only = yes
  cores                = 1
  memory               = 1024
  disks                = [25]
  local_disk           = false
}
