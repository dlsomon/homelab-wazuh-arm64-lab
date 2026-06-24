# Homelab Wazuh: Security Monitoring & CI/CD Rule Deployment

## Overview
This project establishes a centralized security monitoring environment using the Wazuh platform. It features the Wazuh central components (Manager, Indexer, Dashboard) hosted on an Ubuntu VM and a Kali Linux endpoint, with an integrated GitHub Actions CI/CD pipeline for automated rule deployment via a self-hosted runner.

## Key Features
- **Centralized Security Management:** Full installation of Wazuh central components on Ubuntu.
- **Cross-Platform Monitoring:** Integration of Kali Linux (ARM64) as a monitored endpoint.
- **CI/CD Pipeline:** Automated deployment of custom Wazuh rules via a dedicated self-hosted runner.


## Architecture & Design
The lab environment consists of three primary components:
1. **Wazuh Central Components (Ubuntu VM):** The core infrastructure (Manager, Indexer, Dashboard) responsible for log analysis, file integrity monitoring, alert generation, and visualization.
2. **Wazuh Agent (Kali Linux):** Installed on the endpoint to collect and forward system logs and security events.
3. **GitHub Actions Runner:** A self-hosted service (tagged `wazuh`) that connects the repository to the Wazuh central components for automatic rule updates.

> [!NOTE]
> **Architecture Constraint:** This homelab is hosted on Apple Silicon (Mac M-series chips). Therefore, all virtual machines and software packages (such as the Wazuh Agent) are specifically built for the **ARM64** architecture.
> **Virtualization & Network Constraint:** The Ubuntu and Kali Linux VMs are hosted on **VMware Fusion**. They operate in a strictly offline environment using **host-only network connections** with no external internet access.

## Getting Started

### Prerequisites

- Ubuntu VM (ARM64) (for Wazuh central components)
- Kali Linux VM (ARM64) (for endpoint monitoring)
- GitHub Repository with administrative access for Actions configuration
- Self-hosted GitHub Actions Runner hosted on the Mac Silicon machine

### Setup Guides
The setup process has been modularized into dedicated guides:

- **[Wazuh Installation Guide](wazuh-installation.md)**
  - Stage 1: Wazuh Central Components Installation (Ubuntu)
  - Stage 2: Wazuh Agent Deployment (Kali Linux)
  - Stage 3: Tuning alerts on initial setup

- **[GitHub CI/CD Setup Guide](github-setup.md)**
  - Stage 1: GitHub CI/CD Setup
  - Stage 2: Automated Rule Deployment Pipeline

## Future Roadmap / Decisions
- **Improve Documentation**: Make improvements to the documentation to make it more user-friendly.
- **Simulate Attacks:** Use Kali Linux to simulate attacks and test the detection capabilities of the Wazuh.
