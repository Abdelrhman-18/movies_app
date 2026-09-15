import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';

class RegisterSuccessDialog extends StatelessWidget {
  const RegisterSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.registrationSuccess),
      content: Text(context.l10n.accountCreatedSuccessfully),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}
