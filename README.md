# Redux应用




##概述

Flutter 是 Google 开源的 跨平台开发工具，我们可以在anroid，iOS上完成功能开发，避免两拨人力成本。

Redux对于JavaScript应用而言是一个可预测状态的容器。换言之，它是一个应用数据流框架，而不是传统的像underscore.js或者AngularJs那样的库或者框架。后来在Rn和Flutter上都开发了，今天给大家分享一下在Flutter中使用Redux。

##一、集成Redux

在项目的pubspec.yaml的dependencies中添加：
```
dependencies:
 	...
  redux: 4.0.0
  flutter_redux: ^0.6.0
```

##二、安装

当我们编辑了pubspec.yaml文件，AndroidStudio的编辑区域右上角会显示put get样式，直接点击就可安装。

你也可以在项目的更目录执行：flutter pub get

pub 官网有详细介绍安装步骤：https://pub.dev/packages/scoped_model#-installing-tab-

##三、Redux使用

- 1、定义model

- 2、定义State

- 3、定义Action，操作类型，比如添加书、删除书等不同类型的标识。

- 4、定义Reducer（定义了应用如何响应Redux发出Action，即发出的Action由谁处理）

- 5、创建Store，负责绑定Reducer和默认数据。

- 6、使用Redux在Flutter中提供的Widget创建视图，并和Store绑定。

- 7、发送通过Store的dispatch发送Action。

我们通过一个添加书籍列表来完成Redux的使用，运行效果图：

###1、定义model，我们创建一个book.dart,代码如下：

/// 定义book 类型
class Book {
  String name;
  int id;

  Book({this.name, this.id});
}

###2、定义state，创建一个book_state.dart文件，代码如下：
```
/// 持有一个类型是book的list对象
class BookListState{
  List<Book> books;  BookListState({this.books});}
```
3、定义Action，分别定义一个添加和删除的Action。并定义删除书和添加书的逻辑处理方法，创建book_action.dart类，代码如下：

import 'package:booklist/book/bean/book.dart';

/// 添加book的Action
class AddBootAction {
  Book book;

  AddBootAction({this.book});
}

/// 删除book的Action
class DeleteBootAction {
  DeleteBootAction();
}

/// 添加书籍的方法
/// 注意这里的返回值一定是和我们在BookState中定义的状态类型一样。
/// 方法参数 books,这个参数就是我们在State定义的变量books，Redux发送消息时，携带过来。
/// action就是对应的我们上面定义的AddBootAction，二者如何管理，我们在第四步中确认
List<Book> addBook(List<Book> books, action) {
  // 将书籍添加到列表中。
  books.add(action.book);
  return books;
}

///删除书籍的方法，这里的返回类型和形参和上面的一样。
List<Book> deleteBook(List<Book> books, action) {
  books.removeLast();
  return books;
}

4、定义Reducer，将Action和操作方法绑定，创建一个book_reducer.dart，代码如下：

import 'package:redux/redux.dart';
import 'package:booklist/book/bean/book.dart';
import 'package:booklist/book/book_action/book_action.dart';

/// 通过Redux提供的combineReducers方法，将Action和操作方法绑定
/**
* 1、combineReducers是Redux提供创建Reducer的方法。
* 2、combineReducers泛型一定要是我们在State中定义的类型。
* 3、TypedReducer是Redux提供的默认Reducer响应
* 4、TypedReducer的第一个泛型必须是State中定义的类型。
* 5、TypedReducer的第一个泛型即是我们定义的Action类型。
* 6、TypedReducer的形参就是我们在book_action.dart中的定义的具体操作方法。
* 7、dart语音中可以把方法当作参数
* 8、这样就把Action和方法操作绑定了。有点类似EventBus哦
*/
final BookReducer = combineReducers<List<Book>>([
  TypedReducer<List<Book>, AddBootAction>(_addBook),
  TypedReducer<List<Book>, DeleteBootAction>(_deleteBook),]
);


5、创建Store，将Redux和绑定到Store中，Store一般定义在Widget中,同时也包含了发送Action，所以我们创建book_list_widget.dart（包含了5，6，7）

import 'package:booklist/book/bean/book.dart';
import 'package:booklist/book/book_action/book_action.dart';
import 'package:booklist/book/state/book_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// 定义有状态的widget
class BookListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookListState();
}

/// flutter状态
class BookListState extends State<BookListWidget> {
  // 定义Redux store，包含了Reducer 第五步
  final store = new Store<BookList>(
    // 在book_state.dart中定义
  	bookReducer,
  	// 设置一个默认值
  	initialState: BookList(books: [
      Book(name: "java 1", id: 1),    ]),  );

	@override  Widget build(BuildContext context) {
    // 使用Redux提供的StoreProvider作为root Widget
    // 很重要：第六步
    return StoreProvider<BookList>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Redux使用"),
      			backgroundColor: Colors.blue[300],          ),
            body: Column(
           			 mainAxisAlignment: MainAxisAlignment.start,
              	 children: <Widget>[
             		Row(
              		 children: <Widget>[
                			RaisedButton(
                    		color: Colors.red[300],
              					child: Text("添加书籍"),
                        onPressed: () {
                          // 很重要，第七步，通过store的dispatch 发送AddbookAction
                     		store.dispatch(AddBookAction(book:
                     		Book(name:"java ${store.state.books.length + 1}",
                        id: store.state.books.length+1)
                    		));},),
                      RaisedButton(
                    		color: Colors.red[300],
                        child: Text("删除最后一本书"),
                        onPressed: () {
                           // 很重要，第七步，通过store的dispatch 发送DeletebookAction
                           store.dispatch(DeleteBookAction());},),],),
                       Expanded(
                         // 很重要，第六步
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
                         }),); },), )],),),),);  }

  String getName(BookList bookList, int position) {
    return bookList.books[position].name;  }
}

四、结束语

Redux的思路和使用方法同Eventbus类似，只是他两解决的问题领域不同步，EventBus重点是解决跨线程通信，Redux重点是解决状态更新后，如何刷新UI，加入没有Redux，如果我们的页面有很多状态，每个都需要调用setState去更新，你想象也行代码复杂度得多大

思考：Redux的使用有些模块类型的，是不是有办法通过类型java apt的方式自动生成呢？


