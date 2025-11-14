class RequestModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final int quantity;
  final String status; // pending, claimed, fulfilled
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.quantity,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.imageUrl,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'general',
      location: map['location'] ?? '',
      quantity: (map['quantity'] ?? 1) as int,
      status: map['status'] ?? 'pending',
      imageUrl: map['image_url'],
      createdBy: map['created_by'] ?? 'unknown',
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'quantity': quantity,
        'status': status,
        'image_url': imageUrl,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
      };
}

