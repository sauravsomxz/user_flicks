import 'package:flutter/material.dart';
import 'package:user_flicks/core/helpers/app_helpers.dart';
import 'package:user_flicks/core/theme/colors.dart';

class MovieDetailInfoRow extends StatelessWidget {
  final num movieVote;
  final String runTime;
  final String releaseDate;
  const MovieDetailInfoRow({
    super.key,
    required this.movieVote,
    required this.runTime,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.secondary, size: 20),
          const SizedBox(width: 6),
          Text(
            '${movieVote.toStringAsFixed(1)}/10',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.access_time,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            AppHelpers.formatDurationFromMinutes(int.tryParse(runTime) ?? 0),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.calendar_today,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            AppHelpers.formatDateWithSuffix(releaseDate),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
