import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flicks/core/helpers/app_helpers.dart';
import 'package:user_flicks/core/theme/colors.dart';
import 'package:user_flicks/features/movie_details_screen/model/movie_details_data_model.dart';
import 'package:user_flicks/features/movie_details_screen/view_model/movie_details_vm.dart';
import 'package:user_flicks/features/movie_details_screen/widgets/details_row.dart';
import 'package:user_flicks/features/movie_details_screen/widgets/movie_detail_header.dart';
import 'package:user_flicks/features/movie_details_screen/widgets/movie_detail_info_row.dart';
import 'package:user_flicks/features/movie_details_screen/widgets/section_title.dart';
import 'package:user_flicks/widgets/edge_state.dart';

class MovieDetailsView extends StatefulWidget {
  final String movieId;
  const MovieDetailsView({super.key, required this.movieId});

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  @override
  void initState() {
    Provider.of<MovieDetailsVm>(
      context,
      listen: false,
    ).getMovieDetails(movieId: widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieDetailsVm>(
      builder: (BuildContext context, MovieDetailsVm value, Widget? child) {
        final MovieDetailsDataModel? movie = value.movieDetailsDataModel;
        return SafeArea(
          child: Scaffold(
            body:
                value.getIfLoading
                    ? EdgeState(
                      message: "Hold tight, building your Details... 🎦",
                      showLoader: true,
                    )
                    : value.getIfHasError
                    ? EdgeState(
                      message:
                          "Something went wrong... but don't worry, it's not you! 😔",
                      icon: Icons.error_outline,
                      iconColor: AppColors.error,
                      onPressed:
                          () => value.getMovieDetails(movieId: widget.movieId),
                    )
                    : value.movieDetailsDataModel == null
                    ? EdgeState(
                      message: "Your details will show up soon. Stay tuned! 📻",
                      icon: Icons.people_outline,
                      iconColor: AppColors.textSecondary,
                      onPressed:
                          () => value.getMovieDetails(movieId: widget.movieId),
                    )
                    : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MoviePosterHeader(
                            moviePosterURL: movie?.backdropPath ?? "",
                            movieTitle: movie?.title ?? "",
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tagline
                                if (movie?.tagline != null &&
                                    movie?.tagline != "")
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      movie?.tagline ?? "",
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),

                                // Info Row
                                MovieDetailInfoRow(
                                  movieVote: movie!.voteAverage!,
                                  releaseDate: movie.releaseDate ?? "",
                                  runTime: movie.runtime.toString(),
                                ),

                                const SizedBox(height: 24),

                                // Overview
                                const SectionTitle(title: 'Overview'),
                                const SizedBox(height: 8),
                                Text(
                                  movie.overview ?? '',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Genres
                                if (movie.genres != null &&
                                    movie.genres!.isNotEmpty) ...[
                                  const SectionTitle(title: 'Genres'),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        movie.genres!
                                            .map(
                                              (genre) => Chip(
                                                label: Text(genre.name ?? ''),
                                                backgroundColor: AppColors
                                                    .primary
                                                    .withValues(alpha: 0.1),
                                                labelStyle: const TextStyle(
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ],

                                const SizedBox(height: 24),

                                // Details
                                const SectionTitle(title: 'Details'),
                                const SizedBox(height: 8),

                                MovieDetailsMovieMetaRows(
                                  label: 'Release Date',
                                  value: AppHelpers.formatDateWithSuffix(
                                    movie.releaseDate ?? "",
                                  ),
                                ),
                                MovieDetailsMovieMetaRows(
                                  label: 'Runtime',
                                  value: AppHelpers.formatDurationFromMinutes(
                                    int.tryParse(movie.runtime.toString()) ?? 0,
                                  ),
                                ),
                                MovieDetailsMovieMetaRows(
                                  label: 'Language',
                                  value:
                                      movie.originalLanguage?.toUpperCase() ??
                                      '',
                                ),
                                MovieDetailsMovieMetaRows(
                                  label: 'Status',
                                  value: movie.status ?? '',
                                ),
                                if (movie.budget != null && movie.budget != 0)
                                  MovieDetailsMovieMetaRows(
                                    label: 'Budget',
                                    value: AppHelpers.formatUSD(
                                      movie.budget ?? 0,
                                    ),
                                  ),
                                if (movie.revenue != null && movie.revenue != 0)
                                  MovieDetailsMovieMetaRows(
                                    label: 'Revenue',
                                    value: AppHelpers.formatUSD(
                                      movie.revenue ?? 0,
                                    ),
                                  ),
                                if (movie.homepage != null)
                                  MovieDetailsMovieMetaRows(
                                    label: 'Homepage',
                                    value: movie.homepage ?? "",
                                  ),
                                const SizedBox(height: 24),

                                // Production
                                if (movie.productionCompanies != null &&
                                    movie.productionCompanies!.isNotEmpty) ...[
                                  const SectionTitle(title: 'Produced By'),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children:
                                        movie.productionCompanies!
                                            .map(
                                              (company) => Chip(
                                                label: Text(company.name ?? ''),
                                                backgroundColor:
                                                    AppColors.cardBackground,
                                                side: const BorderSide(
                                                  color: AppColors.border,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ],

                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }
}
