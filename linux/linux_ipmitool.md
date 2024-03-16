# Cheat sheet ipmitool

## How to disable ipmi over lan using ipmitool

```bash
ipmitool lan set 1 access off

# or
ipmitool raw 0x6 0x40 0x01 0x40 0x44
ipmitool raw 0x6 0x40 0x01 0x80 0x84
```

## LAN Configuration

```bash
ipmitool lan set 1 ipsrc static
ipmitool lan set 1 ipaddr 192.168.1.211

# Setting LAN IP Address to 192.168.1.211
ipmitool lan set 1 netmask 255.255.255.0

# Setting LAN Subnet Mask to 255.255.255.0
ipmitool lan set 1 defgw ipaddr 192.168.1.254

# Setting LAN Default Gateway IP to 192.168.1.254
ipmitool lan set 1 defgw macaddr 00:0e:0c:aa:8e:13

# Setting LAN Default Gateway MAC to 00:0e:0c:aa:8e:13
ipmitool lan set 1 arp respond on

# Enabling BMC-generated ARP responses
ipmitool lan set 1 auth ADMIN MD5
ipmitool lan set 1 access on

# check
ipmitool lan print 1
```

## User Configuration

```bash
ipmitool user set name 3 monitor
ipmitool user set password 3
ipmitool channel setaccess 1 3 link=on ipmi=on callin=on privilege=2
ipmitool user enable 3
ipmitool channel getaccess 1 3
```

## Other

```bash
# Enabling BMC-generated ARP responses
ipmitool lan set 1 arp respond on

# Setting LAN SNMP Community String to public
ipmitool lan set 1 snmp public

ipmitool lan set 1 auth ADMIN MD2,MD5,PASSWORD

ipmitool lan set 1 access on

# Configure an SSH key for a remote shell user.
sunoem sshkey set

# Remove an SSH key from a remote shell user.
ipmitool sunoem sshkey del

# Read LED status.
ipmitool sunoem led get

# Set LED status.
ipmitool sunoem led set

# Enter Oracle ILOM CLI commands as if you were using the ILOM CLI directly. The lan interface or lanplus interface should be used.
ipmitool sunoem cli

# Available as of Oracle ILOM 3.0.10, a force option can be invoked as an argument to the sunoem CLI command.
ipmitool sunoem CLI force

# Execute raw IPMI commands.
ipmitool raw

# Print the current configuration for the given channel.
ipmitool lan print

# Set the given parameter on the given channel.
ipmitool lan set (1) (2)

# Display information regarding the high-level status of the system chassis and main power subsystem.
ipmitool chassis status

# Perform a chassis control command to view and change the power state.
ipmitool chassis power

# Control the front panel identify light. Default is 15. Use 0 to turn off.
ipmitool chassis identify

# Query the chassis for the cause of the last system restart.
ipmitool chassis restart_cause

# Request the system to boot from an alternative boot device on next reboot.
ipmitool chassis bootdev (1)

# Set the host boot parameters.
ipmitool chassis bootparam (1)

# Display the BMC self-test results.
ipmitool chassis selftest

# Return the BMC self-test results.
ipmitool power

# Send a predefined event to the system event log.
ipmitool event

# Query the BMC for sensor data records (SDR) and extract sensor information of a given type, then query each sensor and print its name, reading, and status.
ipmitool sdr

# List sensors and thresholds in a wide table format.
ipmitool sensor

# Read all field-replaceable unit (FRU) inventory data and extract such information as serial number, part number, asset tags, and short strings describing the chassis, board, or product.
ipmitool fru print

# View the Oracle ILOM SP system event log (SEL).
ipmitool sel

# Query the BMC and print information about the PEF- supported features.
ipmitool pef info

# Print the current PEF status (the last SEL entry processed by the BMC, and so on).
ipmitool pef status

# Print the current PEF list (the last SEL entry processed by the BMC, and so on).
ipmitool pef list

# Display a summary of user ID information, including maximum number of user IDs, the number of enabled users, and the number of fixed names defined.
ipmitool user

# Get information about the specified sessions. You can identify sessions by their ID, by their handle number, by their active status, or by using the keyword “all” to specify all sessions.
ipmitool session

# Enable or disable individual command and command sub-functions; determine which commands and command sub-functions can be configured on a given implementation.
ipmitool firewall (1)

# Set the runtime options including session host name, user name, password, and privilege level.
ipmitool set (1)

# Execute IPMItool commands from file name. Each line is a complete command.
ipmitool exec

# To change to DHCP
ipmitool lan set 1 ipsrc dhcp
```

## Reset Password and Username on BMC for Intel

```bash
ipmitool user list 1
ipmitool user set password 2 password@123

# IPMI commands to create a new user name
# The following commands can be used to create a new user and set a password:
# Ipmitool user set name "user id" "username"
# for example: #
ipmitool user set name 3 test
    
# Now set the password using the command below:
ipmitool user set password 3 password@123

# Enable a newly created user:
ipmitool user enable 3

# Set user privileges. In this case, we will set administrator privileges:
# Ipmitool channel setaccess channelNO. userID callin=on ipmi=on link=on privilege=4

# Below are the privilege levels that can be set for the user.
# Privilege levels:
#     0x1 - Callback
#     0x2 - User
#     0x3 - Operator
#     0x4 - Administrator
#     0x5 - OEM Proprietary
#     0xF - No Access

ipmitool channel setaccess 1 3 callin=on ipmi=on link=on privilege=4

# The user list command output below indicates new user test with administrator privileges.
ipmitool user list 1
```

## Sources

- [How to disable ipmi over lan using ipmitool](https://serverfault.com/questions/676145/how-to-disable-ipmi-over-lan-using-ipmitool)
- [Configuring IPMI under Linux using ipmitool](https://www.thomas-krenn.com/en/wiki/Configuring_IPMI_under_Linux_using_ipmitool)
- [How to re-configure IPMI using ipmitool](https://portal.nutanix.com/page/documents/kbs/details?targetId=kA0600000008db6CAA)
- [Configuring IPMI Tool for Remote Management](https://www.veritech.net/configuring-ipmi-tool-remote-management/)
- [Using IPMItool to View System Information](https://docs.oracle.com/cd/E19464-01/820-6850-11/IPMItool.html)
- [IPMItool Options and Command Summary](https://docs.oracle.com/cd/E37444_01/html/E37449/z400000c1016683.html)
- [Set IPMI to use DHCP](https://svennd.be/set-ipmi-to-use-dhcp/)
- [How to use IPMI Commands to Reset Password and Username on BMC for Intel® Server Boards](https://www.intel.com/content/www/us/en/support/articles/000055688/server-products.html)
- [Common BMC and IPMI Utilities and Examples](https://portal.nutanix.com/page/documents/kbs/details?targetId=kA0600000008T3jCAE)
- [Setup iLO Network Settings via ipmitool](https://www.tyler-wright.com/setup-ilo-network-settings-via-ipmitool/)
- [Example of BMC Configuration Using IPMItool](https://docs.oracle.com/en/database/oracle/oracle-database/19/cwlin/example-of-bmc-configuration-using-ipmitool.html#GUID-11E563E0-3688-4FE9-8440-81402A7AC23A)
- [Tunneling the IPMI/KVM ports over ssh (supermicro ipmi ports)](https://ahelpme.com/software/ipmitool/tunneling-the-ipmi-kvm-ports-over-ssh-supermicro-ipmi-ports/)
- [SUPERMICRO SERIAL PORT KVM](https://www.fmad.io/blog/supermicro-serial-kvm)
- [Supermicro IPMI remote console on Ubuntu 14.04 through SSH tunnel](https://strugglers.net/~andy/blog/2015/11/13/supermicro-ipmi-remote-console-on-ubuntu-14-04-through-ssh-tunnel/)
