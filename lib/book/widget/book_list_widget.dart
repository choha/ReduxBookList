import 'package:booklist/book/bean/book.dart';
import 'package:booklist/book/book_action/book_action.dart';
import 'package:booklist/book/state/book_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BookListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookListState();
}

/// flutter状态
class BookListState extends State<BookListWidget> {
  // 定义Redux store，包含了Reducer
  final store = new Store<BookList>(
    // 在book_state.dart中定义
    bookReducer,
    // 设置一个默认值
    initialState: BookList(books: [
      Book(name: "java 1", id: 1),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    // 使用Redux提供的StoreProvider作为root Widget
    return StoreProvider<BookList>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Redux使用"),
            backgroundColor: Colors.blue[300],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.red[300],
                    child: Text("添加书籍"),
                    onPressed: () {
                      store.dispatch(AddBookAction(book:
                      Book(name:"java ${store.state.books.length + 1}",
                      id: store.state.books.length+1)
                      )
                      );
                    },
                  ),
                  RaisedButton(
                    color: Colors.red[300],
                    child: Text("删除最后一本书"),
                    onPressed: () {
                      store.dispatch(DeleteBookAction());
                    },
                  ),
                ],
              ),
              Expanded(
                child: StoreConnector<BookList, BookList>(
                  converter: (store) => store.state,
                  builder: (BuildContext context, data) {
                    return Container(
                      height: 200,
                      child: ListView.builder(
                          itemCount:
                              data.books.length ,
                          itemBuilder: (BuildContext context, position) {
                            return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(getName(data, position)),
                                ],
                              ),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getName(BookList bookList, int position) {
    return bookList.books[position].name;
  }
}
