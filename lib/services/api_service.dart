import 'package:dio/dio.dart';
import 'package:task_manager_app/config/api_config.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/models/category.dart';
import 'package:task_manager_app/models/user.dart';

class ApiService {
  final Dio _dio = Dio();
  String? _authToken;

  // Mock data for development
  final List<Task> _mockTasks = [
    Task(
      id: 1,
      title: 'Complete UI Design',
      description: 'Finish the task manager app UI design',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: 2,
      status: 'in_progress',
      ownerId: 1,
      isRecurring: false,
      categories: [Category(id: 1, name: 'Work')],
      subtasks: [],
    ),
    Task(
      id: 2,
      title: 'Weekly Planning',
      description: 'Plan next week\'s tasks',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 1,
      status: 'pending',
      ownerId: 1,
      isRecurring: true,
      recurrenceInterval: 'weekly',
      categories: [Category(id: 2, name: 'Personal')],
      subtasks: [],
    ),
  ];

  // Mock categories
  final List<Category> _mockCategories = [
    Category(id: 1, name: 'Work'),
    Category(id: 2, name: 'Personal'),
    Category(id: 3, name: 'Shopping'),
    Category(id: 4, name: 'Health'),
  ];

  ApiService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    
    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        return handler.next(options);
      },
    ));
  }

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Auth endpoints
  Future<String?> loginUser(String username, String password) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      final response = await _dio.post(
        '/login',
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        setAuthToken(token);
        return token;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
    return null;
  }

  Future<User> registerUser(String username, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'username': username,
        'password': password,
      });
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Task endpoints
  Future<List<Task>> getTasks({
    String? status,
    DateTime? dueDate,
    int? priority,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    return _mockTasks;
  }

  Future<Task> createTask(Map<String, dynamic> taskData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTasks.first;
  }

  Future<Task> updateTask(int taskId, Map<String, dynamic> taskData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTasks.first;
  }

  Future<void> deleteTask(int taskId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Category endpoints
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCategories;
  }

  Future<Category> createCategory(String name) async {
    try {
      final response = await _dio.post('/categories', data: {'name': name});
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Subtask endpoints
  Future<void> createSubtask(int taskId, Map<String, dynamic> subtaskData) async {
    try {
      await _dio.post('/tasks/$taskId/subtasks', data: subtaskData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateSubtask(
    int taskId,
    int subtaskId,
    Map<String, dynamic> subtaskData,
  ) async {
    try {
      await _dio.put('/tasks/$taskId/subtasks/$subtaskId', data: subtaskData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Helper method to handle Dio errors
  Exception _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return UnauthorizedException(e.response?.data?['detail'] ?? 'Unauthorized');
    } else if (e.response?.statusCode == 400) {
      return ValidationException(e.response?.data?['detail'] ?? 'Validation error');
    } else {
      return ApiException(e.message ?? 'Unknown error occurred');
    }
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ValidationException extends ApiException {
  ValidationException(super.message);
}