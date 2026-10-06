---
title: Networking
description: The internet, addresses, and routing protocols
author: Carl Luo
date: 2026-10-05T15:38:00-07:00
draft: false
toc: false
tags:
  - networking
---

## Big Idea
Q: Why do we need networks?
A: Because we want **easy communication**!

What do we need for easy communication?
- Low latency
- High bandwidth
- Ability to easily identify a computer 
- Fault tolerance

Networking in general is designed around these principles!

## Models of The Internet
The model the internet is designed on has seven layers. This is the **OSI** model.

If you're in the SWE world, you will hear this model being referenced up a lot. This model however is theoretical, and moreso acts like a blueprint that tells you how network communications *should* work. 

![OSI Model](https://textbook.cs168.io/assets/intro/1-07-layers.png)

--- 

The model that the internet is built on, and the model you care about more as a syadmin, only has four layers. This is the **TCP/IP** model.

It's loosely defined (functions can be in-between levels), and higher layers abstract lower layers. This model is what we'll be discussing today.

![TCP/IP Model](https://media.geeksforgeeks.org/wp-content/uploads/20251215161451592856/tcp-layers.webp)

Let's assume that for now, we are given a packet. Let's move our packet through the internet!

## Link Layer
<!-- [Minecraft](https://i.ytimg.com/vi/7YZtyeqt4V0/maxresdefault.jpg) -->

The link layer is the lowest layer in the stack. This layer is responsible for physically transmitting the data over network hardware. Its job is to get data from one machine to the next machine (most likely, next router or next switch) on the same local network. Ethernet and WiFi are examples of two protocols that operate in this layer. 

If you log into your VM and run: 
```bash
$ ip -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
eth0             UP             oc:f1:st:h3:b3:st <BROADCAST,MULTICAST,UP,LOWER_UP> 
```

Each line is an interface, something the kernel can send packets out of. 
- **lo** is the loopback. It's not a real device and anything sent here doesn't leave the machine.
- **eth0** is your VM's (virtual) network card!

Behind their names, we have their status (`UNKNOWN`, `UP`, or `DOWN`), then their MAC address.

### MAC Address
Corresponding to the "physical layer", we have our "physical address"! 

The easiest way to think of MAC addresses are exactly that, as "physical addresses". It's globally unique to each device and tied to hardware, like a person's ID! We use MAC addresses to uniquely identify devices on local network.

To know where our packets are going, we resolve our IP addresses to MAC addresses using ARP/NDP. You can read up more on ARP on [Lab 5](https://decal.ocf.io/labs/5/#arp), and NDP can be thought of as an IPv6 version of ARP.

So now, our packet gets wrapped in another packet with an Ethernet header in front, which tells the packet the destination MAC address, or where to go. Next stop is the internet!

## Internet Layer
<!-- ![Hypixel](https://skinmc.net/storage/servers/images/v1/full/2026/02/73e1e4f4-abd4-4d05-8922-2aff9ca73685.jpg)-->

The internet layer is responsible for addressing, packaging, and routing data packets so they can travel across networks and reach the destination device. It goes through routers, and transmit data to different networks.

To decide where to jump to, routers maintain routing tables, which tells us where to hop next. 
![Routing Table](https://cdn.discordapp.com/attachments/936027131752894504/1556977337382342758/image.png?backend=b2&ex=6ac61fa4&is=6ac4ce24&hm=93ea4dc03358830c0d851e019b29933ed45aa6919be02961574843237cfde0dc)
Try running
```bash
$ traceroute asuc.org
$ traceroute google.com
$ traceroute gov.br
```

`traceroute` lists every router that your data passes through to get from the source to the destination server. Pretty cool!

### IPv4 and IPv6
IPv4 addresses uniquely identify a host, on a local network, or across the internet. The address is 4 bytes and usually written as four decimal numbers from 0-255 separated by a period. Like `128.169.32.1`!

Sometimes, you'll see `128.169.32.0/24`. That `/24` is a **subnet mask**! It represents a range of IPv4 addresses, where the first 24 bits of the address (`128.168.32`) is the network prefix and is fixed in place, and the last 8 bits is the host identifier. You can also view this as representing the range of addresses `128.169.32.0-255`.

Since there are only 4.3 billion IPv4 addresses, but 8 billion people in the world and certainly many more internet accessing devices than that, what do we do? Thus came IPv6! It contains 128 bits instead of 32, and looks like `1234:5678:89:0:ab:cd:ef:beef`.

If you log into your VM and run: 
```bash
$ ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eth0             UP             169.229.226.1xx/24 2607:f140:8801::2:1xx/64 fe80::be24:11ff:fe81:c0rl/64
```

You might not see the IPv4 address (`169.229.226.1xx`) there. This is because as of today, we haven't fully provisioned IPv4 addresses to the DeCal vms yet, so you might just have an IPv6 address under `eth0`. 

So now our packet is in across the globe in the correct machine! Or is it?

## Transport Layer
<!--![Group photo](https://i.imgur.com/ikaFN6R.png)-->

The transport layer is responsible for **reliable and effective** delivery of data between devices. It contains protocols for deaeling with communication between computers. 

### TCP 
This is the **reliable** protocol.
- Reliability > speed. 
- You get an ordered stream of bytes. What you put in is what comes out! Sounds simple, but the internet is unreliable, and packets get silently dropped all the time.
- Connection-oriented. Need to initiate a connection before sending data, and receivers sends back ACK (acknowledgement) so we know they received the packet. Otherwise we'll just keep resending!
- Reliable but additional latency and overhead due to the 3-way handshake and the ACKs.
- Used for pretty much everything. E.g. emailing, web browsing, file sharing.
![SYNACK](https://static.afteracademy.com/images/what-is-a-tcp-3-way-handshake-process-three-way-handshaking-establishing-connection-6a724e77ba96e241.jpg)

### UDP
This is the **effective** protocol. 
- There are **no reliability guarantees**! 
- No connection is established either. It just "shoots" all packets and doesn't worry about whether they're received or not. 
- No way of knowing if the recipient received the data.
- Good for applications where lots of data is sent, low latency is required, and packet loss is OK!
- E.g. Youtube, video calls, video games! If you've lagged before, you've been on the receiving end of UDP.
![UDP Diagram](https://d2cest1yk6hx2d.cloudfront.net/uninets-001/store/3057/article%20images/udp-working%20(1).png)

Great, so now our packet is *actually* in the correct machine, and it's delivered nicely and neatly. TIme to pick it up!

## Application Layer
The application layer is where application specific functions happen!

Everything up until now has built up a foundation for reliably transmitting packets over the internet, only now can we assume we have a reliable, end-to-end connection between computers. So now we focus on what can actually be done with the data! 

This also shows the power and purpose of the layered design of the internet. All the low level networking things are abstracted away, and applications can take it all for granted.

<!--[Application Layer](https://media.geeksforgeeks.org/wp-content/uploads/20251215122700271313/application-layer.gif)-->

### DNS
Maps human readable names to IP addresses. Like `erdaifuu.decal.ocfhosted.com` to `128.38.169.100`. 
```bash
$ dig google.com
; <<>> DiG 9.20.29 <<>> google.com A
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16153
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		254	IN	A	142.251.218.142

;; Query time: 28 msec
;; SERVER: 75.75.75.75#53(75.75.75.75) (UDP)
;; WHEN: Tue Oct 06 03:52:34 PDT 2026
;; MSG SIZE  rcvd: 55
```

We'll talk about this a LOT more in the next lecture.

--- 

Putting it all together, our packet first goes to the link layer and heads up the ethernet. Then it decodes its destination IP address, goes from the local router and bounces around other routers until it finally ends up in the destination address. Then the transport protocol strips the packet and handles how it is received. Finally, the packet goes up into the application, where we can do anything we'd like with it. Hoorah!

If you're interested in what I talked about this lecture, look into CS 168! 
