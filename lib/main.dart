import 'dart:math';
import 'package:flutter/material.dart';

String generateStrongPassword() {
  const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const digits = '0123456789';
  const symbols = '!@#\u0024%^&*()-_=+[]{}<>?';
  const all = letters + digits + symbols;
  final random = Random.secure();

  final buffer = StringBuffer();
  buffer.write(letters[random.nextInt(letters.length)]);
  buffer.write(digits[random.nextInt(digits.length)]);
  buffer.write(symbols[random.nextInt(symbols.length)]);
  for (var i = 3; i < 12; i++) {
    buffer.write(all[random.nextInt(all.length)]);
  }

  final passwordChars = buffer.toString().split('')..shuffle(random);
  return passwordChars.join();
}

class RegisteredUser {
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;

  RegisteredUser({
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
  });
}

final List<RegisteredUser> registeredUsers = [];

String normalizeLogin(String value) => value.trim().toLowerCase();

RegisteredUser? findRegisteredUser(String login) {
  final normalizedLogin = normalizeLogin(login);
  for (final user in registeredUsers) {
    if (normalizeLogin(user.email) == normalizedLogin ||
        normalizeLogin(user.username) == normalizedLogin) {
      return user;
    }
  }
  return null;
}

void main() {
  runApp(const MarketLinkageApp());
}

class MarketLinkageApp extends StatelessWidget {
  const MarketLinkageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null, backgroundColor: Colors.teal),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              'Market Linkage',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Connecting Farmers & Buyers',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            const Text(
              'Select Your Role',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FarmerRoleAuthPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'FARMER / CO-OPERATIVE UNION',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuyerRoleAuthPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 15,
                ),
              ),
              child: const Text('BUYER', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmerRoleAuthPage extends StatelessWidget {
  const FarmerRoleAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null, backgroundColor: Colors.green),
      body: const FarmerLoginPage(),
    );
  }
}

class FarmerLoginPage extends StatefulWidget {
  const FarmerLoginPage({super.key});

  @override
  State<FarmerLoginPage> createState() => _FarmerLoginPageState();
}

class _FarmerLoginPageState extends State<FarmerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final login = _emailOrUsernameController.text.trim();
      final password = _passwordController.text;
      final user = findRegisteredUser(login);

      if (user == null || user.role != 'Farmer' || user.password != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No farmer account found for those credentials'),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerDashboard(
            name: '${user.firstName} ${user.lastName}',
            farmerType: 'Farmer',
            location: 'N/A',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.shade900,
                  Colors.green.shade800,
                  Colors.green.shade400,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 88),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'log in',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      Text(
                        'welcome back',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailOrUsernameController,
                      decoration: const InputDecoration(
                        labelText: 'Email or Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter email or username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not registered yet?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FarmerRegisterPage(),
                              ),
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FarmerRegisterPage extends StatefulWidget {
  const FarmerRegisterPage({super.key});

  @override
  State<FarmerRegisterPage> createState() => _FarmerRegisterPageState();
}

class _FarmerRegisterPageState extends State<FarmerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  late String _suggestedPassword;

  @override
  void initState() {
    super.initState();
    _suggestedPassword = generateStrongPassword();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isPasswordStrong(String value) {
    return value.length >= 8 &&
        RegExp(r'(?=.*[a-zA-Z])').hasMatch(value) &&
        RegExp(r'(?=.*\d)').hasMatch(value) &&
        RegExp(r'(?=.*[!@#\u0024%^&*])').hasMatch(value);
  }

  void _generateNewPassword() {
    setState(() {
      _suggestedPassword = generateStrongPassword();
    });
  }

  void _useSuggestedPassword() {
    _passwordController.text = _suggestedPassword;
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      if (registeredUsers.any(
        (user) =>
            normalizeLogin(user.email) == normalizeLogin(email) ||
            normalizeLogin(user.username) == normalizeLogin(username),
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email or username already registered')),
        );
        return;
      }

      registeredUsers.add(
        RegisteredUser(
          role: 'Farmer',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: email,
          username: username,
          password: password,
        ),
      );

      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerDashboard(
            name: fullName,
            farmerType: 'Farmer',
            location: 'N/A',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null, backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green.shade900,
                    Colors.green.shade800,
                    Colors.green.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 88),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'sign up',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          'create your farmer account',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter first name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter last name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please choose a username'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          helperText: 'Use letters, numbers, and symbols',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (!_isPasswordStrong(value)) {
                            return 'Password must be at least 8 chars with letters, numbers, and symbols';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Suggested strong password: $_suggestedPassword',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: _useSuggestedPassword,
                            child: const Text('Use suggested password'),
                          ),
                          TextButton(
                            onPressed: _generateNewPassword,
                            child: const Text('Generate another'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Back to login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmerLoginTab extends StatefulWidget {
  final TabController tabController;

  const FarmerLoginTab({super.key, required this.tabController});

  @override
  State<FarmerLoginTab> createState() => _FarmerLoginTabState();
}

class _FarmerLoginTabState extends State<FarmerLoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _passwordVisible = false;
  String _farmerType = 'Individual Farmer';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerDashboard(
            name: _nameController.text.trim(),
            farmerType: _farmerType,
            location: _locationController.text.trim(),
          ),
        ),
      );
    }
  }

  void _googleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google sign-in would work here!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Farmer Login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _farmerType,
              decoration: const InputDecoration(
                labelText: 'Farmer Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Individual Farmer',
                  child: Text('Individual Farmer'),
                ),
                DropdownMenuItem(
                  value: 'Co-operative Union',
                  child: Text('Co-operative Union'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _farmerType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your location'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Login', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _googleSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmerSignUpTab extends StatefulWidget {
  final TabController tabController;

  const FarmerSignUpTab({super.key, required this.tabController});

  @override
  State<FarmerSignUpTab> createState() => _FarmerSignUpTabState();
}

class _FarmerSignUpTabState extends State<FarmerSignUpTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _passwordVisible = false;
  String _farmerType = 'Individual Farmer';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerDashboard(
            name: _nameController.text.trim(),
            farmerType: _farmerType,
            location: _locationController.text.trim(),
          ),
        ),
      );
    }
  }

  void _googleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google sign-up would work here!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Farmer Sign Up',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                  return 'Password must start with a capital letter';
                }
                if (!RegExp(
                  r'(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])',
                ).hasMatch(value)) {
                  return 'Password must contain letters, numbers, and symbols';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _farmerType,
              decoration: const InputDecoration(
                labelText: 'Farmer Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Individual Farmer',
                  child: Text('Individual Farmer'),
                ),
                DropdownMenuItem(
                  value: 'Co-operative Union',
                  child: Text('Co-operative Union'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _farmerType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your location'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Sign Up', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _googleSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign up with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductPost {
  final String title;
  final String category;
  final String description;
  final String quantity;
  final String timeToWarehouse;
  final String warehouseLocation;
  final String phoneNumber;
  final String? imageLabel;

  ProductPost({
    required this.title,
    required this.category,
    required this.description,
    required this.quantity,
    required this.timeToWarehouse,
    required this.warehouseLocation,
    required this.phoneNumber,
    this.imageLabel,
  });
}

class Order {
  final String buyerName;
  final String productName;
  final String quantity;
  final String status;
  final String orderDate;
  final String totalPrice;
  final String? buyerPhoto;
  final String? rejectionReason;

  Order({
    required this.buyerName,
    required this.productName,
    required this.quantity,
    required this.status,
    required this.orderDate,
    required this.totalPrice,
    this.buyerPhoto,
    this.rejectionReason,
  });
}

class ChatMessage {
  final String sender;
  final String message;
  final String timestamp;
  final bool isFromFarmer;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isFromFarmer,
  });
}

class AIMedicalAdvice {
  final String topic;
  final String advice;
  final String category;

  AIMedicalAdvice({
    required this.topic,
    required this.advice,
    required this.category,
  });
}

class Buyer {
  final String name;
  final String photoUrl;
  final String status;

  Buyer({
    required this.name,
    required this.photoUrl,
    required this.status,
  });
}

class FeedbackEntry {
  final String buyerName;
  final String message;
  final int rating;
  final String date;

  FeedbackEntry({
    required this.buyerName,
    required this.message,
    required this.rating,
    required this.date,
  });
}

class Delivery {
  final String buyerName;
  final String productName;
  final String quantity;
  final String deliveryLocation;
  final String status;
  final String orderDate;

  Delivery({
    required this.buyerName,
    required this.productName,
    required this.quantity,
    required this.deliveryLocation,
    required this.status,
    required this.orderDate,
  });
}

class FarmerDashboard extends StatefulWidget {
  final String name;
  final String farmerType;
  final String location;

  const FarmerDashboard({
    super.key,
    required this.name,
    required this.farmerType,
    required this.location,
  });

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _timeController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _phoneController = TextEditingController();
  String _category = 'Food';
  String? _selectedImageLabel;
  final List<ProductPost> _posts = [];
  final List<Order> _orders = [];
  final List<FeedbackEntry> _feedbacks = [];
  final List<Delivery> _deliveries = [];
  final List<Buyer> _buyers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // sample data
    _orders.addAll([
      Order(
        buyerName: 'John Traders',
        productName: 'Maize',
        quantity: '100 bags',
        status: 'Pending',
        orderDate: '2024-05-18',
        totalPrice: '\$500',
        buyerPhoto: 'https://via.placeholder.com/50/FF6B6B/FFFFFF?text=JT',
      ),
    ]);

    _feedbacks.addAll([
      FeedbackEntry(buyerName: 'John Traders', message: 'Great produce', rating: 5, date: '2024-05-15'),
    ]);

    _deliveries.addAll([
      Delivery(
        buyerName: 'Fresh Foods Ltd',
        productName: 'Beans',
        quantity: '30 bags',
        deliveryLocation: 'Market Street Warehouse',
        status: 'Pending Confirmation',
        orderDate: '2024-05-20',
      ),
    ]);

    _buyers.addAll([
      Buyer(name: 'John Traders', photoUrl: 'https://via.placeholder.com/80/4CAF50/FFFFFF?text=J', status: 'Active'),
      Buyer(name: 'Fresh Foods Ltd', photoUrl: 'https://via.placeholder.com/80/FF9800/FFFFFF?text=F', status: 'Negotiating'),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _timeController.dispose();
    _warehouseController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectImage() {
    setState(() {
      _selectedImageLabel = 'Product image selected';
    });
  }

  void _postProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      final post = ProductPost(
        title: _titleController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim(),
        quantity: _quantityController.text.trim(),
        timeToWarehouse: _timeController.text.trim(),
        warehouseLocation: _warehouseController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        imageLabel: _selectedImageLabel,
      );

      setState(() {
        _posts.insert(0, post);
        _titleController.clear();
        _descriptionController.clear();
        _quantityController.clear();
        _timeController.clear();
        _warehouseController.clear();
        _phoneController.clear();
        _selectedImageLabel = null;
        _category = 'Food';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product posted successfully')),
      );
    }
  }

  void _confirmOrder(int index) {
    setState(() {
      _orders[index] = Order(
        buyerName: _orders[index].buyerName,
        productName: _orders[index].productName,
        quantity: _orders[index].quantity,
        status: 'Confirmed',
        orderDate: _orders[index].orderDate,
        totalPrice: _orders[index].totalPrice,
        buyerPhoto: _orders[index].buyerPhoto,
        rejectionReason: _orders[index].rejectionReason,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order confirmed successfully')),
    );
  }

  void _rejectOrder(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final reasonController = TextEditingController();
        return AlertDialog(
          title: const Text('Reject Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to reject this order?'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for rejection',
                  border: OutlineInputBorder(),
                  hintText: 'Enter reason (optional)',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _orders[index] = Order(
                    buyerName: _orders[index].buyerName,
                    productName: _orders[index].productName,
                    quantity: _orders[index].quantity,
                    status: 'Rejected',
                    orderDate: _orders[index].orderDate,
                    totalPrice: _orders[index].totalPrice,
                    buyerPhoto: _orders[index].buyerPhoto,
                    rejectionReason: reasonController.text.isNotEmpty
                        ? reasonController.text
                        : 'No reason provided',
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order rejected')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void _openNegotiationChat(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NegotiationChatScreen(
          buyerName: _orders[index].buyerName,
          productName: _orders[index].productName,
          buyerPhoto: _orders[index].buyerPhoto ?? 'https://via.placeholder.com/50/FF6B6B/FFFFFF?text=B',
        ),
      ),
    );
  }

  void _startDelivery(int index) {
    setState(() {
      _deliveries[index] = Delivery(
        buyerName: _deliveries[index].buyerName,
        productName: _deliveries[index].productName,
        quantity: _deliveries[index].quantity,
        deliveryLocation: _deliveries[index].deliveryLocation,
        status: 'In Transit',
        orderDate: _deliveries[index].orderDate,
      );
    });
  }

  void _markDelivered(int index) {
    setState(() {
      _deliveries[index] = Delivery(
        buyerName: _deliveries[index].buyerName,
        productName: _deliveries[index].productName,
        quantity: _deliveries[index].quantity,
        deliveryLocation: _deliveries[index].deliveryLocation,
        status: 'Delivered',
        orderDate: _deliveries[index].orderDate,
      );
    });
  }

  void _addFeedbackEntry(String buyerName, String message, int rating) {
    setState(() {
      _feedbacks.insert(0, FeedbackEntry(buyerName: buyerName, message: message, rating: rating, date: DateTime.now().toIso8601String().split('T').first));
    });
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Center(
        child: _selectedImageLabel == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.image_outlined, size: 48, color: Colors.green),
                  SizedBox(height: 8),
                  Text('No image selected'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  Text(_selectedImageLabel!),
                ],
              ),
      ),
    );
  }

  Widget _buildPostCard(ProductPost post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    size: 42,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(post.category, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${post.quantity}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              'Harvest → Warehouse: ${post.timeToWarehouse}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Warehouse: ${post.warehouseLocation}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Phone: ${post.phoneNumber}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Post a Product',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Product Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter product title'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(value: 'Livestock', child: Text('Livestock')),
                    DropdownMenuItem(value: 'Equipment', child: Text('Equipment')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter the quantity'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time to Warehouse',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter time to warehouse'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _warehouseController,
                  decoration: const InputDecoration(
                    labelText: 'Warehouse Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter warehouse location'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter phone number'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildImagePreview(),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _selectImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Select Image', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _postProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Post Product', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your posts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_posts.isEmpty)
            const Text('You have not posted any products yet.'),
          ..._posts.map(_buildPostCard),
        ],
      ),
    );
  }

  Widget _buildViewOrdersTab() {
    if (_orders.isEmpty) {
      return const Center(child: Text('No orders available.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Buyer: ${order.buyerName}'),
                Text('Quantity: ${order.quantity}'),
                Text('Status: ${order.status}'),
                Text('Date: ${order.orderDate}'),
                Text('Total: ${order.totalPrice}'),
                if (order.rejectionReason != null && order.status == 'Rejected')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Rejection reason: ${order.rejectionReason}', style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (order.status != 'Confirmed' && order.status != 'Rejected')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _confirmOrder(index),
                          child: const Text('Confirm Order'),
                        ),
                      ),
                    if (order.status != 'Confirmed' && order.status != 'Rejected')
                      const SizedBox(width: 12),
                    if (order.status != 'Confirmed' && order.status != 'Rejected')
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => _rejectOrder(index),
                          child: const Text('Reject Order'),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                  onPressed: () => _openNegotiationChat(index),
                  child: const Text('Open Chat'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartDeliveryTab() {
    if (_deliveries.isEmpty) {
      return const Center(child: Text('No deliveries to manage.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _deliveries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final delivery = _deliveries[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(delivery.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Buyer: ${delivery.buyerName}'),
                Text('Quantity: ${delivery.quantity}'),
                Text('Location: ${delivery.deliveryLocation}'),
                Text('Status: ${delivery.status}'),
                Text('Date: ${delivery.orderDate}'),
                const SizedBox(height: 12),
                if (delivery.status == 'Pending Confirmation')
                  ElevatedButton(
                    onPressed: () => _startDelivery(index),
                    child: const Text('Start Delivery'),
                  )
                else if (delivery.status == 'In Transit')
                  ElevatedButton(
                    onPressed: () => _markDelivered(index),
                    child: const Text('Mark Delivered'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Feedback',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _feedbacks.isEmpty
                ? const Center(child: Text('No feedback received yet.'))
                : ListView.separated(
                    itemCount: _feedbacks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = _feedbacks[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.buyerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(entry.message),
                              const SizedBox(height: 8),
                              Text('Rating: ${entry.rating}/5'),
                              Text('Date: ${entry.date}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _addFeedbackEntry('Market Buyer', 'Great product quality and fast delivery.', 5),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Add Sample Feedback', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsTab() {
    if (_buyers.isEmpty) {
      return const Center(child: Text('No chats yet.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _buyers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final buyer = _buyers[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(buyer.photoUrl)),
            title: Text(buyer.name),
            subtitle: Text(buyer.status),
            trailing: const Icon(Icons.chat),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NegotiationChatScreen(
                    buyerName: buyer.name,
                    productName: '',
                    buyerPhoto: buyer.photoUrl,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMedicalLabTab() {
    return const MedicalLabScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(_buyers.isNotEmpty ? _buyers.first.photoUrl : 'https://via.placeholder.com/80'),
                ),
                accountName: Text(widget.name),
                accountEmail: Text(widget.location),
              ),
              const ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard Home'),
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Chats'),
                onTap: () {
                  Navigator.pop(context);
                  _tabController.animateTo(4);
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () {
                  Navigator.pop(context);
                  _tabController.animateTo(3);
                },
              ),
              ListTile(
                leading: const Icon(Icons.science),
                title: const Text('Medical Laboratory'),
                onTap: () {
                  Navigator.pop(context);
                  _tabController.animateTo(5);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Customers', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _buyers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final b = _buyers[index];
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(b.photoUrl)),
                      title: Text(b.name),
                      subtitle: Text(b.status),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NegotiationChatScreen(
                              buyerName: b.name,
                              productName: '',
                              buyerPhoto: b.photoUrl,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome, ${widget.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Type: ${widget.farmerType}'),
                Text('Location: ${widget.location}'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.green.shade50,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.green.shade800,
                    indicatorColor: Colors.green.shade800,
                    tabs: const [
                      Tab(text: 'Add Product'),
                      Tab(text: 'View Orders'),
                      Tab(text: 'Start Delivery'),
                      Tab(text: 'Feedback'),
                      Tab(text: 'Chats'),
                      Tab(text: 'Med Lab'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAddProductTab(),
                      _buildViewOrdersTab(),
                      _buildStartDeliveryTab(),
                      _buildFeedbackTab(),
                      _buildChatsTab(),
                      _buildMedicalLabTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NegotiationChatScreen extends StatefulWidget {
  final String buyerName;
  final String productName;
  final String buyerPhoto;

  const NegotiationChatScreen({
    super.key,
    required this.buyerName,
    required this.productName,
    required this.buyerPhoto,
  });

  @override
  State<NegotiationChatScreen> createState() => _NegotiationChatScreenState();
}

class _NegotiationChatScreenState extends State<NegotiationChatScreen> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        sender: widget.buyerName,
        message: text,
        timestamp: DateTime.now().toIso8601String().split('T').first,
        isFromFarmer: true,
      ));
      _messageController.clear();
      _messages.add(ChatMessage(
        sender: widget.buyerName,
        message: 'Thanks for your message. I will review and respond shortly.',
        timestamp: DateTime.now().toIso8601String().split('T').first,
        isFromFarmer: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.buyerPhoto)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.buyerName, style: const TextStyle(fontSize: 18)),
                  const Text('Negotiation chat', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('Start the negotiation by sending a message.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message.isFromFarmer ? Alignment.centerRight : Alignment.centerLeft,
                        child: Card(
                          color: message.isFromFarmer ? Colors.green.shade100 : Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(message.message),
                                const SizedBox(height: 8),
                                Text(
                                  message.timestamp,
                                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalLabScreen extends StatefulWidget {
  const MedicalLabScreen({super.key});

  @override
  State<MedicalLabScreen> createState() => _MedicalLabScreenState();
}

class _MedicalLabScreenState extends State<MedicalLabScreen> {
  final _queryController = TextEditingController();
  final List<AIMedicalAdvice> _adviceHistory = [];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _askLab() {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;
    final advice = _generateAdviceForQuery(query);
    setState(() {
      _adviceHistory.insert(0, advice);
      _queryController.clear();
    });
  }

  AIMedicalAdvice _generateAdviceForQuery(String query) {
    if (query.toLowerCase().contains('seed')) {
      return AIMedicalAdvice(
        topic: 'Seed recommendation',
        advice: 'Use a certified drought-tolerant variety this season and rotate with legumes for soil health.',
        category: 'Seed',
      );
    }
    if (query.toLowerCase().contains('fertilizer')) {
      return AIMedicalAdvice(
        topic: 'Fertilizer advice',
        advice: 'Apply balanced NPK and add organic compost to improve nutrient retention.',
        category: 'Fertilizer',
      );
    }
    if (query.toLowerCase().contains('soil')) {
      return AIMedicalAdvice(
        topic: 'Soil recommendation',
        advice: 'Test soil pH and use lime for acidic soils; build organic matter with cover crops.',
        category: 'Soil',
      );
    }
    return AIMedicalAdvice(
      topic: 'General advice',
      advice: 'Monitor crop health regularly, use integrated pest management, and maintain good water management.',
      category: 'General',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Medical Laboratory'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ask the AI Lab',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'What do you need help with?',
                hintText: 'e.g. best seed, fertilizer, soil type',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _askLab,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Text('Ask the AI Lab', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _adviceHistory.isEmpty
                  ? const Center(child: Text('Ask a question to get tailored farming support.'))
                  : ListView.separated(
                      itemCount: _adviceHistory.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final advice = _adviceHistory[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(advice.topic, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(advice.advice),
                                const SizedBox(height: 8),
                                Text('Category: ${advice.category}', style: const TextStyle(color: Colors.green)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerRoleAuthPage extends StatelessWidget {
  const BuyerRoleAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Login'),
        backgroundColor: Colors.blue,
      ),
      body: const BuyerLoginPage(),
    );
  }
}

class BuyerLoginPage extends StatefulWidget {
  const BuyerLoginPage({super.key});

  @override
  State<BuyerLoginPage> createState() => _BuyerLoginPageState();
}

class _BuyerLoginPageState extends State<BuyerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final login = _emailOrUsernameController.text.trim();
      final password = _passwordController.text;
      final user = findRegisteredUser(login);

      if (user == null || user.role != 'Buyer' || user.password != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No buyer account found for those credentials'),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuyerDashboard(
            name: '${user.firstName} ${user.lastName}',
            companyType: 'Buyer',
            location: 'N/A',
            preferredProducts: 'None',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.shade900,
                  Colors.orange.shade800,
                  Colors.orange.shade400,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 88),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'log in',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      Text(
                        'welcome back',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailOrUsernameController,
                      decoration: const InputDecoration(
                        labelText: 'Email or Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter email or username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not registered yet?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BuyerRegisterPage(),
                              ),
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuyerRegisterPage extends StatefulWidget {
  const BuyerRegisterPage({super.key});

  @override
  State<BuyerRegisterPage> createState() => _BuyerRegisterPageState();
}

class _BuyerRegisterPageState extends State<BuyerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  late String _suggestedPassword;

  @override
  void initState() {
    super.initState();
    _suggestedPassword = generateStrongPassword();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isPasswordStrong(String value) {
    return value.length >= 8 &&
        RegExp(r'(?=.*[a-zA-Z])').hasMatch(value) &&
        RegExp(r'(?=.*\d)').hasMatch(value) &&
        RegExp(r'(?=.*[!@#\u0024%^&*])').hasMatch(value);
  }

  void _generateNewPassword() {
    setState(() {
      _suggestedPassword = generateStrongPassword();
    });
  }

  void _useSuggestedPassword() {
    _passwordController.text = _suggestedPassword;
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      if (registeredUsers.any(
        (user) =>
            normalizeLogin(user.email) == normalizeLogin(email) ||
            normalizeLogin(user.username) == normalizeLogin(username),
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email or username already registered')),
        );
        return;
      }

      registeredUsers.add(
        RegisteredUser(
          role: 'Buyer',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: email,
          username: username,
          password: password,
        ),
      );

      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuyerDashboard(
            name: fullName,
            companyType: 'Buyer',
            location: 'N/A',
            preferredProducts: 'None',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null, backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.shade900,
                    Colors.orange.shade800,
                    Colors.orange.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 88),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'sign up',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          'create your buyer account',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter first name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter last name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please choose a username'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          helperText: 'Use letters, numbers, and symbols',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (!_isPasswordStrong(value)) {
                            return 'Password must be at least 8 chars with letters, numbers, and symbols';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Suggested strong password: $_suggestedPassword',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: _useSuggestedPassword,
                            child: const Text('Use suggested password'),
                          ),
                          TextButton(
                            onPressed: _generateNewPassword,
                            child: const Text('Generate another'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Back to login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerLoginTab extends StatefulWidget {
  final TabController tabController;

  const BuyerLoginTab({super.key, required this.tabController});

  @override
  State<BuyerLoginTab> createState() => _BuyerLoginTabState();
}

class _BuyerLoginTabState extends State<BuyerLoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _productsController = TextEditingController();
  bool _passwordVisible = false;
  String _companyType = 'Individual';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _productsController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuyerDashboard(
            name: _nameController.text.trim(),
            companyType: _companyType,
            location: _locationController.text.trim(),
            preferredProducts: _productsController.text.trim(),
          ),
        ),
      );
    }
  }

  void _googleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google sign-in would work here!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Buyer Login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _companyType,
              decoration: const InputDecoration(
                labelText: 'Company Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Individual',
                  child: Text('Individual'),
                ),
                DropdownMenuItem(value: 'Company', child: Text('Company')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _companyType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your location'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _productsController,
              decoration: const InputDecoration(
                labelText: 'Preferred Products',
                border: OutlineInputBorder(),
                hintText: 'e.g., Maize, Beans, Tomatoes',
              ),
              maxLines: 3,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter preferred products'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Login', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _googleSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerSignUpTab extends StatefulWidget {
  final TabController tabController;

  const BuyerSignUpTab({super.key, required this.tabController});

  @override
  State<BuyerSignUpTab> createState() => _BuyerSignUpTabState();
}

class _BuyerSignUpTabState extends State<BuyerSignUpTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _productsController = TextEditingController();
  bool _passwordVisible = false;
  String _companyType = 'Individual';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _productsController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuyerDashboard(
            name: _nameController.text.trim(),
            companyType: _companyType,
            location: _locationController.text.trim(),
            preferredProducts: _productsController.text.trim(),
          ),
        ),
      );
    }
  }

  void _googleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google sign-up would work here!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Buyer Sign Up',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                  return 'Password must start with a capital letter';
                }
                if (!RegExp(
                  r'(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])',
                ).hasMatch(value)) {
                  return 'Password must contain letters, numbers, and symbols';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _companyType,
              decoration: const InputDecoration(
                labelText: 'Company Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Individual',
                  child: Text('Individual'),
                ),
                DropdownMenuItem(value: 'Company', child: Text('Company')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _companyType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your location'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _productsController,
              decoration: const InputDecoration(
                labelText: 'Preferred Products',
                border: OutlineInputBorder(),
                hintText: 'e.g., Maize, Beans, Tomatoes',
              ),
              maxLines: 3,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter preferred products'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Sign Up', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _googleSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign up with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerDashboard extends StatelessWidget {
  final String name;
  final String companyType;
  final String location;
  final String preferredProducts;

  const BuyerDashboard({
    super.key,
    required this.name,
    required this.companyType,
    required this.location,
    required this.preferredProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Type: $companyType', style: const TextStyle(fontSize: 16)),
            Text('Location: $location', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Preferred Products: $preferredProducts',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Buyer dashboard content goes here.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Browse available crops, connect with farmers, and place orders.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
