import 'package:booklist/book/bean/book.dart';
import 'package:booklist/book/book_action/book_action.dart';

/// 定义book reducer。
/// reducer创建是有Redux提供的一个方法创建
/// 该方法接收一个数组，我们一次可以定义多个，
/// 采用的是泛型和方法类型接收。实际就是定义一个方法
/// 这个方法将Action处理后，再更新到State中，然后
/// State复制刷新数据。
import 'package:redux/redux.dart';

final BookReducer = combineReducers<List<Book>>([
  TypedReducer<List<Book>, AddBookAction>(addBook),
  TypedReducer<List<Book>, DeleteBookAction>(deleteBook),
]);
