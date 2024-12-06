import 'package:flutter/material.dart';

class FacebookAppBar extends StatelessWidget {
  final VoidCallback onSearchPressed;
  final VoidCallback onNotificationPressed;

  const FacebookAppBar({
    super.key,
    required this.onSearchPressed,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/facebook_logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              "Facebook",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: onSearchPressed,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: onNotificationPressed,
            ),
          ],
        ),
      ],
    );
  }
}
