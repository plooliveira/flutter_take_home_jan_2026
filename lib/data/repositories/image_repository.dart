import 'dart:convert';

import 'package:aurora_take_home_paulo/data/models/image_data.dart';
import 'package:http/http.dart' as http;

import '../../core/result.dart';

abstract class ImageRepository {
  Future<Result<ImageData>> get();
}

class ImageRepositoryImpl implements ImageRepository {
  @override
  Future<Result<ImageData>> get() async {
    try {
      final response = await http.get(
        Uri.parse('https://november7-730026606190.europe-west1.run.app/image/'),
      );
      return Success(ImageData.fromJson(jsonDecode(response.body)));
    } catch (e) {
      return Failure(Exception('image request fail'));
    }
  }
}
