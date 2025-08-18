@echo off
echo 🚀 Django Todo App - Heroku Deployment
echo =====================================
echo.

:: Check if Heroku CLI is available
heroku --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Heroku CLI not found. Please install it first:
    echo    https://devcenter.heroku.com/articles/heroku-cli
    pause
    exit /b 1
)

echo 📝 Step 1: Creating Heroku app...
set /p APP_NAME="Enter your app name (or press Enter for auto-generated): "

if "%APP_NAME%"=="" (
    echo Creating app with auto-generated name...
    heroku create
) else (
    echo Creating app with name: %APP_NAME%
    heroku create %APP_NAME%
)

echo.
echo 🔧 Step 2: Setting environment variables...
echo.
echo ⚠️  IMPORTANT: You need to set these environment variables manually:
echo    heroku config:set SECRET_KEY="your-secret-key"
echo    heroku config:set DEBUG="False"  
echo    heroku config:set DATABASE_URL="your-postgresql-url"
echo.
set /p SECRET_KEY="📋 Enter your SECRET_KEY: "
set /p DATABASE_URL="📋 Enter your DATABASE_URL: "

heroku config:set SECRET_KEY="%SECRET_KEY%"
heroku config:set DEBUG="False"
heroku config:set DATABASE_URL="%DATABASE_URL%"

echo.
echo 📦 Step 3: Deploying to Heroku...
git add .
set /p COMMIT_MSG="Enter commit message (or press Enter for default): "

if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG="Deploy Django Todo App to Heroku"
)

git commit -m "%COMMIT_MSG%"
git push heroku main

echo.
echo 🗄️ Step 4: Running migrations...
heroku run python manage.py migrate

echo.
echo ✅ Deployment Complete!
echo =====================
echo.
echo 🌐 Your app should be available at your Heroku app URL
echo.
echo 🔗 Useful commands:
echo    heroku logs --tail
echo    heroku run python manage.py createsuperuser
echo    heroku restart
echo.
pause
