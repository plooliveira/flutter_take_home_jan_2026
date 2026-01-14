class ImageData {
  final String url;

  ImageData(this.url);

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(json['url']);
  }
}
