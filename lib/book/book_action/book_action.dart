

import 'package:booklist/book/bean/book.dart';

/// 添加book的Action
class AddBookAction {
  Book book;

  AddBookAction({this.book});
}

/// 删除book的Action
class DeleteBookAction {
  DeleteBookAction();
}

/// 添加书籍的方法
List<Book> addBook(List<Book> books, action) {
  books.add(action.book);
  return books;
}

///删除书籍的方法
List<Book> deleteBook(List<Book> books, action) {
  books.removeLast();
  return books;
}
