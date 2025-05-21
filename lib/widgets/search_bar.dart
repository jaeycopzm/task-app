import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TaskSearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final bool isExpanded;
  final VoidCallback onTap;

  const TaskSearchBar({
    super.key,
    required this.onSearch,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? MediaQuery.of(context).size.width - 40 : 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: isExpanded
          ? TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onTap,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ).animate().fadeIn()
          : IconButton(
              icon: const Icon(Icons.search),
              onPressed: onTap,
            ),
    );
  }
}