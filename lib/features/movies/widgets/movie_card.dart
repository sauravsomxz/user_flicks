import 'package:flutter/material.dart';
import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/helpers/date_time_helpers.dart';
import 'package:user_flicks/core/theme/colors.dart';
import 'package:user_flicks/external/cached_image.dart';

class MovieCard extends StatelessWidget {
  final String moviePosterImage;
  final String movieTitle;
  final String releaseDate;

  const MovieCard({
    super.key,
    required this.moviePosterImage,
    required this.movieTitle,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImage(
                imageUrl: "${AppConfig.moviesImagesBaseUrl}$moviePosterImage",
                height: 140,
                width: 100,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                errorWidget: Container(
                  color: AppColors.border,
                  width: 100,
                  height: 140,
                  child: const Icon(
                    Icons.broken_image,
                    size: 40,
                    color: AppColors.cardBackground,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieTitle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.movie_creation_rounded,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Released on ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              AppHelpers.formatDateWithSuffix(releaseDate),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
