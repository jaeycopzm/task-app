import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: HugeIcons.strokeRoundedHome01,
                activeIcon: HugeIcons.strokeRoundedHome01,
                label: 'Tasks',
                index: 0,
              ),
              _buildNavItem(
                context,
                icon: HugeIcons.strokeRoundedCalendar01,
                activeIcon: HugeIcons.strokeRoundedCalendar01,
                label: 'Calendar',
                index: 1,
              ),
              _buildFabPlaceholder(),
              _buildNavItem(
                context,
                icon: HugeIcons.strokeRoundedChart01,
                activeIcon: HugeIcons.strokeRoundedChart01,
                label: 'Analytics',
                index: 2,
              ),
              _buildNavItem(
                context,
                icon: HugeIcons.strokeRoundedProfile,
                activeIcon: HugeIcons.strokeRoundedProfile,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.64);

    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: color,
                size: 20,
              ),
            ).animate(target: isSelected ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 200.ms)
              .fadeIn(duration: 200.ms),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabPlaceholder() {
    return const SizedBox(width: 70);
  }
}