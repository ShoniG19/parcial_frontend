import 'package:flutter/material.dart';

class ClientSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const ClientSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o documento...',
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: colorScheme.onSurface.withOpacity(0.7)),
                  onPressed: controller.clear,
                )
              : null,
          filled: true,
          fillColor: colorScheme.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}