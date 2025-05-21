import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
            colors: [
              const Color(0xFF6448FE).withOpacity(0.2),
              const Color(0xFF5FC6FF).withOpacity(0.2),
              const Color(0xFF6448FE).withOpacity(0.1),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background design elements
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5FC6FF).withOpacity(0.2),
                      const Color(0xFF6448FE).withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6448FE).withOpacity(0.2),
                      const Color(0xFF5FC6FF).withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 80,
                            color: Theme.of(context).primaryColor,
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 200.ms),
                          const SizedBox(height: 24),
                          Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 8),
                          Text(
                            'Sign up to start managing your tasks',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0, delay: 200.ms),
                          const SizedBox(height: 48),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: const Icon(Icons.person_outline),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter a username';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter a password';
                                      }
                                      if (value!.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0, delay: 400.ms),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF6448FE),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0, delay: 600.ms),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0, delay: 800.ms),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final success = await context.read<AuthProvider>().register(
          _usernameController.text,
          _passwordController.text,
        );

        if (success && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}