import 'package:flutter/material.dart';
import 'package:user_flicks/core/helpers/app_helpers.dart';
import 'package:user_flicks/core/theme/colors.dart';
import 'package:user_flicks/external/url_launcher.dart';

class MovieDetailsMovieMetaRows extends StatelessWidget {
  final String label;
  final String value;

  const MovieDetailsMovieMetaRows({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUrl = AppHelpers.isURL(value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child:
                isUrl
                    ? GestureDetector(
                      onTap: () async => await URLLauncherHelper.launch(value),
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    )
                    : Text(
                      value,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
          ),
        ],
      ),
    );
  }
}
