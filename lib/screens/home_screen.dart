// ignore_for_file: library_private_types_in_public_api

import 'package:cyber_buddy/utils/route_constants.dart';
import 'package:cyber_buddy/widgets/animated_particle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  _DesktopHomePageState createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(6, (index) => AnimatedParticle(index: index)),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  _buildTopBar(),

                  // Main content area
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildMainContent(),
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

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Spacer(),

          // Tab area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.terminal, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Text(
                  'Cyber Buddy',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Monaco',
                  ),
                ),
              ],
            ),
          ),

          Spacer(),

          // Right side controls
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add, color: Colors.white70),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_outline, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Text(
            'Code, plan, build, or run commands',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),

          SizedBox(height: 40),

          // Greeting
          Row(
            children: [
              Icon(Icons.rocket_launch_outlined, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Hello, Nidhi!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            'Get started with one of these suggestions',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 60),

          // Action cards
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.download_outlined,
                    title: 'Install',
                    subtitle: 'Install a binary/dependency',
                    color: Colors.blue,
                    onpressed:
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Installing a binary...')),
                        ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.code_outlined,
                    title: 'Code',
                    subtitle: 'Start a new project/feature or fix a bug',
                    color: Colors.purple,
                    onpressed: () {
                      context.goNamed(RouteConstants.chat);
                      // You can also show a dialog or snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Starting a new project...')),
                      );
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.rocket_outlined,
                    title: 'Deploy',
                    subtitle: 'Deploy your project',
                    color: Colors.orange,
                    onpressed:
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deploying your project...')),
                        ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Something else?',
                    subtitle: 'Pair with an Agent to accomplish another task',
                    color: Colors.green,
                    onpressed: () {
                      // Handle "Something else?" action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Pairing with an Agent...')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onpressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () {
            onpressed?.call();
          },
          child: Container(
            height: 200,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),

                SizedBox(height: 20),

                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
