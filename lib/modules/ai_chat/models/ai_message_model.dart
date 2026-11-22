enum ChatAttachmentType {
  none,
  image,
  document,
}

class AiMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? attachmentPath;
  final String? attachmentName;
  final int? attachmentSize;
  final ChatAttachmentType attachmentType;
  final List<int> recommendedJobIds;
  final bool isLoading;

  AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.attachmentPath,
    this.attachmentName,
    this.attachmentSize,
    this.attachmentType = ChatAttachmentType.none,
    this.recommendedJobIds = const [],
    this.isLoading = false,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get hasAttachment =>
      attachmentType != ChatAttachmentType.none &&
      attachmentPath != null &&
      attachmentPath!.isNotEmpty;

  bool get isImage => attachmentType == ChatAttachmentType.image;
  bool get isDocument => attachmentType == ChatAttachmentType.document;

  AiMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? attachmentPath,
    String? attachmentName,
    int? attachmentSize,
    ChatAttachmentType? attachmentType,
    List<int>? recommendedJobIds,
    bool? isLoading,
  }) {
    return AiMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      attachmentName: attachmentName ?? this.attachmentName,
      attachmentSize: attachmentSize ?? this.attachmentSize,
      attachmentType: attachmentType ?? this.attachmentType,
      recommendedJobIds: recommendedJobIds ?? this.recommendedJobIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'attachmentPath': attachmentPath,
      'attachmentName': attachmentName,
      'attachmentSize': attachmentSize,
      'attachmentType': attachmentType.name,
      'recommendedJobIds': recommendedJobIds,
    };
  }

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text']?.toString() ?? '',
      isUser: json['isUser'] == true,
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
      attachmentPath: json['attachmentPath']?.toString(),
      attachmentName: json['attachmentName']?.toString(),
      attachmentSize: json['attachmentSize'] is int ? json['attachmentSize'] as int : null,
      attachmentType: ChatAttachmentType.values.firstWhere(
        (e) => e.name == json['attachmentType'],
        orElse: () => ChatAttachmentType.none,
      ),
      recommendedJobIds: (json['recommendedJobIds'] as List<dynamic>?)
              ?.map((e) => int.tryParse('$e') ?? 0)
              .where((e) => e > 0)
              .toList() ??
          [],
      isLoading: false,
    );
  }
}
