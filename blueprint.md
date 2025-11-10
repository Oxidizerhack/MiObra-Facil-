# Project Blueprint

## Overview
This project is a Flutter application designed to manage projects, calculate costs, and generate PDF reports. It utilizes `provider` for state management, `go_router` for navigation, `uuid` for unique ID generation, and `printing` along with `pdf` for PDF generation.

## Features Implemented
- **Project Management:** Create, view, and manage projects.
- **Cost Calculation:** Calculate costs for work items within a project.
- **PDF Export:** Generate PDF reports for projects.
- **Navigation:** Implemented using `go_router` for clear and deep linking navigation.
- **State Management:** Handled using `provider` for efficient state updates.

## Current Plan
The application is still failing to connect to the Dart Development Service (DDS) with the error "Failed to start Dart Development Service". This suggests a deeper issue than just a pre-existing connection, possibly a port conflict or a hung process. I will attempt to identify and terminate any running Dart processes that might be interfering and then try to run the application again.

## Steps
1. Identify any running Dart processes.
2. Terminate the identified Dart processes.
3. Run `flutter run` to rebuild and launch the application, attempting to establish a fresh DDS connection.