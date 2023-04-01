import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class Book {
  final String title;
  final String author;
  final String publishDate;
  final String description;
  final int pageCount;
  final String publisher;
  final String thumbnailUrl;

  Book({
    required this.title,
    required this.author,
    required this.publishDate,
    required this.description,
    required this.pageCount,
    required this.publisher,
    required this.thumbnailUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return Book(
      title: json['volumeInfo']['title'] ?? '',
      author: json['volumeInfo']['authors']?.first ?? 'Unknown',
      publishDate: json['volumeInfo']['publishedDate'] ?? '',
      description: json['volumeInfo']['description'] ?? '',
      pageCount: json['volumeInfo']['pageCount'] ?? 0,
      publisher: json['volumeInfo']['publisher'] ?? '',
      thumbnailUrl: json['volumeInfo']['imageLinks']['thumbnail'] ?? '',
    );
  }
}

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> fetchBooks(String query) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=${query.replaceAll(' ', '+')}';
    final response = await http.get(Uri.parse(url));
    final jsonData = jsonDecode(response.body);
    final List<Book> loadedBooks = [];

    for (var item in jsonData['items']) {
      final book = Book.fromJson(item);
      loadedBooks.add(book);
    }

    _books = loadedBooks;
    notifyListeners();
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/src/response.dart';
// import 'dart:convert';

// class Book {
//   final String title;
//   final String author;
//   final String publishDate;
//   final String thumbnailUrl;

//   Book(
//       {required this.title,
//       required this.author,
//       required this.publishDate,
//       required this.thumbnailUrl});

//   factory Book.fromJson(Map<String, dynamic> json) {
//     debugPrint(json.toString());
//     return Book(
//       title: json['volumeInfo']['title'],
//       author: json['volumeInfo']['authors'][0],
//       publishDate: json['volumeInfo']['publishedDate'],
//       thumbnailUrl: json['volumeInfo']['imageLinks']['thumbnail'],
//     );
//   }
// }

// class Book {
//   final String title;
//   final List<String> authors;
//   final String publisher;
//   final String thumbnailUrl;
//   final double averageRating;

//   Book({
//     required this.title,
//     required this.authors,
//     required this.publisher,
//     required this.thumbnailUrl,
//     required this.averageRating,
//   });

//   factory Book.fromJson(Map<String, dynamic> json) {
//     final volumeInfo = json['volumeInfo'];

//     return Book(
//       title: volumeInfo['title'],
//       authors: List<String>.from(volumeInfo['authors'] ?? []),
//       publisher: volumeInfo['publisher'] ?? 'Unknown',
//       thumbnailUrl: volumeInfo['imageLinks']['thumbnail'],
//       averageRating: volumeInfo['averageRating'] ?? 0.0,
//     );
//   }
// }
