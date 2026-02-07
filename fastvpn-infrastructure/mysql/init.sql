CREATE DATABASE IF NOT EXISTS fastvpn_db;
USE fastvpn_db;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'reseller', 'user') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Servers table
CREATE TABLE IF NOT EXISTS servers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    country_code CHAR(2) NOT NULL,
    city VARCHAR(100),
    protocol ENUM('wireguard', 'fastwire', 'openvpn', 'ikev2') DEFAULT 'wireguard',
    is_active BOOLEAN DEFAULT TRUE,
    load_percentage INT DEFAULT 0
);

-- Subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    status ENUM('active', 'expired', 'cancelled') DEFAULT 'active',
    expires_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Initial Admin
INSERT INTO users (username, email, password_hash, role)
VALUES ('admin', 'admin@fastvpn.access', '$2b$10$ExampleHash', 'admin')
ON DUPLICATE KEY UPDATE id=id;
