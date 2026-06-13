import 'package:equatable/equatable.dart';

class GalleryImage extends Equatable {
  const GalleryImage({
    required this.id,
    required this.title,
    required this.url,
  });

  final int id;
  final String title;
  final String url;

  @override
  List<Object?> get props => [id, title, url];
}
