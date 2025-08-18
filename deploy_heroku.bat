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
heroku config:set SECRET_KEY="+nea@5GP2&Z}&5_m{d$d+ds^b&kL?~"
heroku config:set DEBUG="False"
heroku config:set DATABASE_URL="postgresql://neondb_owner:npg_CINqkDu9GT3v@ep-fragrant-tree-a2jmd0h2.eu-central-1.aws.neon.tech/roast_dodge_robe_520026"

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
