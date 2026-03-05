class StemFile {
  final String id;
  final String title;
  final String artist;
  final double price;
  final int bpm;
  final String key;
  final String genre;
  final String imageUrl;
  final String description;
  final List<String> includeStems;
  final String duration;
  final String? videoUrl;

  const StemFile({
    required this.id,
    required this.title,
    required this.artist,
    required this.price,
    required this.bpm,
    required this.key,
    required this.genre,
    required this.imageUrl,
    required this.description,
    required this.includeStems,
    required this.duration,
    this.videoUrl,
  });
}

class CartItem extends StemFile {
  final int quantity;

  const CartItem({
    required super.id,
    required super.title,
    required super.artist,
    required super.price,
    required super.bpm,
    required super.key,
    required super.genre,
    required super.imageUrl,
    required super.description,
    required super.includeStems,
    required super.duration,
    super.videoUrl,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      title: title,
      artist: artist,
      price: price,
      bpm: bpm,
      key: key,
      genre: genre,
      imageUrl: imageUrl,
      description: description,
      includeStems: includeStems,
      duration: duration,
      videoUrl: videoUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromStemFile(StemFile stemFile, {int quantity = 1}) {
    return CartItem(
      id: stemFile.id,
      title: stemFile.title,
      artist: stemFile.artist,
      price: stemFile.price,
      bpm: stemFile.bpm,
      key: stemFile.key,
      genre: stemFile.genre,
      imageUrl: stemFile.imageUrl,
      description: stemFile.description,
      includeStems: stemFile.includeStems,
      duration: stemFile.duration,
      videoUrl: stemFile.videoUrl,
      quantity: quantity,
    );
  }
}
