import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/api_exception.dart';

class BookService {
  static const String apiUrl = "https://doomscrolling-poc.vercel.app/books/books_list.json";

  Future<List<dynamic>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['data']?['books'] == null) {
          throw ApiException(
              message: 'Invalid data format',
              statusCode: response.statusCode,
              details: 'Books data is missing from the response'
          );
        }
        return data['data']['books'];
      } else if (response.statusCode == 404) {
        throw ApiException(
            message: 'Books not found',
            statusCode: response.statusCode
        );
      } else if (response.statusCode >= 500) {
        throw ApiException(
            message: 'Server error',
            statusCode: response.statusCode,
            details: 'Please try again later'
        );
      } else {
        throw ApiException(
            message: 'Failed to load books',
            statusCode: response.statusCode,
            details: 'Status code: ${response.statusCode}'
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException(
          message: 'Network error',
          details: 'Please check your internet connection'
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
          message: 'Unexpected error',
          details: e.toString()
      );
    }
  }
}