import 'package:equatable/equatable.dart';
import 'package:zain/core/shared/domain/entities/coupon.dart';

import 'package.dart';
import 'review.dart';
import 'salon_service.dart';
import 'salon_staff.dart';
import 'shift.dart';

class SalonDetails extends Equatable {
  const SalonDetails({
    required this.id,
    required this.name,
    required this.logo,
    required this.coverImage,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.categories,
    required this.isOpen,
    required this.address,
    required this.gallery,
    required this.services,
    required this.packages,
    required this.reviews,
    required this.coupons,
    required this.staff,
    required this.shifts,
    this.closingTime,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String logo;
  final String coverImage;
  final String description;
  final double rating;
  final int reviewCount;
  final double distance;
  final List<String> categories;
  final bool isOpen;
  final String? closingTime;
  final bool isFavorite;
  final String address;
  final List<String> gallery;
  final List<SalonService> services;
  final List<Package> packages;
  final List<Review> reviews;
  final List<Coupon> coupons;
  final List<SalonStaff> staff;
  final List<Shift> shifts;

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
        coverImage,
        description,
        rating,
        reviewCount,
        distance,
        categories,
        isOpen,
        closingTime,
        isFavorite,
        address,
        gallery,
        services,
        packages,
        reviews,
        coupons,
        staff,
        shifts,
      ];
}

