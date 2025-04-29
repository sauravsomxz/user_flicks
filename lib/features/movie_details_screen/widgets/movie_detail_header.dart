import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/theme/colors.dart';
import 'package:user_flicks/external/cached_image.dart';

class MoviePosterHeader extends StatelessWidget {
  final String moviePosterURL;
  final String movieTitle;
  const MoviePosterHeader({
    super.key,
    required this.moviePosterURL,
    required this.movieTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedImage(
          imageUrl: "${AppConfig.moviesImagesBaseUrl}/$moviePosterURL",
          fit: BoxFit.cover,
          height: 220,
          width: double.infinity,
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.black54,
                  AppColors.transparent,
                  AppColors.black54,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Text(
            movieTitle,
            style: const TextStyle(
              color: AppColors.cardBackground,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0),
            child: Icon(Icons.arrow_back_ios, color: AppColors.background),
          ),
        ),
      ],
    );
  }
}
