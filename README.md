# 🐾PawPal

A comprehensive pet submission and management application built with Flutter for cross-platform deployment and a PHP backend for data management.

## Overview

PawPal is a user-friendly application that allows users to submit pet information, manage pet profiles, and track pet-related data. The application supports multiple platforms including iOS, Android, Web, Windows, macOS, and Linux, providing a seamless experience across all devices.


## 📌Features

- User registration and login
- User profile management
- Submit pets for adoption
- View user-submitted pets
- Submit adoption requests
- Donation submission and tracking
- Payment processing (Billplz sandbox via url_launcher)
- Image asset handling

## Tech Stack

**Frontend:**
- Flutter (Dart)
- Flutter Web

**Backend:**
- PHP
- MySQL
- XAMPP

**Additional Technologies:**
- REST API
- phpMyAdmin (Database Management)

## 📂Project Structure

```
pawpal/
│── lib/                      # Flutter application source code
│── assets/                   # Images and UI assets
│── server/
│   ├── musicbvk_pawpal_db_faiz.sql   # Database SQL file
│   └── pawpal/
│       ├── api/              # PHP API endpoints
│       ├── assets/           # Uploaded images / server assets
│       └── .htaccess
│── pubspec.yaml              # Flutter dependencies
```

## Prerequisites

Before you begin, ensure you have the following installed:

### For Backend
- XAMPP (Apache & MySQL)
- phpMyAdmin (included with XAMPP)
- PHP 7.4 or higher

### For Frontend
- Flutter SDK
- IDE: VS Code

## ⚙️ Project Setup

### 1️⃣ Backend Setup (PHP & MySQL)

1. Install XAMPP or any Apache + MySQL server.
2. Start Apache and MySQL services.
3. Open phpMyAdmin.
4. Create a new database (example: musicbvk_pawpal_db_faiz).
5. Import the SQL file:
```
server/musicbvk_pawpal_db_faiz.sql
```
6. Copy the pawpal folder into:
```
xampp/htdocs/
```
### 2️⃣ Configure Flutter Server URL
Edit the configuration file:
```
lib/myconfig.dart
```
Set the server URL:
```
const String server = "http://localhost/pawpal";
```
## 🔌 API Endpoints 
### 🔐 Authentication
- `register.php`  – Register new user
- `login.php` – User login

### 👤 User Profile
- `get_user_profile.php` – Fetch user profile
- `update_user_profile.php` – Update profile details

### 🐶 Pet Management
- `submit_pet.php` – Submit a pet for adoption
- `get_my_pet.php` – Get pets submitted by user
- `submit_adoption_request.php` – Request to adopt a pet

### 💰 Donations & Payments
- `submit_donation.php` – Submit donation
- `get_user_donations.php` – View user donation history
- `payment.php` – Create payment (Billplz sandbox)
- `payment_update.php` – Update payment status

### 🔗 Utilities
- `dbconnect.php` – Database connection file

**Made with ❤️ for pet lovers**
