enum LoadState {
  loading,
  loadMore,
  success,
  error,
  initial,
  done,
}

enum MediaType {
  image,
  video;

  static MediaType fromString(String? mediaType) {
    return switch (mediaType?.toLowerCase()) {
      'video' => MediaType.video,
      _ => MediaType.image,
    };
  }

  String toJson() {
    return name;
  }
}
