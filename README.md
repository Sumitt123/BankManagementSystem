# 🏦 Bank Management System (Java Web Application)

A simple Java-based web application for managing basic banking operations such as registration, login, deposit, withdrawal, transfer, and account management. Designed using
**JSP**, **Servlets**, **JDBC**, and **MySQL**.

---

## 🚀 Features

- 👤 User Registration & Login
- 💰 Deposit & Withdraw Funds
- 🔁 Fund Transfer Between Accounts
- 📄 Transaction History
- 👁️ View Account Details
- 🛠️ Admin Panel to Manage Users

---

## 🛠️ Technologies Used

| Technology       | Description                     |
|------------------|---------------------------------|
| Java (JSP/Servlet) | Server-side business logic     |
| HTML/CSS         | UI Design                       |
| MySQL            | Database                        |
| JDBC             | Database Connectivity           |
| Apache Tomcat    | Application Server              |
| Eclipse IDE      | Development Environment         |

---

## 📁 Project Structure

BankManagementSystem/
├── src/
│   └── main/
│       ├── java/
│       │   ├── servlet/         # Servlet classes
│       │   └── util/            # DB connection class
│       └── webapp/
│           ├── CSS/             # Stylesheets
│           ├── images/          # Icons and Images
│           ├── *.jsp            # JSP pages
│           └── WEB-INF/
│               └── web.xml      # Servlet configuration
├── .gitignore
├── README.md

---

## 🔑 Default Admin Credentials (Optional)

```txt
Username: admin
Password: admin123
🔒 Make sure to change these in production.

⚙️ How to Run the Project
Clone the repository:

bash
Copy
Edit
git clone https://github.com/Sumitt123/BankManagementSystem.git
Import the project into Eclipse as a Dynamic Web Project.

Setup MySQL database:

Create a database: bankdb

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    father_name VARCHAR(100) NOT NULL,
    mobile VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    account_number VARCHAR(20) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Extra details
    account_type VARCHAR(50) DEFAULT 'Savings',
    branch VARCHAR(100) DEFAULT 'Main Branch',
    balance DECIMAL(12,2) DEFAULT 10000.00,
);

-- Create transaction table
CREATE TABLE transaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL, -- e.g., 'Deposit', 'Withdraw', 'Transfer'
    amount DECIMAL(12,2) NOT NULL,
    description VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


Configure your DB credentials in DatabaseConnection.java:

java
Copy
Edit
String url = "jdbc:mysql://localhost:3306/bankdb";
String username = "root";
String password = "your_password";
Run the application using Apache Tomcat.

Access it on:

arduino
Copy
Edit
http://localhost:8080/BankManagement/
🤝 Contribution
Feel free to fork this project and contribute by submitting a pull request.

📧 Contact
Sumit Bhargav
📩 bhargavsumit045@gmail.com
🌐 GitHub - Sumitt123

