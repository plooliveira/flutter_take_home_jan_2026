import 'dart:convert';
import 'dart:typed_data';

import 'package:aurora_take_home_paulo/data/models/image_data.dart';
import 'package:http/http.dart' as http;

import '../../core/result.dart';

abstract class ImageRepository {
  Future<Result<ImageData>> get();
  Future<Result<Uint8List>> download(String url);
}

class ImageRepositoryImpl implements ImageRepository {
  @override
  Future<Result<ImageData>> get() async {
    try {
      final response = await http.get(
        Uri.parse('https://november7-730026606190.europe-west1.run.app/image/'),
      );
      final image = ImageData.fromJson(jsonDecode(response.body));
      return Success(image);
    } catch (e) {
      return Failure(Exception('image request fail'));
    }
  }

  @override
  Future<Result<Uint8List>> download(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return Success(response.bodyBytes);
    } catch (e) {
      return Failure(Exception('image request fail'));
    }
  }
}
