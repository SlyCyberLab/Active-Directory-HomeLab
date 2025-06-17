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

```
📊 Network Topology:
Physical Host (Windows) 
    ↓
VMware Workstation
    ↓
Host-Only Network (VMnet2: 172.16.0.0/24)
    ↓
┌─────────────────────────────────────┐
│     Windows Server 2025             │
│  • Domain Controller (slycyber.local)│
│  • DHCP Server (172.16.0.100-200)   │
│  • NAT Gateway (172.16.0.1)         │
└─────────────────┬───────────────────┘
                  │
          Windows 11 Clients
      (Auto-assigned DHCP IPs)
```

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Virtualization** | VMware Workstation | Host multiple VMs with network isolation |
| **Server OS** | Windows Server 2025 | Domain controller and network services |
| **Client OS** | Windows 11 | Domain-joined workstations |
| **Directory Services** | Active Directory DS | Centralized authentication and authorization |
| **Network Services** | DHCP, NAT/RAS | IP management and internet connectivity |
| **Automation** | PowerShell | Bulk user creation and management |
| **Network Design** | Custom VMnet | Isolated lab environment |

## 🚀 Quick Start

### Prerequisites
- VMware Workstation (15.5+)
- Windows Server 2025 ISO
- Windows 11 ISO
- Minimum 8GB RAM, 100GB storage

### Default Credentials
```
Domain: slycyber.local
Username: Administrator
Password: 1Password
```

## 📖 Implementation Guide

### Phase 1: Network Foundation
<details>
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
</details>

### Phase 2: Domain Controller Setup
<details>
<summary>🏛️ Active Directory Configuration</summary>

1. **Network Adapter Configuration**
   ```
   INTERNAL: 172.16.0.1/24 (for clients)
   INTERNET: DHCP/NAT (for external access)
   ```

2. **Install AD DS Role**
   ```powershell
   Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
   ```

3. **Promote to Domain Controller**
   - Forest: `slycyber.local`
   - Functional Level: Windows Server 2022
   - DNS: Install DNS server role
</details>

### Phase 3: Network Services
<details>
<summary>🌐 DHCP and NAT Setup</summary>

1. **Install Required Roles**
   ```powershell
   Install-WindowsFeature DHCP -IncludeManagementTools
   Install-WindowsFeature RemoteAccess -IncludeManagementTools
   Install-WindowsFeature Routing -IncludeManagementTools
   ```

2. **Configure DHCP Scope**
   - Range: `172.16.0.100 - 172.16.0.200`
   - Gateway: `172.16.0.1`
   - DNS: `172.16.0.1`
   - Lease Duration: 8 days

3. **Setup NAT**
   - Routing and Remote Access → Configure NAT
   - External Interface: INTERNET adapter
   - Internal Interface: INTERNAL adapter
</details>

### Phase 4: User Management Automation
<details>
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
</details>

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

<details>
<summary>🔍 Troubleshooting Guide</summary>

| Issue | Symptom | Solution |
|-------|---------|----------|
| **Login Authentication** | "Sign-in method not allowed" | Run `gpupdate /force` on client |
| **DHCP Not Working** | Clients get APIPA addresses | Verify DHCP authorization in AD |
| **Internet Access Issues** | No external connectivity | Check NAT configuration and routing |
| **PowerShell Execution** | Script execution disabled | `Set-ExecutionPolicy Unrestricted` |
| **Domain Join Fails** | Cannot locate domain controller | Verify DNS settings point to DC |

</details>

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
