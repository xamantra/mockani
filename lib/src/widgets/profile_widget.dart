import 'package:flutter/material.dart';
import 'package:mockani/src/data/user.dart';
import 'package:mockani/src/utils/theme_extension.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = getCustomTheme(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.radical,
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            user.data.level.toString(),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          user.data.username,
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}
