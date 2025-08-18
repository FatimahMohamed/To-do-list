release: python manage.py migrate && python manage.py collectstatic --noinput
web: gunicorn to_do_list.wsgi
