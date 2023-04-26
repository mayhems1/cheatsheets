# OpenVPN

## Ignore default route for OpenVPN client.conf

```conf
pull-filter ignore redirect-gateway
route 162.0.217.254 255.255.255.255
```

### Override pushed a route

```conf
# Options
client
route-nopull
route 10.1.0.0 255.255.255.128
route-metric 50

# or
route-nopull
route 192.168.0.0 255.255.0.0
```

## engine AES-NI

In OpenSSL >= 1.0.1 AES-NI is enabled by default in the EVP interface, and there is no aesni engine. So in nginx there is no configuration option to enable AES-NI for OpenSSL versions >= 1.0.1 as it is enabled by default in OpenSSL (as long as your CPU supports it). For OpenSSL versions < 1.0.1 there is no official support for AES-NI though there is a patch available.

### Verifying Cipher Support

```bash
/usr/bin/openssl engine -t -c
```

### OpenVPN cipher

To take advantage of acceleration in OpenVPN, choose a supported cipher on each end of a given tunnel.

Nothing needs selected for OpenVPN to utilize AES-NI. The OpenSSL engine has its own code for handling AES-NI that works well without using additional modules.

## Improve OpenVPN Performance and Throughput

- Try to disable compression and see if it affects OpenVPN speed (remove the option comp-lzo yes)
- If you are using TCP transport, replace it with UDP (proto udp)
- Try using a simpler encryption method. For example, AES-128-CBC instead of AES-256-CBC. (cipher AES-128-CBC)
- Check CPU usage when testing OpenVPN channel performance. If you find that one of the CPU cores is fully loaded by the OpenVPN process, then your CPU performance is not enough

## Use full links

- [Ignoring redirect-gateway](https://community.openvpn.net/openvpn/wiki/IgnoreRedirectGateway)
- [Overriding a pushed "route" in the client's config throws an error](https://openvpn.net/faq/overriding-a-pushed-route-in-the-clients-config-throws-an-error/)
- [How can I configure my OpenVPN client config file to route traffic only to the remote LAN?](https://unix.stackexchange.com/questions/626037/how-can-i-configure-my-openvpn-client-config-file-to-route-traffic-only-to-the-r)
- [Improving OpenVPN performance and throughput](https://haydenjames.io/improving-openvpn-performance-and-throughput/)
- [Optimizing performance on gigabit networks](https://community.openvpn.net/openvpn/wiki/Gigabit_Networks_Linux)
- [Optimizing performance on gigabit networks schema](https://community.openvpn.net/openvpn/attachment/wiki/Gigabit_Networks_Linux/OpenVPN-packetflow.png)
- [How to config openssl engine aes-ni in nginx](https://stackoverflow.com/questions/28939825/how-to-config-openssl-engine-aes-ni-in-nginx)
- [Cryptographic Accelerator Support](https://docs.netgate.com/pfsense/en/latest/hardware/cryptographic-accelerators.html)
- [How to fix link-mtu and tun-mtu are used inconsistently warnings in OpenVPN](https://itecnotes.com/server/openvpn-how-to-fix-link-mtu-and-tun-mtu-are-used-inconsistently-warnings-in-openvpn/)
- [How to Improve OpenVPN Performance and Throughput?](https://poweradm.com/improve-openvpn-speed/)
- [How to Optimize OpenVPN Speeds Like a Pro](https://blog.strongvpn.com/how-to-optimize-openvpn-speeds/)
