# 🏢 Employee Affairs Management System (EAMS)

## 📖 Overview

The **Employee Affairs Management System (EAMS)** is a comprehensive Flutter-based Software as a Service (SaaS) application designed to streamline workforce management for small businesses and enterprises. EAMS covers all aspects of employee management—from hiring to retirement—offering a user-friendly interface that caters to both managers and employees. With features for tracking attendance, processing payroll, and managing holiday requests, EAMS aims to improve operational efficiency and accuracy in handling workforce data.

## 🚀 Features

### 1. Multi-Company Support

- **Company Creation**: Allows managers to create a company with required fields: company name, manager's name, password, company diameter, and location for attendance.
- **User Roles**: Supports two types of users - Admins (Managers) and Employees.

### 2. Authentication and Access Control

- **Login Functionality**: Provides secure login for both managers and employees, with access to specific dashboards and features based on their roles.

### 3. Manager Dashboard

- **Employee Management**: Add, view, edit, and delete employee profiles; assign departments and shifts.
- **Department Management**: Create and manage departments with employee assignments.
- **Shift Management**: Define shifts with customizable hours.
- **Attendance Reports**: Track daily and monthly attendance and individual employee attendance history.
- **Holiday Requests**: Receive, review, and respond to employee holiday requests with automated salary adjustments.

### 4. Employee Dashboard

- **Self-Attendance**: Capture attendance with image and location matching to verify proximity to the company location.
- **Profile Information**: View personal details and edit contact information.
- **Salary Overview**: Access current salary details, deductions, and total salary.
- **Holiday Requests**: Submit holiday requests with specified start and end dates.

### 5. Advanced Functionalities

- **Attendance Validation**: Utilizes both image capture and geolocation for accurate attendance tracking.
- **Dynamic Payroll Calculations**: Calculates employee salary per minute based on attendance and assigned shift hours.
- **Data Security and Integrity**: Only managers can change sensitive employee data, preventing unauthorized edits.

## 💡 How It Works

1. **Company Registration**: Admins register their company with key details such as company name, location, and primary contact information.
2. **Employee and Department Setup**:
   - Create departments and assign managers.
   - Add employees to the system with necessary details including role, department, and shift assignments.
3. **Attendance Tracking**:
   - Employees mark their attendance through a dedicated interface.
   - Attendance is validated using image capture and location verification to ensure authenticity.
4. **Payroll Processing**:
   - Payroll is calculated based on attendance records, factoring in any leave taken.
   - Detailed pay stubs are generated for employee access.
5. **Request Management**:
   - Employees submit holiday requests through their dashboard.
   - Admins can review, approve, or deny requests and manage employee leave records efficiently.

## 🔧 Technologies Used

- **Flutter**: A powerful UI toolkit for building natively compiled applications across mobile, web, and desktop platforms from a single codebase.
- **Dart**: The programming language that powers Flutter applications, providing strong performance and a rich set of features.
- **Cubit**: A lightweight state management library that simplifies state management in Flutter applications, ensuring efficient handling of state changes.
- **http**: For making network requests and facilitating API integration to manage employee data and attendance tracking.
- **SharedPreferences**: Used for persistent local data storage, allowing the app to remember user settings and preferences.
- **Geolocation**: Leverages device GPS capabilities to accurately determine the user’s location for attendance tracking and validation.
- **Animation and Responsive Design**: Implements smooth animations and responsive layouts to provide an engaging and adaptive user experience across various devices and screen sizes.

## 📡 API

EAMS integrates with custom APIs to facilitate seamless data processing and communication between the front-end and back-end systems. The APIs include:

- **Employee Management**: For performing CRUD operations on employee profiles.
- **Attendance Tracking**: To submit and validate attendance records in real time, ensuring data integrity.
- **Payroll Processing**: To calculate and manage payroll data securely and efficiently.
- **Company Management**: Manages company data, including:
  - **Company Names**: Stores names of companies in the app.
  - **Manager Credentials**: Handles usernames and passwords for managers.
  - **Location**: Captures the location of the company for attendance purposes.
  - **Company Diameter**: Records the physical size or reach of the company for operational insights.
- **Department Management**: Facilitates the creation and management of departments, including:

  - **Department Name**: Stores the name of each department.
  - **Description**: Provides a brief overview of the department's purpose and functions.
  - **Manager Name**: Associates a manager with the department for oversight and accountability.

- **Shift Management**: Manages shift data, including:
  - **Shift Name**: Identifies each shift by a unique name.
  - **Description**: Offers details about the nature of the shift.
  - **Start Date and End Date**: Defines the duration of the shift, allowing for flexible scheduling and management.
