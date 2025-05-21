import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/screens/calendar_screen.dart';
import 'package:task_manager_app/screens/categories_screen.dart';
import 'package:task_manager_app/screens/profile_screen.dart';
import 'package:task_manager_app/screens/task_statistics_screen.dart';
import 'package:task_manager_app/widgets/animated_task_card.dart';
import 'package:task_manager_app/widgets/custom_bottom_nav.dart';
import 'package:task_manager_app/widgets/grouped_tasks_list.dart';
import 'package:task_manager_app/widgets/search_bar.dart';
import 'package:task_manager_app/widgets/task_card.dart';
import 'package:task_manager_app/widgets/task_filter_chip.dart';
import 'package:task_manager_app/widgets/task_progress_header.dart';
import 'package:task_manager_app/widgets/task_statistics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSearchExpanded = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Fetch tasks when screen loads
    Future.microtask(() => 
      context.read<TaskProvider>().fetchTasks()
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildTasksScreen(),
      const CalendarScreen(),
      const TaskStatisticsScreen(), // New analytics screen
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/task'),
        child: const Icon(Icons.add),
      ).animate().scale(delay: 400.ms),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildTasksScreen() {
    return Column(
      children: [
        // App Bar with search
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!_isSearchExpanded) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Tasks',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    Text(
                      'Let\'s be productive today!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ).animate().fadeIn().slideX(),
              ],
              TaskSearchBar(
                isExpanded: _isSearchExpanded,
                onSearch: _handleSearch,
                onTap: () => setState(() => _isSearchExpanded = !_isSearchExpanded),
              ),
            ],
          ),
        ),

        // Progress Header
        Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final totalTasks = taskProvider.tasks.length;
            final completedTasks = taskProvider.tasks
                .where((task) => task.status == 'completed')
                .length;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TaskProgressHeader(
                totalTasks: totalTasks,
                completedTasks: completedTasks,
                categories: [
                  TaskCategory(
                    name: 'Work',
                    icon: Icons.work_outline,
                    progress: 75,
                  ),
                  TaskCategory(
                    name: 'Personal',
                    icon: Icons.person_outline,
                    progress: 60,
                  ),
                  TaskCategory(
                    name: 'Shopping',
                    icon: Icons.shopping_bag_outlined,
                    progress: 45,
                  ),
                ],
              ),
            );
          },
        ).animate().fadeIn().slideY(begin: -0.2, end: 0),

        const SizedBox(height: 20),

        // Filter Chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              TaskFilterChip(
                label: 'All',
                isSelected: _selectedFilter == 'All',
                onTap: () => setState(() => _selectedFilter = 'All'),
              ),
              TaskFilterChip(
                label: 'Today',
                isSelected: _selectedFilter == 'Today',
                onTap: () => setState(() => _selectedFilter = 'Today'),
              ),
              TaskFilterChip(
                label: 'Upcoming',
                isSelected: _selectedFilter == 'Upcoming',
                onTap: () => setState(() => _selectedFilter = 'Upcoming'),
              ),
              TaskFilterChip(
                label: 'Completed',
                isSelected: _selectedFilter == 'Completed',
                onTap: () => setState(() => _selectedFilter = 'Completed'),
              ),
            ],
          ),
        ).animate().fadeIn().slideX(),

        // Grouped Tasks List
        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final filteredTasks = _filterTasks(taskProvider.tasks);
              
              if (filteredTasks.isEmpty) {
                return _buildEmptyState();
              }

              return GroupedTasksList(
                tasks: filteredTasks, onTaskCompleted: (task) {  },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No tasks match your search'
                : 'No tasks found for this filter',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  List<Task> _filterTasks(List<Task> tasks) {
    return tasks.where((task) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!task.title.toLowerCase().contains(query) &&
            !(task.description?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      // Apply category filter
      switch (_selectedFilter) {
        case 'Today':
          return task.dueDate != null &&
              DateTime.now().difference(task.dueDate!).inDays == 0;
        case 'Upcoming':
          return task.dueDate != null &&
              task.dueDate!.isAfter(DateTime.now());
        case 'Completed':
          return task.status == 'completed';
        default:
          return true;
      }
    }).toList();
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query);
  }
}