# 🚀 Heroku Deployment Guide - Django Todo App

## Prerequisites
- ✅ Git installed and repository initialized
- ✅ Heroku CLI installed ([Download here](https://devcenter.heroku.com/articles/heroku-cli))
- ✅ Heroku account created

## 📁 Deployment Files Ready
- ✅ `Procfile` - Heroku process configuration
- ✅ `requirements.txt` - Python dependencies
- ✅ `runtime.txt` - Python version specification
- ✅ `deploy_heroku.sh` - Unix deployment script
- ✅ `deploy_heroku.bat` - Windows deployment script

## 🔧 Manual Deployment Steps

### 1. Login to Heroku
```bash
heroku login
```

### 2. Create Heroku App
```bash
# Auto-generated name
heroku create

# Or with custom name
heroku create your-todo-app-name
```

### 3. Set Environment Variables
```bash
heroku config:set SECRET_KEY="your-secret-key-here"
heroku config:set DEBUG="False"
heroku config:set DATABASE_URL="your-postgresql-connection-string"
```

**⚠️ SECURITY NOTE**: Replace with your actual values:
- `SECRET_KEY`: Generate a new Django secret key 
- `DATABASE_URL`: Your PostgreSQL connection string from your database provider

### 4. Deploy Application
```bash
git add .
git commit -m "Deploy Django Todo App to Heroku"
git push heroku main
```

### 5. Database Setup (Automatic via Procfile)
The release phase in Procfile automatically runs:
- `python manage.py migrate`
- `python manage.py collectstatic --noinput`

### 6. Create Superuser (Optional)
```bash
heroku run python manage.py createsuperuser
```

## 🎯 Quick Deployment (Use Scripts)

### For Windows:
```cmd
deploy_heroku.bat
```

### For Unix/Mac/Git Bash:
```bash
chmod +x deploy_heroku.sh
./deploy_heroku.sh
```

## 🌐 Application URLs
After deployment, your app will be available at:
- **Landing Page**: `https://your-app.herokuapp.com/`
- **Registration**: `https://your-app.herokuapp.com/accounts/signup/`
- **Login**: `https://your-app.herokuapp.com/accounts/login/`
- **Dashboard**: `https://your-app.herokuapp.com/dashboard/`
- **Account**: `https://your-app.herokuapp.com/account/`
- **Admin**: `https://your-app.herokuapp.com/admin/`

## 🔍 Monitoring & Debugging

### View Logs
```bash
heroku logs --tail
```

### Access Django Shell
```bash
heroku run python manage.py shell
```

### Restart Application
```bash
heroku restart
```

### Check Configuration
```bash
heroku config
```

## 📊 Database Management

### Run Migrations
```bash
heroku run python manage.py migrate
```

### Database Shell
```bash
heroku run python manage.py dbshell
```

### Reset Database (⚠️ Destructive)
```bash
heroku pg:reset DATABASE_URL --confirm your-app-name
heroku run python manage.py migrate
heroku run python manage.py createsuperuser
```

## 🔧 Configuration Details

### Environment Variables
- `SECRET_KEY`: Django secret key for security (generate a new one)
- `DEBUG`: Set to "False" for production
- `DATABASE_URL`: PostgreSQL connection string (keep private)

**🔒 Security Best Practices:**
- Never commit database credentials to git
- Generate unique secret keys for each environment
- Use environment variables for sensitive data
- Rotate credentials regularly

### Static Files
- Handled by WhiteNoise middleware
- Collected automatically during release phase
- Compressed for optimal performance

### Database
- PostgreSQL (Neon) for production
- Automatic migrations on deployment
- Connection pooling enabled

## 🚨 Troubleshooting

### Common Issues & Solutions

1. **Application Error (500)**
   ```bash
   heroku logs --tail
   # Check for missing environment variables or database connection issues
   ```

2. **Static Files Not Loading**
   ```bash
   heroku run python manage.py collectstatic --noinput
   ```

3. **Database Connection Issues**
   ```bash
   heroku config:get DATABASE_URL
   # Verify database URL is correct
   ```

4. **Module Not Found Error**
   ```bash
   # Check requirements.txt has all dependencies
   pip freeze > requirements.txt
   git add requirements.txt
   git commit -m "Update requirements"
   git push heroku main
   ```

## 📱 Testing Deployment

1. **Landing Page**: Verify features and styling load correctly
2. **Registration**: Create a test user account
3. **Login**: Test authentication flow
4. **Dashboard**: Create, edit, delete tasks
5. **Admin**: Access admin interface with superuser
6. **Mobile**: Test responsive design on mobile devices

## 🔄 Updating Deployment

For future updates:
```bash
git add .
git commit -m "Your update message"
git push heroku main
```

The release phase will automatically handle migrations and static files.

## 🎉 Success!

Your Django Todo App is now live on Heroku with:
- ✅ User authentication (registration/login)
- ✅ Task management (CRUD operations)
- ✅ Responsive design
- ✅ PostgreSQL database
- ✅ Secure configuration
- ✅ Admin interface
- ✅ Production-ready settings
