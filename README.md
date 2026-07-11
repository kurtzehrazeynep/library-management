# Library Management System (Ruby)

![Ruby](https://img.shields.io/badge/ruby-3.x-red.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A robust, object-oriented Library Management System built with Ruby. This project demonstrates core Object-Oriented Programming (OOP) principles, persistent data storage using JSON, and comprehensive state management.

## 🚀 Features

* **JSON Data Persistence:** Books and member records are automatically saved and loaded from JSON files, ensuring no data is lost between sessions.
* **Soft Delete Mechanism:** Deactivating a member preserves their historical data without deleting them entirely from the system.
* **Ban Management:** Ability to ban members with specific reasons, restricting them from borrowing new books while still allowing returns.
* **Comprehensive Test Suite:** Includes automated testing using Minitest to ensure the reliability of the core logic.
* **Interactive CLI:** A user-friendly command-line interface for managing all library operations.

## 🏗️ Architecture & Software Principles

The project follows clean coding standards and architectural best practices:

* **Object-Oriented Programming (OOP):** Entities (Book, Member, Library) are properly encapsulated in their respective classes.
* **Separation of Concerns:** Data management, business logic, and user interface are isolated from each other.
* **Data Serialization:** Objects are serialized into JSON format for persistent storage and deserialized upon system startup.
* **Soft Delete Pattern:** Logical deactivation (`is_the_member_registered`) is used instead of hard deletion to maintain data integrity and historical records.

## ⚠️ Error Handling Flow

```text
[Member Action Request]
|
|──> Is Member Registered? ──> NO  ──> Deny Action & Show Warning ⚠️
|
|──> Is Member Banned?     ──> YES ──> Deny Action & Show Warning 🚫
|
|──> Conditions Met        ──> YES ──> Execute Action & Save Changes ✅