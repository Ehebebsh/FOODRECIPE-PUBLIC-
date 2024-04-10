import 'package:flutter/material.dart';

class DismissibleListItem extends StatelessWidget {
  final String ingredient;
  final VoidCallback onDismissed;

  const DismissibleListItem({
    required this.ingredient,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(ingredient),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDismissed,
        ),
      ),
    );
  }
}
