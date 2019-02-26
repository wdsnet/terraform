###Terraform on IBM Cloud

- Ensure that the** $PATH** environment variable is updated to point to the terraform directory.
On **Linux** or** Mac**, you need to add the following to your **~/.profile** or **~/.bashrc** or  **~/.bash_profile**

`export PATH=$PATH:$HOME/terraform`

- Create a terraform directory

`mkdir $HOME/terraform; cd terraform`

- Download a terraform binary from  https://www.terraform.io/downloads.html and copy into the created directory

- Check the Terraform installation by running from the terraform command in your terminal .

`$ terraform`

- Install IBM Terraform Provider 
Download the latest version of the terraform-provider-ibm binary from https://github.com/IBM-Cloud/terraform-provider-ibm/releases 

- Create a .terraform.d/plugins directory in your user’s home directory and place the binary plugin file inside of it.

`$mkdir $HOME/.terraform.d/plugins`
`$mv $HOME/Downloads/terraform-provider-ibm     $HOME/.terraform.d/plugins/ `

Test the terraform-provider-ibm plugin as well. You will get the following result.

cd $HOME/.terraform.d/plugins
./terraform-provider-ibm

- Configure Terraform for IBM Cloud

Will be used static variables, as it allows easier sharing of configurations between users, but requires good oversight of file security permissions and avoiding exposing API keys on public repositories. 
See https://ibm-cloud.github.io/tf-ibm-docs/index.html#using-terraform-with-the-ibm-cloud-provider for more details .

- Download the sample files to your terraform directory. 

git clone https://github.com/wdsnet/terraform

You must add all credentials listed in the terraform.tfvars file in order to complete the rest of this tutorial.

-  SL_USERNAME is a SoftLayer user name. Go to https://control.bluemix.net/account/user/profile, scroll down, and check API Username.
- SL_API_KEY is a SoftLayer API Key. Go to https://control.bluemix.net/account/user/profile, scroll down, and check Authentication Key.
- BM_API_KEY – An API key for IBM Cloud services. If you don’t have one already, go to https://console.bluemix.net/iam/#/apikeys and create a new key.

# Basic Terraform operation

See https://www.terraform.io/docs/configuration/index.html for terraform configuration instructions. Especially, Configuration Syntax, Interpolation Syntax, Resources, Variables provide the major concepts.

https://ibm-cloud.github.io/tf-ibm-docs/index.html provides reference guides for Terraform IBM plugin.

# Creating a TF file 

- Create an empty directory.
- Create a file sample.tf with the following definition.

`resource "ibm_compute_vm_instance" "vm1" {`
` hostname = "vm1"`
` domain = "example.com"`
` os_reference_code = "UBUNTU_16_64"`
` datacenter = "dal03"`
` network_speed = 10`
` hourly_billing = true`
` private_network_only = false`
` cores = 1`
` memory = 1024`
` disks = [25] local_disk = false`
`}`

# Creating a VM

Execute terraform init to initialize Terraform IBM plugin. You will get the following messages.

`$ terraform init`

**Initializing provider plugins...**
**Terraform has been successfully initialized!**

- You may now begin working with Terraform. Try running** "terraform plan"** to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

`$ terraform plan`

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be persisted to local or remote state storage.
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + ibm_compute_vm_instance.vm1

      id:                           <computed>
      block_storage_ids.#:          <computed>
      cores:                        "1"
      datacenter:                   "dal03"
      disks.#:                      "1"
      disks.0:                      "25"
      domain:                       "example.com"
      file_storage_ids.#:           <computed>
      hostname:                     "vm1"
      hourly_billing:               "true"
      ip_address_id:                <computed>
      ip_address_id_private:        <computed>
      ipv4_address:                 <computed>
      ipv4_address_private:         <computed>
      ipv6_address:                 <computed>
      ipv6_address_id:              <computed>
      ipv6_enabled:                 "false"
      ipv6_static_enabled:          "false"
      local_disk:                   "false"
      memory:                       "1024"
      network_speed:                "10"
      os_reference_code:            "UBUNTU_16_64"
      private_interface_id:         <computed>
      private_network_only:         "false"
      private_security_group_ids.#: <computed>
      private_subnet:               <computed>
      private_subnet_id:            <computed>
      private_vlan_id:              <computed>
      public_bandwidth_limited:     <computed>
      public_bandwidth_unlimited:   "false"
      public_interface_id:          <computed>
      public_ipv6_subnet:           <computed>
      public_ipv6_subnet_id:        <computed>
      public_security_group_ids.#:  <computed>
      public_subnet:                <computed>
      public_subnet_id:             <computed>
      public_vlan_id:               <computed>
      secondary_ip_addresses.#:     <computed>
      wait_time_minutes:            "90"

Plan: 1 to add, 0 to change, 0 to destroy.

Now create the virtual server using **terraform apply**. Response **yes** to the prompt.

**[NOTE] **It will create an hourly virtual server in your IBM Cloud account and cost will be charged.

`$ terraform apply`

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 
 + create
Terraform will perform the following actions:

  + ibm_compute_vm_instance.vm1
      id:                           <computed>
      block_storage_ids.#:          <computed>
      cores:                        "1"
      datacenter:                   "dal03"

      ......

Plan: 1 to add, 0 to change, 0 to destroy.


Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only **'yes' ** will be accepted to approve.


It will take a few minutes to complete the provisioning. You can check the details of the virtual server at https://control.bluemix.net/devices

After the completion of the virtual server provisioning, Terraform creates a terraform.tfstate file and saves information about the infrastructure configured, in this case the virtual server . You can inspect the contents of this file using a text editor.

# Showing and updating resources

`$ terraform show`

Some properties are editable. Open sample.tf and change the value of network_speed to 100. When you execute terraform plan, it will report that network_speed will be changed to 100 as follows:

`$ terraform plan`

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 ~ update in-place

Terraform will perform the following actions:

 ~ ibm_compute_vm_instance.vm1
 network_speed: "10" => "100"
Plan: 0 to add, 1 to change, 0 to destroy.

Execute **terraform apply** to update the value of network_speed to 100.

Some VM configuration settings can be changed in IBM Cloud IaaS portal. Terraform will detect these changes and revert them back to the planned confguration if required. Change the number of the processors to 2 in the IaaS portal from the Modify Device Configuration button on the Device Details page for the VM. Once the change is complete execute a terraform refresh. Terraform will get the updated virtual server information and update the terraform.tfstate file. Now a terraform show will display two processors as follows:
 
`$ terraform refresh`
`$ terraform show`

# Deleting resources

Delete the virtual server using the terraform destroy command.

$ terraform destroy
