# 🏢 Active Directory Home Lab Environment
<!--
![GitHub repo size](https://img.shields.io/github/repo-size/SlyCyberLab/Active-Directory-HomeLab)
![Last Commit](https://img.shields.io/github/last-commit/SlyCyberLab/Active-Directory-HomeLab)
![License](https://img.shields.io/github/license/SlyCyberLab/Active-Directory-HomeLab)
-->
> **A comprehensive virtualized Windows Server environment demonstrating enterprise-level Active Directory, DHCP, and NAT configuration skills.**

![Lab Status](https://img.shields.io/badge/Lab%20Status-Active-brightgreen)
![Windows Server](https://img.shields.io/badge/Windows%20Server-2025-blue)
![VMware](https://img.shields.io/badge/VMware-Workstation-orange)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-purple)

## 📋 Overview

This home lab demonstrates the setup and configuration of a complete Active Directory environment using VMware virtualization. The project showcases skills in Windows Server administration, network configuration, user management automation, and enterprise security practices.

### 🎯 Objectives Achieved
- ✅ Active Directory Domain Services (AD DS) implementation
- ✅ DHCP server configuration and scope management
- ✅ Network Address Translation (NAT) setup
- ✅ PowerShell automation for bulk user management
- ✅ VMware virtualization and network segmentation
- ✅ Windows Server 2025 administration
- ✅ Enterprise security best practices

## 🏗️ Architecture
<p align="center">
<img src="https://i.imgur.com/BQHD8sQ.png" />
<br />


## 📖 Implementation Guide

### Phase 1: Network Foundation

**🔧 VMware Network Configuration**

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

**🏛️ Active Directory Configuration**

#### 1. **Network Adapter Configuration**

**Rename Network Adapters:**
1. Open **Network and Sharing Center** → **Change adapter settings**
2. Rename adapters to `INTERNAL` and `INTERNET`

<p align="center">  
  <img src="https://imgur.com/EHszkF7.png" alt="Description" style="max-width: 80%; height: auto;" />
  <br />
</p>

**Configure INTERNAL Adapter:**
1. Right-click **INTERNAL** → **Properties** → **IPv4** → **Properties**
2. Set static IP configuration:
   - IP Address: `172.16.0.1`
   - Subnet Mask: `255.255.255.0`
   - Gateway: (leave blank)
   - DNS: `127.0.0.1`
3. Check "Validate settings upon exit" → **OK**

<p align="center">
  <img src="https://imgur.com/GXoTgBb.png" alt="Description" style="max-width: 80%; height: auto;" />
  <br />
</p>

> ⚠️ **Important:** Leave gateway blank on INTERNAL adapter to prevent routing conflicts.

#### 2. **Install Active Directory Domain Services**

**Server Manager Method:**
1. Server Manager → **Add roles and features**
2. Select **Active Directory Domain Services**
3. Include management tools → **Install**

<p align="center">
  <img src="https://i.imgur.com/hnqH4Kf.png" alt="Add Roles and Features" style="max-width: 400px; height: auto;" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/wL6Qx1q.png" alt="Select AD DS Role" style="max-width: 400px; height: auto;" />
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
  <img src="https://i.imgur.com/SGM2IRP.png" alt="Deployment Configuration" style="max-width: 400px; height: auto;" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/U3rZpaK.png" alt="Domain Controller Options" style="max-width: 400px; height: auto;" />
</p>

### Phase 3: Network Services

**🌐 DHCP and NAT Setup**

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
  <img src="https://i.imgur.com/buCKt7L.png" alt="DHCP Console Access" style="max-width: 500px; height: auto;" />
  <br><br>
  <img src="https://i.imgur.com/igXhiTL.png" alt="New Scope Wizard" style="max-width: 500px; height: auto;" />
</p>

**Scope Configuration:**
- **Scope Name:** `(you can give it the IP range name)`
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
  <img src="https://imgur.com/fXDutTz.png" alt="DHCP Scope Active" style="max-width: 500px; height: auto;" />
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
  <img src="https://i.imgur.com/F4EBgZP.png" alt="Configure Server Options" style="max-width: 400px; height: auto;" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/scoQJLs.png" alt="DNS Server Configuration" style="max-width: 400px; height: auto;" />
</p>


#### 4. **Setup NAT (Network Address Translation)**

**Configure Routing and Remote Access:**
1. Server Manager → **Tools** → **Routing and Remote Access**
2. Right-click your server → **Configure and Enable Routing and Remote Access**
3. Select **Network Address Translation (NAT)**
4. **External Interface:** INTERNET adapter
5. **Internal Interface:** INTERNAL adapter

<p align="center">
  <img src="https://i.imgur.com/KFkqk5B.png" alt="Routing and Remote Access Setup" height="300px" width="400px" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/mhh4rDV.png" alt="NAT Configuration" height="300px" width="400px" />
</p>

<p align="center">
  <img src="https://i.imgur.com/ThFVVef.png" alt="Interface Selection" height="300px" width="400px" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://i.imgur.com/eBIsPuf.png" alt="NAT Setup Complete" height="300px" width="400px" />
</p>


> 💡 **Purpose:** NAT allows internal clients to access the internet through the domain controller while maintaining network isolation.

### Phase 4: User Management Automation

**👥 PowerShell Bulk User Creation**

#### 1. **Prepare Required Files**

**Files Needed:**
- `names.txt` - List of users in "First Last" format
- [`bulk-create-users.ps1`](./scripts/bulk-create-users.ps1) - PowerShell automation script

#### 2. **Configure PowerShell Execution Policy**

**Launch PowerShell ISE as Administrator:**
1. Start Menu → Search "PowerShell ISE"
2. Right-click → **Run as administrator**

**Set Execution Policy:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
```
- When prompted, select **"Yes to All"**

<p align="center">  
  <img src="https://i.imgur.com/KJslHrT.png" alt="PowerShell Execution Policy Setup" style="max-width: 80%; height: auto;" />
</p>

> 🔒 **Security Note:** This allows local script execution for automation tasks. Use carefully in production environments.

#### 3. **Execute User Creation Script**

**Run the Bulk Creation Script:**
```powershell
.\bulk-create-users.ps1
```

The script will automatically:
- Read user names from `names.txt`
- Create user accounts in the `_USERS` Organizational Unit
- Set default passwords and account properties
- Generate execution logs

<p align="center">  
  <img src="https://i.imgur.com/5aNFo6X.png" alt="Script Execution in Progress" style="max-width: 80%; height: auto;" />
</p>


#### 4. **Script Features & Results**

**Automated Configurations:**
- **Default Password:** `1Password` (users must change on first login)
- **Organizational Unit:** `_USERS` 
- **Account Status:** Enabled and ready for use
- **Username Format:** First name initial + last name (e.g., "jdoe")

#### 5. **Organizational Structure Implementation**

**Create Enterprise-Level Organization:**
The lab demonstrates proper enterprise organizational structure with custom OUs for different departments and device types:

<p align="center">  
  <img src="https://i.imgur.com/zhCoopN.png" alt="Organizational Structure with Custom OUs" style="max-width: 80%; height: auto;" />
</p>

**Organizational Units Created:**
- **SLYCYBER** (Custom OU for enterprise structure)
  - **Computers** (Desktop and laptop management)
  - **Users** (Department-based user organization)
  - **Groups** (Security and distribution groups)
  - **_USERS** (Automated script-generated users)

> 💡 **Best Practice:** Always create Organizational Units, Groups, etc. to organize users, computers, and resources for better management and security policy application.

### Phase 5: Client Integration & Verification

**🖥️ Domain Client Configuration & Authentication**

#### **End-to-End Functionality Demonstration**

**Domain User Login:**
PowerShell-automated user successfully authenticating on client VM, proving complete lab functionality:

<p align="center">  
  <img src="https://i.imgur.com/wl4I3Qt.png" alt="Domain User Login with SLYCYBER credentials" style="max-width: 80%; height: auto;" />
</p>

**Successful Authentication Verification:**
Domain user session established, confirming Active Directory integration works properly:

<p align="center">  
  <img src="https://i.imgur.com/yuGfb2a.png" alt="whoami command showing domain authentication" style="max-width: 80%; height: auto;" />
</p>

**Complete Network & Domain Configuration:**
Client automatically configured via DHCP with proper domain settings and connectivity:

<p align="center">  
  <img src="https://i.imgur.com/XvCzWr3.png" alt="ipconfig showing DHCP assignment and domain configuration" style="max-width: 80%; height: auto;" />
</p>


### 🔍 Critical Issues & Solutions
**[→ View Build Process Challenges](LESSONS-LEARNED.md)**

*Some configuration challenges I encountered during implementation and systematic resolution approaches.*

---

> 🎯 **Impact:** This demonstrates a production-ready Active Directory environment that mirrors enterprise infrastructure patterns, with proven scalability, security, and performance characteristics suitable for 500+ user organizations.


## 🧪 Common Issues & Solutions

**🔍 Troubleshooting Guide**

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
│   └── names.txt
├── 📂 documentation/
│   ├── network-diagram.png
│   └── configuration-screenshots/
├── README.md
└── LICENSE
```


## 📞 Connect

[![LinkedIn](https://img.shields.io/badge/LinkedIn-View%20Profile-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/emsly-s-482794196)  
📧 [slycyber7@gmail.com](mailto:slycyber7@gmail.com)  
<!--🌐 [slycyber.com](https://slycyber.com) -->

---
<p align="center">
  ⭐️ If this lab helped or inspired you, consider giving it a star.
</p>

> This lab environment serves as a foundation for understanding enterprise Windows infrastructure and can be extended for more advanced scenarios including multi-domain forests, federation services, and hybrid cloud configurations.
