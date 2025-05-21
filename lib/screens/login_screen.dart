import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check auth status and redirect if needed
    Future.microtask(() {
      if (context.read<AuthProvider>().isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define attractive gradient colors
    final gradientColors = [
      const Color(0xFF6448FE).withOpacity(0.2), // Purple
      const Color(0xFF5FC6FF).withOpacity(0.2), // Blue
      const Color(0xFF6448FE).withOpacity(0.1), // Purple
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // Updated background design elements
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
            // Main content
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
                          const SizedBox(height: 60),
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: Theme.of(context).primaryColor,
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 200.ms),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome Back',
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
                            'Login to continue managing your tasks',
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
                                        return 'Please enter your username';
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
                                        return 'Please enter your password';
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
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0, delay: 600.ms),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              'Don\'t have an account? Register',
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

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        final success = await context.read<AuthProvider>().login(
          _usernameController.text,
          _passwordController.text,
        );

        if (success && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed')),
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
    super.dispose();
  }
}