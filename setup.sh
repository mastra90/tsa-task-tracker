#!/bin/bash

echo "🚀 Setting up TSA Task Tracker..."

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

# Start Docker in detached mode (background)
docker-compose up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose ps | grep -q "Up"; then
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
    echo ""
    echo "Happy coding! 🚀"
else
    echo "❌ Something went wrong. Check logs with: docker-compose logs"
    exit 1
fi