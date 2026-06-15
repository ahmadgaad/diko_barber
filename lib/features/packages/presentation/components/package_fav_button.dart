import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/features/packages/presentation/cubit/packages_list_cubit.dart';

class PackageFavButton extends StatelessWidget {
  const PackageFavButton({
    super.key,
    required this.package,
    required this.size,
    required this.iconSize,
  });

  final NearestPackage package;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<PackagesListCubit>().toggleFavorite(package.id),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          package.isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: package.isFavorite ? Colors.red : Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
