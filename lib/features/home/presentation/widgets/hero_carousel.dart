import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:movies_app/core/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/core/widgets/poster_card.dart';

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({
    required this.movies,
    this.onFocusedIndexChanged,
    super.key,
  });

  final List<MovieEntity> movies;
  final ValueChanged<int>? onFocusedIndexChanged;

  static const double _posterFraction = 234 / 430;
  static const double _slideFraction = 254 / 430;

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * HeroCarousel._posterFraction;
        final cardHeight = cardWidth / PosterCard.aspectRatio;
        final sidePadding = constraints.maxWidth * 10 / 430;

        return CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.movies.length,
          itemBuilder: (context, index, pageIndex) => GestureDetector(
            onTap: () => _controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutCubic,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: PosterCard(
                posterUrl: widget.movies[index].posterUrl,
                rating: widget.movies[index].rating,
              ),
            ),
          ),
          options: CarouselOptions(
            height: cardHeight,
            viewportFraction: HeroCarousel._slideFraction,
            initialPage: widget.movies.length ~/ 2,
            enableInfiniteScroll: widget.movies.length > 1,
            autoPlay: widget.movies.length > 1,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 900),
            autoPlayCurve: Curves.easeInOutCubic,
            enlargeCenterPage: true,
            enlargeFactor: 0.21,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            onPageChanged: (index, reason) =>
                widget.onFocusedIndexChanged?.call(index),
          ),
        );
      },
    );
  }
}
