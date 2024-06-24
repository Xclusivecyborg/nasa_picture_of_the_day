import 'package:flutter/material.dart';
import 'package:nasa_picture_of_the_day/general_widgets/spacing.dart';

class PictureOfTheDayErrorCard extends StatelessWidget {
  const PictureOfTheDayErrorCard(
      {super.key, required this.onRetry, required this.errorMessage});
  final void Function() onRetry;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            const VSpacing(20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
