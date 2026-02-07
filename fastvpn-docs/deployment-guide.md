# Deployment Guide: FastVPN Access

This document outlines the steps required to take the FastVPN Access project from code to a live production environment.

## 1. Prerequisites

- **Dedicated Server:** Ubuntu 22.04 LTS recommended.
- **Database:** MySQL 8.0+.
- **Runtime:** Node.js 20.x+.
- **Process Manager:** PM2.
- **Domain Name:** A registered domain for the API and reseller portals.
- **SSL Certificates:** Managed via Let's Encrypt (Certbot).

## 2. Infrastructure Provisioning

### Dedicated Server Setup
Use the provided script to prepare your dedicated server:
```bash
./scripts/setup-dedicated-server.sh
```

### Database Initialization
Initialize the MySQL schema:
```bash
mysql -u root -p < fastvpn-infrastructure/mysql/init.sql
```

### Global Network (Optional)
For scaling, you can still use Terraform to manage additional VPN nodes:

```bash
cd fastvpn-infrastructure
terraform init
terraform plan
terraform apply
```

This will provision:
- VPN Gateways in multiple regions.
- Load Balancers for the API Gateway.
- Managed Database instances (PostgreSQL, Redis).

## 3. Backend Deployment (Node.js)

The Node.js backend should be deployed using PM2 for high availability.

1. **Build the project:**
   ```bash
   cd fastvpn-api/node-backend
   npm install
   npm run build
   ```
2. **Start with PM2:**
   ```bash
   pm2 start dist/main.js --name fastvpn-api
   ```

## 4. Frontend Deployment (Next.js)

Both Admin and Reseller portals run on Node.js.

1. **Build and Start Admin:**
   ```bash
   cd fastvpn-admin
   npm install
   npm run build
   pm2 start npm --name "fastvpn-admin" -- start
   ```
2. **Build and Start Reseller:**
   ```bash
   cd fastvpn-reseller
   npm install
   npm run build
   pm2 start npm --name "fastvpn-reseller" -- start
   ```

## 5. Client Application Distribution

- **Mobile (iOS/Android):** Submit to Apple App Store and Google Play Store.
- **Desktop (Windows/macOS):** Signed installers distributed via CDN.
- **Linux:** Packages distributed via DEB/RPM and Snap/Flatpak.
- **Browser Extensions:** Submitted to Chrome Web Store and Firefox Add-ons.

## 6. Live Verification

Once deployed, verify the live status:

- **Health Check:** `https://api.yourdomain.com/health`
- **Server Status:** `https://api.yourdomain.com/status`
- **Admin Dashboard:** `https://admin.yourdomain.com`

## 7. Continuous Integration & Deployment (CI/CD)

The project uses GitHub Actions for automated testing and deployment. Every push to the `main` branch triggers:
1. Unit and Integration tests.
2. Security scanning.
3. Automated deployment to the staging environment.
4. (Manual Approval) Promotion to production.
