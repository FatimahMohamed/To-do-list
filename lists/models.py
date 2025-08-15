from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class List(models.Model):
    title = models.CharField(max_length=200, unique=True)

    def __str__(self):
        return self.title

class Task(models.Model):
    title = models.CharField(max_length=200)
    list = models.ForeignKey(
        List, on_delete=models.CASCADE, related_name="task"
    )
    created_on = models.DateTimeField(auto_now_add=True)
    completed = models.BooleanField(default=False)

    def __str__(self):
        return self.title