# Task-List-App

A simple task list app built with **Flutter** using the **BLoC** pattern.

---

## Table of Contents

- [Introduction](#introduction)  
- [Features](#features)  
- [Getting Started](#getting-started)  
  - [System Requirements](#system-requirements)  
  - [Installation](#installation)  
- [Architecture Overview](#architecture-overview)  

---

## Introduction

Task-List-App is a minimalist task manager built using Flutter and implemented with the BLoC (Business Logic Component) pattern. It’s designed to be simple, intuitive, and easy to extend.

---

## Features

- Add, update, and remove tasks  
- Mark tasks as completed  
- Simple and clean UI with Flutter  
- Scalable architecture using BLoC for state management

---

## Getting Started

### System Requirements

- **Flutter SDK** 
- **Dart SDK**  

### Installation

1. Clone the repository:  
   ```shell
   git clone https://github.com/White3ugar/Task-List-App.git
   cd Task-List-App
2. Install dependencies:
   ```shell
   flutter pub get
3. Run the app
   ```shell
   flutter run -d windows
4. Build a release executable
   ```shell
   flutter build windows
The compiled .exe will be located in: 
**build/windows/runner/Release/flutter_todolistapp.exe**

---

## Architecture Overview
The app is structured using the **BLoC (Business Logic Component)** pattern for state management:

### Blocs
- **TaskBloc** – Manages all task-related actions such as adding, deleting, and toggling task completion.  
- **TaskEvent** – Defines events that trigger state changes in the app.  
- **TaskState** – Defines the current state of the task list.

### UI
- **TaskScreen** – The main screen displaying:
  - Input fields for **title** and **content**
  - Task filter buttons (**All**, **Completed**, **Incomplete**)
  - Task list with checkboxes and delete options  
- Uses **BlocBuilder** to reactively update the UI based on the task state.

### Persistence
- Integration with **Hive** for local storage.  
- Each task contains:
  - `title` (required)
  - `content` (optional)
  - `isCompleted` (boolean)
  - `id` (unique identifier)
