import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = userProvider.currentUser;
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 100,
                    color: isDarkMode ? Colors.white70 : Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please log in to view your profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text('Go to Login'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Theme Switch with Accessibility
                        Tooltip(
                          message: isDarkMode
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                          child: Row(
                            children: [
                              Text('Theme:'),
                              SizedBox(width: 10),
                              Switch(
                                key: Key('theme-switch'),
                                value: isDarkMode,
                                // semanticLabel: 'Toggle Theme',
                                activeColor: Colors.white,
                                activeTrackColor: Colors.green.shade700,
                                inactiveTrackColor: Colors.grey.shade300,
                                onChanged: (_) {
                                  themeProvider.toggleTheme();
                                },
                              ),
                            ],
                          ),
                        ),
                        // Edit Profile Button
                        IconButton(
                          key: Key('edit-profile-btn'),
                          icon: Icon(Icons.edit, color: Colors.green),
                          tooltip: 'Edit Profile',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                    user: user, username: user.username),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: isDarkMode
                            ? Colors.green.shade800
                            : Colors.green.shade100,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color:
                              isDarkMode ? Colors.green.shade300 : Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildProfileDetail('Name', user.name, isDarkMode),
                    _buildProfileDetail('Email', user.email, isDarkMode),
                    _buildProfileDetail('Phone', user.phone, isDarkMode),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          userProvider.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        icon: Icon(Icons.logout),
                        label: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileDetail(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
