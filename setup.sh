#!/bin/bash

echo "🚀 Setting up TSA Task Tracker..."

# Check if we're in the right directory (avoid accidental deletion)
if [ ! -f "setup.sh" ] && [ -d "tsa-task-tracker" ]; then
    echo "🗑️  Removing existing directory..."
    rm -rf tsa-task-tracker
    echo "✅ Directory cleaned up!"
fi

# If we're already in the project directory, continue
if [ -f "setup.sh" ]; then
    echo "✅ Already in project directory, continuing setup..."
fi

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    echo ""
    echo "❌ Docker not found!"
    echo ""
    echo "📋 To run this application, you need to install Docker Desktop:"
    echo "   → Visit: https://www.docker.com/products/docker-desktop/"
    echo "   → Download and install Docker Desktop for your system"
    echo "   → After installation, run through the initial Docker setup (login not required and can be skipped)"
    echo "   → Close this terminal and run the command again"
    echo ""
    echo "💡 Docker Desktop includes everything needed (Docker + Docker Compose)"
    echo ""
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
    echo ""
    echo "❌ Docker Compose not found!"
    echo ""
    echo "📋 Docker Compose is required to run this application:"
    echo "   → If you have Docker Desktop: restart it and try again"
    echo "   → If you have Docker Engine only: install docker-compose"
    echo "   → Visit: https://docs.docker.com/compose/install/"
    echo ""
    exit 1
fi

# Check if Docker daemon is running
echo "🔍 Checking Docker daemon..."
if ! docker info >/dev/null 2>&1; then
    echo "⚠️  Docker daemon not running. Starting Docker..."
    
    # Try to start Docker on different platforms
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "   → Starting Docker Desktop on macOS..."
        open -a Docker
        echo "   → Waiting for Docker to start..."
        # Wait for Docker to be ready (up to 60 seconds)
        for i in {1..60}; do
            if docker info >/dev/null 2>&1; then
                echo "   ✅ Docker started successfully!"
                break
            fi
            if [ $i -eq 60 ]; then
                echo ""
                echo "❌ Docker failed to start automatically!"
                echo ""
                echo "📋 Please start Docker manually:"
                echo "   → Open Docker Desktop from Applications"
                echo "   → Wait for Docker to start (whale icon in menu bar)"
                echo "   → Close the terminal and run the command again."
                echo ""
                exit 1
            fi
            sleep 1
        done
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        echo "   → Starting Docker on Linux..."
        if command -v systemctl >/dev/null 2>&1; then
            sudo systemctl start docker
            sleep 3
            if docker info >/dev/null 2>&1; then
                echo "   ✅ Docker started successfully!"
            else
                echo "❌ Failed to start Docker"
                echo "   → Please start it manually: sudo systemctl start docker"
                echo "   → Close the terminal and run the command again"
                exit 1
            fi
        else
            echo "❌ Cannot auto-start Docker"
            echo "   → Please start Docker manually"
            echo "   → Close the terminal and run the command again"
            exit 1
        fi
    else
        # Windows or other
        echo ""
        echo "❌ Docker daemon not running!"
        echo ""
        echo "📋 Please start Docker manually:"
        echo "   → Open Docker Desktop"
        echo "   → Wait for Docker to start completely"
        echo "   → Close the terminal and run the command again"
        echo ""
        exit 1
    fi
else
    echo "✅ Docker daemon is running!"
fi

# Check if .gitmodules exists (proper submodule setup)
if [ ! -f ".gitmodules" ]; then
    echo "⚠️  No .gitmodules found. Setting up submodules properly..."
    
    # Clean up any existing index entries
    echo "🧹 Cleaning up Git index..."
    git rm --cached tsa-task-tracker-api 2>/dev/null || true
    git rm --cached tsa-task-tracker-frontend 2>/dev/null || true
    
    # Remove any existing empty directories
    if [ -d "tsa-task-tracker-api" ]; then
        echo "🗑️  Removing empty API directory..."
        rm -rf tsa-task-tracker-api
    fi
    
    if [ -d "tsa-task-tracker-frontend" ]; then
        echo "🗑️  Removing empty frontend directory..."
        rm -rf tsa-task-tracker-frontend
    fi
    
    # Remove existing .gitmodules if corrupted
    rm -f .gitmodules
    
    # Add proper submodules
    echo "📦 Adding API submodule..."
    git submodule add https://github.com/mastra90/tsa-task-tracker-api.git tsa-task-tracker-api
    
    echo "📦 Adding frontend submodule..."
    git submodule add https://github.com/mastra90/tsa-task-tracker-frontend.git tsa-task-tracker-frontend
    
    # Commit the submodule setup
    echo "💾 Committing submodule setup..."
    git add .gitmodules tsa-task-tracker-api tsa-task-tracker-frontend
    git commit -m "Add submodules for frontend and backend"
    
    echo "✅ Submodules set up properly!"
fi

# Check if submodules have content
if [ ! -f "tsa-task-tracker-frontend/package.json" ] || [ ! -f "tsa-task-tracker-api/package.json" ]; then
    echo "📦 Initializing submodules..."
    git submodule update --init --recursive
fi

# Update submodules to latest commits
echo "🔄 Updating submodules to latest versions..."
if git submodule update --remote --merge 2>/dev/null; then
    echo "✅ Submodules updated successfully!"
else
    echo "⚠️  Warning: Some submodule commits may not be available remotely"
    echo "   Falling back to existing commit references..."
    git submodule update --init --recursive
fi

# Ensure submodules are on master branch for development
echo "🔧 Setting up submodules for development..."
if [ -d "tsa-task-tracker-api" ]; then
    cd tsa-task-tracker-api
    git checkout master 2>/dev/null || git checkout main 2>/dev/null || echo "   → API: Using current branch"
    cd ..
fi

if [ -d "tsa-task-tracker-frontend" ]; then
    cd tsa-task-tracker-frontend  
    git checkout master 2>/dev/null || git checkout main 2>/dev/null || echo "   → Frontend: Using current branch"
    cd ..
fi

echo "✅ Submodules ready for development!"

# Check if there are submodule updates to commit
if ! git diff-index --quiet HEAD -- tsa-task-tracker-api tsa-task-tracker-frontend; then
    echo "💾 Committing submodule updates..."
    git add tsa-task-tracker-api tsa-task-tracker-frontend
    git commit -m "Update submodules to latest commits"
    echo "✅ Submodules updated to latest versions!"
else
    echo "✅ Submodules already at latest versions!"
fi

# Install dependencies for local development
echo "📚 Installing dependencies for IDE support..."

if [ -f "tsa-task-tracker-api/package.json" ]; then
    echo "   → Installing API dependencies..."
    cd tsa-task-tracker-api
    npm install --silent
    cd ..
    echo "   ✅ API dependencies installed"
else
    echo "   ⚠️  API package.json not found, skipping..."
fi

if [ -f "tsa-task-tracker-frontend/package.json" ]; then
    echo "   → Installing frontend dependencies..."
    cd tsa-task-tracker-frontend
    npm install --silent
    cd ..
    echo "   ✅ Frontend dependencies installed"
else
    echo "   ⚠️  Frontend package.json not found, skipping..."
fi

echo "✅ Local development environment ready for IDE!"

# Verify Dockerfiles exist
if [ ! -f "tsa-task-tracker-api/Dockerfile" ]; then
    echo "❌ Error: Dockerfile not found in tsa-task-tracker-api/"
    echo "Please ensure your API repository contains a Dockerfile"
    exit 1
fi

if [ ! -f "tsa-task-tracker-frontend/Dockerfile" ]; then
    echo "❌ Error: Dockerfile not found in tsa-task-tracker-frontend/"
    echo "Please ensure your frontend repository contains a Dockerfile"
    exit 1
fi

echo "🐳 Building and starting application..."
echo "   This may take a minute on first run..."

# Start Docker in detached mode (background) - suppress version warning
COMPOSE_API_VERSION=auto docker-compose up --build -d 2>/dev/null || docker-compose up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Check if services are running - suppress version warning
# if COMPOSE_API_VERSION=auto docker-compose ps 2>/dev/null | grep -q "Up" || docker-compose ps | grep -q "Up"; then

# Check if services are running
if docker compose ps --services --filter "status=running" | wc -l | grep -q -v "^0$"; then
    echo ""
    echo "🎉 Setup complete!"
    echo ""
    echo "🌐 Your application is now running:"
    echo "   → Frontend: http://localhost:5173"
    echo "   → Backend API: http://localhost:3000"
    echo ""
    echo "📋 Useful commands:"
    echo "   → View logs: docker-compose logs"
    echo "   → Stop app: docker-compose down"
    echo "   → Restart: docker-compose restart"
    echo "   → Open project in VS Code: code ."
    echo ""
    echo "Happy coding! 🚀"
else
    echo "❌ Something went wrong. Check logs with: docker-compose logs"
    exit 1
fi