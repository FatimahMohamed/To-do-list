from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib import messages
from .models import Task, List
import json

def index(request):
    """Landing page view"""
    try:
        return render(request, 'index.html')
    except Exception as e:
        print(f"Error in index view: {e}")
        from django.http import HttpResponse
        return HttpResponse(f"Error: {e}", status=500)

@login_required
def dashboard(request):
    """Dashboard view for authenticated users"""
    try:
        # Get or create a default list for the user
        user_list, created = List.objects.get_or_create(
            author=request.user,
            title=f"{request.user.username}'s Tasks"
        )
        
        # Get all tasks for the user
        tasks = Task.objects.filter(author=request.user).order_by('-created_on')
        
        # Calculate statistics
        total_tasks = tasks.count()
        completed_tasks = tasks.filter(completed=True).count()
        remaining_tasks = total_tasks - completed_tasks
        
        context = {
            'tasks': tasks,
            'total_tasks': total_tasks,
            'completed_tasks': completed_tasks,
            'remaining_tasks': remaining_tasks,
        }
        
        return render(request, 'dashboard.html', context)
    except Exception as e:
        print(f"Error in dashboard view: {e}")
        from django.http import HttpResponse
        return HttpResponse(f"Dashboard Error: {e}", status=500)

@login_required
def account(request):
    """Account page view"""
    tasks = Task.objects.filter(author=request.user)
    total_tasks = tasks.count()
    completed_tasks = tasks.filter(completed=True).count()
    pending_tasks = tasks.filter(completed=False).count()
    
    context = {
        'total_tasks': total_tasks,
        'completed_tasks': completed_tasks,
        'pending_tasks': pending_tasks,
    }
    
    return render(request, 'account.html', context)

@login_required
def add_task(request):
    """Add a new task"""
    if request.method == 'POST':
        task_title = request.POST.get('task_title')
        if task_title:
            # Get or create a default list for the user
            user_list, created = List.objects.get_or_create(
                author=request.user,
                title=f"{request.user.username}'s Tasks"
            )
            
            # Create the task
            Task.objects.create(
                title=task_title,
                list=user_list,
                author=request.user
            )
            messages.success(request, 'Task added successfully!')
        else:
            messages.error(request, 'Task title cannot be empty.')
    
    return redirect('dashboard')

@login_required
def toggle_task(request, task_id):
    """Toggle task completion status"""
    if request.method == 'POST':
        task = get_object_or_404(Task, id=task_id, author=request.user)
        data = json.loads(request.body)
        task.completed = data.get('completed', False)
        task.save()
        return JsonResponse({'success': True})
    return JsonResponse({'success': False})

@login_required
def edit_task(request, task_id):
    """Edit task title"""
    if request.method == 'POST':
        task = get_object_or_404(Task, id=task_id, author=request.user)
        data = json.loads(request.body)
        new_title = data.get('title', '').strip()
        if new_title:
            task.title = new_title
            task.save()
            return JsonResponse({'success': True})
    return JsonResponse({'success': False})

@login_required
def delete_task(request, task_id):
    """Delete a task"""
    if request.method == 'DELETE':
        task = get_object_or_404(Task, id=task_id, author=request.user)
        task.delete()
        return JsonResponse({'success': True})
    return JsonResponse({'success': False})
