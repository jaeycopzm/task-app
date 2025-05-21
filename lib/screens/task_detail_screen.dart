import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task? task;

  const TaskDetailScreen({super.key, this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  int _priority = 2;
  bool _isRecurring = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController = TextEditingController(text: widget.task?.description);
    _selectedDate = widget.task?.dueDate;
    _priority = widget.task?.priority ?? 2;
    _isRecurring = widget.task?.isRecurring ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveTask,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task == null ? 'New Task' : 'Edit Task',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ).animate().fadeIn().slideX(),

                const SizedBox(height: 24),

                // Title Field
                _buildTextField(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Enter task title',
                ).animate().fadeIn(delay: 100.ms).slideX(),

                const SizedBox(height: 16),

                // Description Field
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter task description',
                  maxLines: 3,
                ).animate().fadeIn(delay: 200.ms).slideX(),

                const SizedBox(height: 24),

                // Priority Selection
                _buildPrioritySelector()
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideX(),

                const SizedBox(height: 24),

                // Due Date Picker
                _buildDatePicker()
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideX(),

                const SizedBox(height: 24),

                // Recurring Toggle
                _buildRecurringToggle()
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideX(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return '$label is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPriorityChip(3, 'Low', Colors.green),
            const SizedBox(width: 8),
            _buildPriorityChip(2, 'Medium', Colors.orange),
            const SizedBox(width: 8),
            _buildPriorityChip(1, 'High', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(int priority, String label, Color color) {
    return ChoiceChip(
      label: Text(label),
      selected: _priority == priority,
      onSelected: (bool selected) {
        if (selected) {
          setState(() => _priority = priority);
        }
      },
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: _priority == priority ? color : Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showDatePicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedDate == null
                      ? 'Select due date'
                      : DateFormat('MMM d, y').format(_selectedDate!),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringToggle() {
    return SwitchListTile(
      title: const Text(
        'Recurring Task',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: const Text('Task repeats on a schedule'),
      value: _isRecurring,
      onChanged: (bool value) {
        setState(() => _isRecurring = value);
      },
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final taskData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'due_date': _selectedDate?.toIso8601String(),
        'priority': _priority,
        'is_recurring': _isRecurring,
      };

      try {
        if (widget.task != null) {
          context.read<TaskProvider>().updateTask(widget.task!.id, taskData);
        } else {
          context.read<TaskProvider>().createTask(taskData);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}