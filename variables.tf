variable "packet_auth_token" {
  description = "Your Packet API key"
}

variable "packet_project_id" {
  description = "Packet Project ID"
}

# URL of the website to accelerate through these edges
variable "origin_url" {
  description = "Origin server URL"
}


#
# list out the Packet locations to deploy edge accelerators
#
# North America core IAD2 DFW2 EWR1
# North America edge ATL2 LAX2 SEA1
# Europe and Middle East core AMS1
# Europe and Middle East edge FRA2 MRS1
# Asia Pacific core SIN3 NRT1
# Asia Pacific edge HKG1 SYD2 
variable "edges" {
  type = list
  default = [
    "sjc1",
    "dfw2",
  ]
}
