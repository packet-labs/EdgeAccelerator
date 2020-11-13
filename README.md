![](https://img.shields.io/badge/Stability-Experimental-red.svg)

# Bare Metal Edge Accelerator Terraform Module

This repository is [Experimental](https://github.com/packethost/standards/blob/master/experimental-statement.md) meaning that it's based on untested ideas or techniques and not yet established or finalized or involves a radically new and innovative style! This means that support is best effort (at best!) and we strongly encourage you to NOT use this in production.

## Overview

This Terraform Module deploys a network of web accelerators (web proxies) using nginx. These
web accelerators, located at edge locations, cache content from the origin web server for
delivery to the end user. This improves performance by reducing load on the origin server
and reduces latency by delivering from an edge location closer to the end user.

This repo is implemented as a Terraform Module to illustrate how to a Packet deployment
can be abstracted away from a larger Terraform environment to reduce complexity and
speed up development.

Both IPv4 and IPv6 are supported for the edge delivery and the origin requests. The origin
server can even be IPv4 and the edge delivery via IPv6 as an IPv4 to IPv6 gateway proxy.

## Sample Implementation

A full example using this module is available the 
[Edge Accelerated Website](https://github.com/packet-labs/EdgeAcceleratedWebsite).
Start there if you're looking for a complete repo to clone and try out.

## Network Architecture

The basics of a web accelerator is to deploy caches at multiple edge networks locations
close to the end users. In this implementation, Packet hosts across the Packet facilities
(data centers) serve as those edge network locations. The caches are configured to pull
content from the Origin Server (web/application server).

The Origin Server is typically "hidden" from the end users with end user requests served by the 
web accelerators.  In the [Edge Accelerated Website](https://github.com/packet-labs/EdgeAcceleratedWebsite) 
the origin server, a Packet host, is configured without a public IPv4 address in order to hide
in from end user requests.


```
+----------------------+   HTTP      +------------------+
|                      +<----------->| nginx            |  HTTP
| Origin Server        |             | accelerator-ewr1 |<-------> North America web requests
|                      +<--v         | c3.medium.x86    |
+----------------------+   |         +------------------+
                           |
                           |         +------------------+
                           |         | nginx            |  HTTP
                           | HTTP    | accelerator-sin1 |<-------> AsiaPac web requests
                           +-------->| c3.medium.x86    |
                                     +------------------+
```

## Module Usage

For information about how to use a Terraform module, please see the [Modules documentation
available at Terraform.io](https://www.terraform.io/docs/configuration/modules.html).

This module can be pulled by Terraform directly from GitHub. There's no need to clone this code
into another repo unless you're planning on modifying the module.

A typical usage of this module would look as follows.
```
module "EdgeAccelerator" {
  source = "github.com/packet-labs/EdgeAccelerator"

  packet_auth_token = YOUR_PACKET_AUTH_TOKEN
  packet_project_id = YOUR_PACKET_PROJECT_ID

  origin_url = format("http://some-http-webserver.com/")

  edges = [ "sjc1", "dfw2", ]
}
```

## Module Input Parameters

See the instructions below on how to get our Packet Auth (API) token and Project ID.
```
packet_auth_token
packet_project_id
```

The Origin URL is the full URL of the HTTP web server to be accelerated.
```
origin_url
```

The edges parameter is a list of all the Packet facilities to deploy web accelerators.
```
edges
```

## Module Output Parameters

List of IPv4 address of the deployed web accelerators/edge proxies.
```
deployed_edge_proxies_ipv4
```

List of IPv6 address of the deployed web accelerators/edge proxies.
```
deployed_edge_proxies_ipv6
```

## Packet Project ID & API Key

This deployment requires a Packet account for the provisioned bare metal. You'll need your "Packet Project ID" and your "Packet API Key" to proceed. You can use an existing project or create a new project for the deployment.

We recommend setting the Packet API Token and Project ID as environment variables since this prevents tokens from being included in source code files. These values can also be stored within a variables file later if using environment variables isn't desired.
```bash
export TF_VAR_packet_project_id=YOUR_PROJECT_ID_HERE
export TF_VAR_packet_auth_token=YOUR_PACKET_TOKEN_HERE
```

### Where is my Packet Project ID?

You can find your Project ID under the 'Manage' section in the Packet Portal. They are listed underneath each project in the listing. You can also find the project ID on the project 'Settings' tab, which also features a very handy "copy to clipboard" piece of functionality, for the clicky among us.

### How can I create a Packet API Key? 

You will find your API Key on the left side of the portal. If you have existing keys you will find them listed on that page. If you haven't created one yet, you can click here:

https://app.packet.net/portal#/api-keys/new
