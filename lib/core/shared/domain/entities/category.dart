class CategoryType {
  const CategoryType({required this.id, required this.name});
  final int id;
  final String name;
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });

  final int id;
  final String name;
  final String image;
  final CategoryType type;
}
