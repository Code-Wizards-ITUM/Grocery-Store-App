import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/main_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUsers();
    });
  }

  void _login() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.login(emailController.text, passwordController.text)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.green[800] : Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/brand.jpg',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Grocery Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Login to continue shopping',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email/Username',
                      labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: isDarkMode ? Colors.white : Colors.green,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white24 : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: isDarkMode ? Colors.white : Colors.green,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: isDarkMode ? Colors.white : Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white24 : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.green[700] : Colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    ),
                    child: Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
