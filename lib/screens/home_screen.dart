import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAppBar(context),
            infoBox(
              context,
              'Welcome to the Home Screen',
              'This is a simple example of a home screen layout in Flutter.',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                infoBox(
                  context,
                  'Flutter Development',
                  'Flutter allows you to build beautiful native apps for mobile, web, and desktop from a single codebase.',
                ),
                infoBox(
                  context,
                  'Responsive Design',
                  'Flutter provides a rich set of widgets that adapt to different screen sizes and orientations.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Cyber Buddy'),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget infoBox(BuildContext context, String title, String description) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
