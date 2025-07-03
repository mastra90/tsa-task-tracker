# TSA Task Tracker - Full Stack Application

A modern task tracking web application built with React frontend and NestJS backend, fully containerized with Docker for easy deployment and development.

## 🚀 Universal installation solution

**Install with the following terminal command:**

```bash
rm -rf tsa-task-tracker && git clone --recursive https://github.com/mastra90/tsa-task-tracker.git && cd tsa-task-tracker && ./setup.sh
```

### Compatible with:

- Mac/Linux
- Windows: Ubuntu/WSL terminal (Windows Subsystem for Linux)

_Note: The installation will create a `tsa-task-tracker` folder in your current directory._

**This single command will:**

- ✅ Remove any existing installation
- ✅ Clone the latest code
- ✅ Set up and start the application
- ✅ Install dependencies for IDE support

## 📋 Prerequisites

- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
- **Git** - Usually pre installed on Mac/Linux, [download for Windows](https://git-scm.com/)

## 🌐 What You'll Get

After the command is successful, the application will be available at:

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3000

## 🛠 Tech Stack

### Frontend

- **React 19** with TypeScript
- **Vite 7** for fast development and building
- **Material UI** for modern, responsive UI components
- **Hot reloading** enabled for development

### Backend

- **NestJS** with TypeScript
- **Node.js 22** runtime
- **RESTful API** architecture
- **Jest** testing framework with unit tests
- **Hot reloading** enabled for development

### DevOps

- **Docker** containerization
- **Docker Compose** for orchestration
- **Optimized for development** with volume mounting

## 🌐 Features

- ✅ Create, read, update, and delete tasks
- 🎯 Filter tasks by completion status
- ✏️ Inline editing with validation
- ✨ Smooth animations and hover effects
- 🎨 Modern dark theme UI
- 📱 Responsive design
- 🔄 Real time updates
- 🧪 Unit tests for API endpoints
- 🐳 Fully containerized with Docker
- 🔥 Hot reloading for development

## 🧪 Testing

The backend includes unit tests covering core functionality:

### Running Tests

```bash
# Navigate to the API directory
cd tsa-task-tracker-api

# Install dependencies (if not using Docker)
npm install

# Run all tests
npm run test

# Run tests in watch mode
npm run test:watch
```

### Test Coverage

- **Controller Tests**: All CRUD operations (GET, POST, PUT, DELETE)
- **Service Tests**: Task management and ID generation
- **Basic validation**: Error handling for invalid requests

Tests are located in `src/*.spec.ts` files alongside the source code.

## 📁 Project Structure

```
tsa-task-tracker/
├── README.md                    # This file
├── setup.sh                     # Automated setup script
├── docker-compose.yml           # Orchestrates both services
├── tsa-task-tracker-frontend/   # React frontend (git submodule)
└── tsa-task-tracker-api/        # NestJS backend (git submodule)
```

## 📚 Development History

This project showcases modern full stack web development workflows with separate repositories for detailed development history:

### Individual Development Repositories

- **[Frontend Development](https://github.com/mastra90/tsa-task-tracker-frontend)** - Complete React development journey with commit history
- **[Backend Development](https://github.com/mastra90/tsa-task-tracker-api)** - Complete NestJS API development with commit history

---

**Built with ❤️ to demonstrate modern full stack web development practices.**

For detailed development history and individual commit messages, please see the individual repositories linked above.
