import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager_app/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final List<Color> _categoryColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildCategoryList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              IconButton(
                onPressed: _showAddCategoryDialog,
                icon: const Icon(Icons.add_circle_outline),
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          Text(
            'Organize your tasks efficiently',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildCategoryList() {
    // Mock categories for demonstration
    final categories = [
      Category(id: 1, name: 'Work'),
      Category(id: 2, name: 'Personal'),
      Category(id: 3, name: 'Shopping'),
      Category(id: 4, name: 'Health'),
    ];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(category, index);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category, int index) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showCategoryTasks(category),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category.name),
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${index + 3} tasks', // Mock task count
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).scale(delay: (100 * index).ms);
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'work':
        return Icons.work_outline;
      case 'personal':
        return Icons.person_outline;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'health':
        return Icons.favorite_outline;
      default:
        return Icons.folder_open;
    }
  }

  void _showAddCategoryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildColorPicker(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 8,
      children: _categoryColors.map((color) {
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedColor == color
                    ? Colors.white
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: _selectedColor == color
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _saveCategory() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement category saving
      Navigator.pop(context);
      _categoryController.clear();
    }
  }

  void _showCategoryTasks(Category category) {
    // TODO: Navigate to filtered task list
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }
}