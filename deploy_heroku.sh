#!/bin/bash

# Django Todo App - Heroku Deployment Script

echo "🚀 Preparing Django Todo App for Heroku Deployment"
echo "=================================================="

# Check if Heroku CLI is installed
if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI not found. Please install it first:"
    echo "   https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Check if user is logged in to Heroku
if ! heroku auth:whoami &> /dev/null; then
    echo "🔑 Please log in to Heroku:"
    heroku login
fi

echo ""
echo "📝 Step 1: Creating Heroku app..."
echo "Enter your app name (or press Enter for auto-generated name):"
read -r APP_NAME

if [ -z "$APP_NAME" ]; then
    echo "Creating app with auto-generated name..."
    heroku create
else
    echo "Creating app with name: $APP_NAME"
    heroku create "$APP_NAME"
fi

# Get the app name from git remote
APP_NAME=$(heroku apps:info --json | python -c "import sys, json; print(json.load(sys.stdin)['name'])" 2>/dev/null || echo "your-app-name")

echo ""
echo "🔧 Step 2: Setting environment variables..."

# Set environment variables
echo "⚠️  IMPORTANT: You need to set these environment variables manually:"
echo "   heroku config:set SECRET_KEY=\"your-secret-key\""
echo "   heroku config:set DEBUG=\"False\""
echo "   heroku config:set DATABASE_URL=\"your-postgresql-url\""
echo ""
echo "📋 Enter your SECRET_KEY:"
read -r SECRET_KEY
echo "📋 Enter your DATABASE_URL:"
read -r DATABASE_URL

heroku config:set SECRET_KEY="$SECRET_KEY"
heroku config:set DEBUG="False"
heroku config:set DATABASE_URL="$DATABASE_URL"

echo ""
echo "📦 Step 3: Deploying to Heroku..."

# Add files to git
git add .
git status

echo ""
echo "💬 Enter commit message (or press Enter for default):"
read -r COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Deploy Django Todo App to Heroku"
fi

git commit -m "$COMMIT_MSG"

# Deploy to Heroku
echo ""
echo "🚀 Pushing to Heroku..."
git push heroku main

echo ""
echo "🗄️ Step 4: Running migrations on Heroku..."
heroku run python manage.py migrate

echo ""
echo "👤 Step 5: Creating superuser (optional)..."
echo "Do you want to create a superuser? (y/n):"
read -r CREATE_SUPERUSER

if [ "$CREATE_SUPERUSER" = "y" ] || [ "$CREATE_SUPERUSER" = "Y" ]; then
    heroku run python manage.py createsuperuser
fi

echo ""
echo "✅ Deployment Complete!"
echo "======================="
echo ""
echo "🌐 Your app is available at:"
heroku apps:info --json | python -c "import sys, json; print(json.load(sys.stdin)['web_url'])" 2>/dev/null || echo "https://$APP_NAME.herokuapp.com/"
echo ""
echo "🔗 Useful commands:"
echo "   heroku logs --tail                    # View logs"
echo "   heroku run python manage.py shell    # Django shell"
echo "   heroku restart                       # Restart app"
echo "   heroku config                        # View environment variables"
echo ""
echo "📱 App URLs:"
echo "   /                    → Landing page"
echo "   /accounts/signup/    → User registration"
echo "   /accounts/login/     → User login"
echo "   /dashboard/          → Task dashboard"
echo "   /account/            → User account"
echo "   /admin/              → Django admin"
