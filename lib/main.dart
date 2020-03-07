import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app1/new_todo.dart';
import 'package:todo_app1/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LargeButton.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comments',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Todo> items = new List<Todo>();

 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Comments',
            key: Key('main-app-title'),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.chat),
          label: Text("Ask"),
          onPressed: () => goToNewItemView(),
        ),
        body: renderBody());
  }

  Widget renderBody() {
    if (items.length > 0) {
      return buildListView();
    } else {
      return emptyList();
    }
  }

  Widget emptyList() {
    return Center(child: Text('No items'));
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return buildItem(items[index], index);
      },
    );
  }

  Widget buildItem(Todo item, index) {
    return Dismissible(
      key: Key('${item.hashCode}'),
      background: Container(color: Colors.red[700]),
      onDismissed: (direction) => _removeItemFromList(item),
      direction: DismissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(item, index) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              child: new Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    image: new NetworkImage(
                        "https://www.kindpng.com/picc/m/24-248729_stockvader-predicted-adig-user-profile-image-png-transparent.png"),
                  ),
                ),
              ),
            ),
            title: Text("User"),
            subtitle: new Row(
              children: [
                new Text("10:20"),
                new Icon(
                  Icons.public,
                  size: 15.0,
                )
              ],
            ),
            trailing: new Icon(Icons.more_horiz),
          ),
          ListTile(
            title: Text(
              item.title,
              key: Key('item-$index'),
              style: TextStyle(
                  color: item.completed ? Colors.grey : Colors.black,
                  decoration:
                      item.completed ? TextDecoration.lineThrough : null),
            ),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Container(
            padding: new EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                  child: LargeButton(
                    iconData: Icons.thumb_up,
                    label: "Like",
                    color: Colors.grey,
                  ),
                  onTap: (){
                    setState(() {
                      Colors.red;
                    });
                  },
                ),
                new GestureDetector(
                  child: LargeButton(
                    iconData: Icons.chat,
                    label: "Comment",
                    color: Colors.grey,
                  ),
                  onTap: () => goToEditItemView(item),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }



  void changeItemCompleteness(Todo item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  void goToNewItemView() {
    // Here we are pushing the new view into the Navigator stack. By using a
    // MaterialPageRoute we get standard behaviour of a Material app, which will
    // show a back button automatically for each platform on the left top corner
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView();
    })).then((title) {
      if (title != null) {
        addItem(Todo(title: title));
      }
    });
  }

  void addItem(Todo item) {
    // Insert an item into the top of our list, on index zero
    items.insert(0, item);
  }

  void goToEditItemView(item) {
    // We re-use the NewTodoView and push it to the Navigator stack just like
    // before, but now we send the title of the item on the class constructor
    // and expect a new title to be returned so that we can edit the item
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView(item: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item, String title) {
    item.title = title;
  }

  void _removeItemFromList(item) {
    deleteItem(item);
  }

  void deleteItem(item) {
    // We don't need to search for our item on the list because Dart objects
    // are all uniquely identified by a hashcode. This means we just need to
    // pass our object on the remove method of the list
    items.remove(item);
  }
}
