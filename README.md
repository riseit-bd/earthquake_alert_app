# FastVPN Access

## "Access Fast, Stay Secure"

FastVPN Access is a next-generation VPN platform designed for speed, security, and scalability. It provides a complete VPN ecosystem supporting all major platforms with enterprise-grade white-label capabilities for global reseller networks.

## Project Structure

```text
fastvpn-access/
├── fastvpn-core/              # VPN protocol implementations (WireGuard, FastWire)
├── fastvpn-clients/           # All platform clients
│   ├── windows/               # Windows Client (Electron + WFP)
│   ├── macos/                 # macOS Client (Electron + Network Extension)
│   ├── ios/                   # iOS App (React Native)
│   ├── android/               # Android App (React Native)
│   ├── linux/                 # Linux Client (Flutter)
│   ├── browser-extensions/    # Chrome/Firefox/Edge/Safari extensions
│   └── router-firmware/       # OpenWRT/AsusWRT/DD-WRT support
├── fastvpn-admin/             # Admin control panel (Next.js)
├── fastvpn-reseller/          # White-label portal (Next.js)
├── fastvpn-api/               # Backend services (Go API Gateway + NestJS Microservices)
├── fastvpn-billing/           # Subscription engine (Stripe/PayPal/Crypto)
├── fastvpn-infrastructure/    # Terraform/K8s configs
├── fastvpn-analytics/         # Monitoring & BI (Prometheus/Grafana)
├── fastvpn-docs/              # Documentation
└── fastvpn-tests/             # Test suites
```

## Tech Stack

- **Frontend:** React Native (Mobile), Electron (Windows/macOS), Flutter (Linux), Next.js 14 (Web/Admin)
- **Backend:** Go (API Gateway), Node.js/NestJS (Microservices)
- **Database:** PostgreSQL + TimescaleDB, Redis, Elasticsearch
- **Infrastructure:** Docker, Kubernetes, Terraform, Ansible
- **Monitoring:** Prometheus, Grafana, Loki

## Core Features

- **FastConnect™ Protocol Engine:** Proprietary optimizations including SpeedBoost, StreamAdapt, and GameMode.
- **Protocol Support:** WireGuard®, FastWire™ (Custom), OpenVPN, IKEv2.
- **White-Label System:** FastLaunch™ Reseller Portal with full branding control.
- **Security:** AES-256-GCM, No-Logs Architecture, Advanced Kill Switch, DNS Firewall.
