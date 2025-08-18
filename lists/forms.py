from .models import List
from .models import Task
from django import forms

class ListForm(forms.ModelForm):
    class Meta:
        model = List
        fields = ("title",)

class TaskForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = ("title","completed",)