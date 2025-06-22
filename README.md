# 🏢 Active Directory Home Lab Environment

> **A comprehensive virtualized Windows Server environment demonstrating enterprise-level Active Directory, DHCP, and NAT configuration skills.**

![Lab Status](https://img.shields.io/badge/Lab%20Status-Active-brightgreen)
![Windows Server](https://img.shields.io/badge/Windows%20Server-2025-blue)
![VMware](https://img.shields.io/badge/VMware-Workstation-orange)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-purple)

## 📋 Overview

This home lab demonstrates the setup and configuration of a complete Active Directory environment using VMware virtualization. The project showcases skills in Windows Server administration, network configuration, user management automation, and enterprise security practices.

### 🎯 Learning Objectives Achieved
- ✅ Active Directory Domain Services (AD DS) implementation
- ✅ DHCP server configuration and scope management
- ✅ Network Address Translation (NAT) setup
- ✅ PowerShell automation for bulk user management
- ✅ VMware virtualization and network segmentation
- ✅ Windows Server 2025 administration
- ✅ Enterprise security best practices

## 🏗️ Architecture
<p align="center">
<img src="https://imgur.com/BQHD8sQ.png" height="80%" width="80%"/>
<br />


## 📖 Implementation Guide

### Phase 1: Network Foundation

<summary>🔧 VMware Network Configuration</summary>

1. **Configure Virtual Network Editor**
   ```
   Edit → Virtual Network Editor → Run as Administrator
   ```
   
2. **Create Custom Network**
   - Network: `VMnet2`
   - Type: `Host-Only`
   - Subnet: `172.16.0.0/24`
   - ⚠️ Disable host virtual adapter

3. **Assign to VMs**
   - VM Settings → Network Adapter → Custom → VMnet2
 

### Phase 2: Domain Controller Setup


<summary>🏛️ Active Directory Configuration</summary>

#### 1. **Network Adapter Configuration**

**Rename Network Adapters:**
1. Open **Network and Sharing Center** → **Change adapter settings**
2. Rename adapters to `INTERNET` and `INTERNAL`

<p align="center">  
<img src="https://imgur.com/EHszkF7.png" height="80%" width="80%"/>
<br />

**Configure INTERNAL Adapter:**
1. Right-click **INTERNAL** → **Properties** → **IPv4** → **Properties**
2. Set static IP configuration:
   - IP Address: `172.16.0.1`
   - Subnet Mask: `255.255.255.0`
   - Gateway: (leave blank)
   - DNS: `127.0.0.1`
3. Check "Validate settings upon exit" → **OK**

<p align="center">
<img src="https://imgur.com/GXoTgBb.png" height="80%" width="80%"/>
<br />

> ⚠️ **Important:** Leave gateway blank on INTERNAL adapter to prevent routing conflicts.

#### 2. **Install Active Directory Domain Services**

**Server Manager Method:**
1. Server Manager → **Add roles and features**
2. Select **Active Directory Domain Services**
3. Include management tools → **Install**

<p align="center">
  <img src="https://i.imgur.com/hnqH4Kf.png" alt="Add Roles and Features" height="300px" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/wL6Qx1q.png" alt="Select AD DS Role" height="300px" />
</p>

**PowerShell Method:**
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

#### 3. **Promote to Domain Controller**

1. Click notification flag → **Promote this server to a domain controller**
2. Select **Add a new forest**
3. Root domain name: (example) `slycyber.local`
4. Set DSRM password
5. Keep default DNS settings
6. **Install** (server will restart)

<p align="center">
  <img src="https://i.imgur.com/SGM2IRP.png" alt="Deployment Configuration" height="300px" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/U3rZpaK.png" alt="Domain Controller Options" height="300px" />
</p>

 

### Phase 3: Network Services


<summary>🌐 DHCP and NAT Setup</summary>

#### 1. **Install Required Roles**
Run these PowerShell commands as Administrator:
```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
Install-WindowsFeature RemoteAccess -IncludeManagementTools
Install-WindowsFeature Routing -IncludeManagementTools
```

#### 2. **Configure DHCP Scope**

**Access DHCP Management:**
1. Server Manager → **Tools** → **DHCP**
2. Expand your server → Right-click **IPv4** → **New Scope**

<p align="center">
  <img src="https://i.imgur.com/buCKt7L.png" alt="DHCP Console Access" height="300px" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/igXhiTL.png" alt="New Scope Wizard" height="300px" />
</p>

**Scope Configuration:**
- **Scope Name:** `Internal Network`
- **IP Range:** `172.16.0.100 - 172.16.0.200`
- **Subnet Mask:** `255.255.255.0`
- **Default Gateway:** `172.16.0.1`
- **DNS Server:** `172.16.0.1`
- **Lease Duration:** 8 days

<p align="center">
  <img src="https://i.imgur.com/cnCvdJ1.png" alt="IP Address Range" height="300px" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/KKENCvJ.png" alt="Router/Gateway Settings" height="300px" />
</p>

**Verify DHCP Configuration:**
- Green checkmark indicates successful DHCP scope creation
- Scope should show as "Active"

<p align="center">
  <img src="https://imgur.com/fXDutTz.png" alt="DHCP Scope Active" height="300px" />
</p>

#### 3. **Configure Server Options**

**Set DNS Server Options:**
1. Right-click **Server Options** → **Configure Options**
2. Select **003 DNS Router**
3. Add IP Address: `172.16.0.1`
4. Click **OK**

**Restart DHCP Service:**
1. Right-click on the Domain Controller
2. **All Tasks** → **Restart**

<p align="center">
  <img src="https://i.imgur.com/F4EBgZP.png" alt="Configure Server Options" height="300px" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/scoQJLs.png" alt="DNS Server Configuration" height="300px" />
</p>

#### 4. **Setup NAT (Network Address Translation)**

**Configure Routing and Remote Access:**
1. Server Manager → **Tools** → **Routing and Remote Access**
2. Right-click your server → **Configure and Enable Routing and Remote Access**
3. Select **Network Address Translation (NAT)**
4. **External Interface:** INTERNET adapter
5. **Internal Interface:** INTERNAL adapter

> 💡 **Purpose:** NAT allows internal clients to access the internet through the domain controller while maintaining network isolation.

 

### Phase 4: User Management Automation

<summary>👥 PowerShell Bulk User Creation</summary>

**Files Required:**
- `names.txt` - List of users (First Last format)
- [`bulk-create-users.ps1`](./scripts/bulk-create-users.ps1) - Main automation script

**Execution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
.\bulk-create-users.ps1
```

**Features:**
- Creates users in `_USERS` OU
- Sets default password: `1Password`
- Enables accounts automatically
- Generates detailed logs
 

## 📊 Lab Capabilities

### 🔐 Security Features
- Domain-based authentication
- Centralized user management
- Group Policy enforcement
- Network segmentation
- Controlled internet access

### 📈 Scalability
- Support for 200+ concurrent DHCP clients
- Organizational Unit structure for department separation
- Group-based access controls
- Automated user provisioning

### 🔧 Administrative Tools
- Active Directory Users and Computers
- DHCP Management Console
- Routing and Remote Access
- PowerShell automation scripts
- Group Policy Management

## 🧪 Common Issues & Solutions


<summary>🔍 Troubleshooting Guide</summary>

| Issue | Symptom | Solution |
|-------|---------|----------|
| **Login Authentication** | "Sign-in method not allowed" | Run `gpupdate /force` on client |
| **DHCP Not Working** | Clients get APIPA addresses | Verify DHCP authorization in AD |
| **Internet Access Issues** | No external connectivity | Check NAT configuration and routing |
| **PowerShell Execution** | Script execution disabled | `Set-ExecutionPolicy Unrestricted` |
| **Domain Join Fails** | Cannot locate domain controller | Verify DNS settings point to DC |

 

## 📁 Repository Structure

```
📦 AD-HomeLabSetup/
├── 📂 scripts/
│   ├── bulk-create-users.ps1
│   ├── reset-user-password.ps1
│   └── generate-names.ps1
├── 📂 documentation/
│   ├── network-diagram.png
│   └── configuration-screenshots/
├── 📂 sample-data/
│   └── names.txt
├── README.md
└── LICENSE
```

## 🎓 Skills Demonstrated

**System Administration:**
- Windows Server 2025 deployment and configuration
- Active Directory design and implementation
- Network services management (DHCP, DNS, NAT)
- User and group management at scale

**Automation & Scripting:**
- PowerShell script development
- Bulk user provisioning
- Administrative task automation
- Error handling and logging

**Virtualization & Networking:**
- VMware Workstation configuration
- Virtual network design and implementation
- Network segmentation and security
- Multi-tier architecture design

**Security & Best Practices:**
- Enterprise authentication systems
- Network access control
- Security policy implementation
- Documentation and change management

## 🚀 Future Enhancements

- [ ] Certificate Services (PKI) implementation
- [ ] Exchange Server integration
- [ ] Advanced Group Policy configurations
- [ ] WSUS (Windows Update Services)
- [ ] Backup and disaster recovery procedures
- [ ] Monitoring and alerting with SCOM
- [ ] PowerBI reporting dashboard

## 📞 Connect

**LinkedIn:** [Your LinkedIn Profile]
**Email:** [Your Email]
**Portfolio:** [Your Portfolio Website]

---

⭐ **Star this repository if you found it helpful!**

> This lab environment serves as a foundation for understanding enterprise Windows infrastructure and can be extended for more advanced scenarios including multi-domain forests, federation services, and hybrid cloud configurations.
