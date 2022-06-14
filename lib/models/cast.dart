class Cast {
  const Cast({
    required this.author,
    required this.title,
    required this.duration,
    this.image,
  });

  final String author;
  final String title;
  final Duration duration;
  final String? image;
}
