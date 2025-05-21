import 'package:flutter/foundation.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Task> _tasks = [];
  bool _isLoading = false;

  TaskProvider(this._apiService);

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _apiService.getTasks();
    } catch (e) {
      // Handle error
      print('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    try {
      final task = await _apiService.createTask(taskData);
      _tasks = [..._tasks, task];
      notifyListeners();
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(int taskId, Map<String, dynamic> taskData) async {
    try {
      final updatedTask = await _apiService.updateTask(taskId, taskData);
      _tasks = _tasks.map((task) => 
        task.id == taskId ? updatedTask : task
      ).toList();
      notifyListeners();
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTaskOptimistic(int taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final deletedTask = _tasks[taskIndex];
    _tasks.removeAt(taskIndex);
    notifyListeners();

    try {
      await _apiService.deleteTask(taskId);
    } catch (e) {
      // Revert on error
      _tasks.insert(taskIndex, deletedTask);
      notifyListeners();
      rethrow;
    }
  }

  void reorderTask(Task task, Task targetTask) {
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    final targetIndex = _tasks.indexWhere((t) => t.id == targetTask.id);
    
    if (taskIndex == -1 || targetIndex == -1) return;

    final movedTask = _tasks.removeAt(taskIndex);
    _tasks.insert(targetIndex, movedTask);
    notifyListeners();
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _apiService.deleteTask(taskId);
      _tasks = _tasks.where((task) => task.id != taskId).toList();
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  Future<void> updateTaskStatus(int taskId, String status) async {
    try {
      // Find task index
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return;

      // Create updated task
      final updatedTask = Task(
        id: _tasks[taskIndex].id,
        title: _tasks[taskIndex].title,
        description: _tasks[taskIndex].description,
        status: status,
        priority: _tasks[taskIndex].priority,
        dueDate: _tasks[taskIndex].dueDate,
        ownerId: _tasks[taskIndex].ownerId,
        isRecurring: _tasks[taskIndex].isRecurring,
        categories: _tasks[taskIndex].categories,
        subtasks: _tasks[taskIndex].subtasks,
      );

      // Update locally first for immediate UI feedback
      _tasks[taskIndex] = updatedTask;
      notifyListeners();

      // Update on server
      await _apiService.updateTask(taskId, {'status': status});
    } catch (e) {
      // Handle error and revert changes if needed
      print('Error updating task status: $e');
      await fetchTasks(); // Refresh from server
    }
  }
}