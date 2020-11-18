#	PROVIDER	#  
  provider "google" {
  credentials = file("plucky-sight-296003-4867509ee645.json")
  project     = var.project_name
  region      = var.region
  zone        = var.zone


terraform {
  backend "gcs" {
    bucket = "assignment_bucketff"
#    prefix = ""
  }
}


#	RESOURCES	#
# creating the network 
module "network" {
  source = "./modules/network"

  network_name = "network"
  auto_create_subnetworks = "false"
}

# creating the web subnet 
module "public_subnet" {
  source = "./modules/subnetworks"

  subnetwork_name = "web-subnetwork"
  cidr = "10.0.0.0/21"
  subnetwork_region = "northamerica-northeast1"
  network = module.network.network_name
  depends_on_resoures = [module.network]
  private_ip_google_access = "false"
}

# creating the app subnet 
module "private_subnet" {
  source = "./modules/subnetworks"

  subnetwork_name = "app-subnetwork"
  cidr = "10.0.8.0/21"
  subnetwork_region = "northamerica-northeast1"
  network = module.network.network_name
  depends_on_resoures = [module.network]
  private_ip_google_access = "false"
}

# creating the bastion subnet    
module "private_subnet" {
  source = "./modules/subnetworks"

  subnetwork_name = "bastion-subnetwork"
  cidr = "10.0.16.0/21"
  subnetwork_region = "northamerica-northeast1"
  network = module.network.network_name
  depends_on_resoures = [module.network]
  private_ip_google_access = "false"
}

# create the vm in public subnet
module "public_instance" {
  source = "./modules/vm"

  instance_name = "web-vm"
  machine_type = "e2-medium"
  vm_zone = "northamerica-northeast1-b"
  network_tags = ["web-vm", "test"]
  machine_image = "ubuntu-1804-bionic-v20200317"
  subnetwork = module.public_subnet.sub_network_name
  metadata_Name_value = "web_vm"
  metadata_startup_script = file("startup.sh")
}

# create the vm's in private subnet
module "private_instance" {
  source = "./modules/vm"

  instance_name = "app-vm"
  machine_type = "e2-medium"
  vm_zone = "northamerica-northeast1-b"
  network_tags = ["app-vm"]
  machine_image = "ubuntu-1804-bionic-v20200317"
  subnetwork = module.private_subnet.sub_network_name
  metadata_Name_value = "app_vm"
  metadata_startup_script = file("startup.sh")
}

module "private_instance" {
  source = "./modules/vm"
  instance_name = "bastion-vm"
  machine_type = "e2-medium"
  vm_zone = "northamerica-northeast1-b"
  network_tags = ["bastion-vm"]
  machine_image = "ubuntu-1804-bionic-v20200317"
  subnetwork = module.private_subnet.sub_network_name
  metadata_Name_value = "bastion_vm"
}

