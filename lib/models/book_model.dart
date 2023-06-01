class BookModel {
  final int bookID;
  final String bookName;
  final String bookImage;
  final String url;
  const BookModel(
      {required this.bookName,
      required this.bookImage,
      required this.bookID,
      required this.url});
  static BookModel fromJson(Map<String, dynamic> json) => BookModel(
      bookImage: json['book_image'] as String,
      bookID: json['id'] as int,
      bookName: json['book_name'] as String,
      url: json['book_url'] as String);
}
