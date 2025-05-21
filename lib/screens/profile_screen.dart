import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildSettingsSection(context),
          _buildStatisticsSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ).animate().scale(),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ).animate().fadeIn().slideY(begin: 0.3, end: 0),
          Text(
            'john.doe@example.com',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildSettingTile(
          context,
          title: 'Notifications',
          icon: Icons.notifications_outlined,
          trailing: Switch(
            value: true,
            onChanged: (value) {},
          ),
        ),
        _buildSettingTile(
          context,
          title: 'Dark Mode',
          icon: Icons.dark_mode_outlined,
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
        ),
        _buildSettingTile(
          context,
          title: 'Language',
          icon: Icons.language_outlined,
          trailing: const Text('English'),
          onTap: () {},
        ),
      ].animate(interval: 100.ms).fadeIn().slideX(),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildStatCard(
                context,
                '12',
                'Tasks\nCompleted',
                Colors.green,
                Icons.check_circle_outline,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                '5',
                'Tasks\nPending',
                Colors.orange,
                Icons.pending_outlined,
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}