import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/task_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom App Bar
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                'View and manage your schedule',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

        // Calendar Widget
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              formatButtonTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms),

        // Tasks for Selected Day
        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final tasksForDay = taskProvider.tasks.where((task) {
                return task.dueDate != null &&
                    isSameDay(task.dueDate!, _selectedDay ?? _focusedDay);
              }).toList();

              if (tasksForDay.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks for this day',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: tasksForDay.length,
                itemBuilder: (context, index) {
                  return TaskCard(task: tasksForDay[index])
                      .animate()
                      .fadeIn(delay: (100 * index).ms)
                      .slideX();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}