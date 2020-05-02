import 'package:booklist/book/bean/book.dart';
import 'package:booklist/book/state/book_reducer.dart';

/// 持有一个类型是book的list对象

class BookList{
  List<Book> books;

  BookList({this.books});
}
/// 定义Reducer


/// 定义Reducer方法给Store对象
BookList bookReducer(BookList state,action){
  return BookList(
    books: BookReducer(state.books,action),
  );
}