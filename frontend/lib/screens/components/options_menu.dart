import 'package:flutter/material.dart';

void showOptionsMenu(
  BuildContext context,
  int currentTabIndex,
  List<dynamic> chatTabs,
  Function onChatCleared,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Color(0xFF1a1a1a),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.clear_all,
              title: 'Clear Chat',
              onTap: () {
                _clearCurrentChat(() {
                  // Implement clear chat functionality
                  chatTabs[currentTabIndex].messages.clear();
                  onChatCleared();
                });
              },
            ),
            _buildMenuOption(
              icon: Icons.file_upload_outlined,
              title: 'Export Chat',
              onTap: () {
                Navigator.pop(context);
                _exportChat(context);
              },
            ),
            _buildMenuOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                _showSettings(context);
              },
            ),
            _buildMenuOption(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                Navigator.pop(context);
                _showAbout(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildMenuOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[300], size: 20),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 16),
          ],
        ),
      ),
    ),
  );
}

void _clearCurrentChat(VoidCallback onClear) {
  onClear();
}

void _exportChat(BuildContext context) {
  // Implement chat export functionality
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Export functionality coming soon!'),
      backgroundColor: Color(0xFF4a9eff),
    ),
  );
}

void _showSettings(BuildContext context) {
  // Implement settings screen
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Settings screen coming soon!'),
      backgroundColor: Color(0xFF4a9eff),
    ),
  );
}

void _showAbout(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Color(0xFF1a1a1a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.security, color: Color(0xFF4a9eff)),
              SizedBox(width: 8),
              Text('Cyber Buddy', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text(
            'Your personal cybersecurity assistant.\n\nVersion 1.0.0\nBuilt with Flutter',
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Color(0xFF4a9eff))),
            ),
          ],
        ),
  );
}
