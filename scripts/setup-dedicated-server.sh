#!/bash/bin

# FastVPN Access - Dedicated Server Setup Script (Ubuntu)
# This script installs Node.js, MySQL, and PM2 for hosting the FastVPN stack.

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Node.js (Latest LTS)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "Installing MySQL Server..."
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

echo "Installing PM2 (Process Manager)..."
sudo npm install -g pm2

echo "Installing Git..."
sudo apt install -y git

echo "Setup complete! Please configure MySQL and clone the repository."
echo "Suggested next steps:"
echo "1. Run: sudo mysql_secure_installation"
echo "2. Run: mysql -u root -p < fastvpn-infrastructure/mysql/init.sql"
echo "3. Run: npm install and build for backend/frontend"
echo "4. Use PM2 to start the services: pm2 start dist/main.js --name vpn-api"
