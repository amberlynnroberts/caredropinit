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
  final String? claimedBy;
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
    this.claimedBy,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      category: map['category']?.toString() ?? 'general',
      location: map['location']?.toString() ?? '',
      quantity: int.tryParse(map['quantity']?.toString() ?? '') ?? 1,
      status: map['status']?.toString() ?? 'pending',
      imageUrl: map['image_url']?.toString(),
      createdBy: map['created_by']?.toString() ?? '',
      claimedBy: map['claimed_by']?.toString(), 
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
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
        'claimed_by': claimedBy,
        'created_at': createdAt.toIso8601String(),
      };
}
