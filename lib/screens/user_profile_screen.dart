import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wishlist_provider.dart';
import 'wishlist_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // User Name
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // User Email
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),

                  const SizedBox(height: 16),

                  // Edit Profile Button
                  OutlinedButton.icon(
                    onPressed: () {
                      _showEditProfileDialog(context);
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Account Section
                  _buildSectionTitle('Account'),
                  _buildProfileOption(
                    icon: Icons.shopping_bag,
                    title: 'Order History',
                    subtitle: 'View your past orders',
                    onTap: () =>
                        _showComingSoonDialog(context, 'Order History'),
                  ),
                  _buildProfileOption(
                    icon: Icons.favorite,
                    title: 'Wishlist',
                    subtitle: 'Your favorite items',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WishlistScreen(),
                        ),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.location_on,
                    title: 'Shipping Addresses',
                    subtitle: 'Manage your addresses',
                    onTap: () =>
                        _showComingSoonDialog(context, 'Shipping Addresses'),
                  ),
                  _buildProfileOption(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Manage payment options',
                    onTap: () =>
                        _showComingSoonDialog(context, 'Payment Methods'),
                  ),

                  const SizedBox(height: 20),

                  // Preferences Section
                  _buildSectionTitle('Preferences'),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) =>
                        _buildSwitchOption(
                          icon: themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          title: 'Dark Mode',
                          subtitle: 'Switch between light and dark theme',
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(),
                        ),
                  ),
                  _buildProfileOption(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage notification preferences',
                    onTap: () =>
                        _showComingSoonDialog(context, 'Notifications'),
                  ),
                  _buildProfileOption(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'Change app language',
                    trailing: 'English',
                    onTap: () => _showLanguageDialog(context),
                  ),

                  const SizedBox(height: 20),

                  // Support Section
                  _buildSectionTitle('Support'),
                  _buildProfileOption(
                    icon: Icons.help,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    onTap: () => _showComingSoonDialog(context, 'Help Center'),
                  ),
                  _buildProfileOption(
                    icon: Icons.info,
                    title: 'About',
                    subtitle: 'App version and info',
                    trailing: 'v1.0.0',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    subtitle: 'Sign out of your account',
                    textColor: Colors.red,
                    onTap: () => _showSignOutDialog(context),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        subtitle: Text(subtitle),
        trailing: trailing != null
            ? Text(trailing, style: const TextStyle(color: Colors.grey))
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇺🇸'),
                title: const Text('English'),
                trailing: const Icon(Icons.check, color: Colors.green),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Text('🇸🇦'),
                title: const Text('العربية'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showComingSoonDialog(context, 'Arabic Language Support');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Sprints Shop',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.shopping_bag,
        size: 48,
        color: Theme.of(context).primaryColor,
      ),
      children: [
        const Text(
          'A comprehensive Flutter shopping application built with modern design principles.',
        ),
        const SizedBox(height: 16),
        const Text('Developed with ❤️ using Flutter & Dart'),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement actual sign out logic
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: Text('$feature will be available in a future update!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
