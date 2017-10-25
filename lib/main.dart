import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';


const String _name = "vijay";

void main() {
  runApp(new TextMateApp());
}

class TextMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "TextMate",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  bool _isComposing = false;

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: new Text("Friendlychat"),
      elevation:
           Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
    body: new Container(
    child: new Column(
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                )
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(
                  color: Theme
                      .of(context)
                      .cardColor),
              child: _buildTextComposer(),
            ),
          ]
      ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? new BoxDecoration(
            border:
            new Border(top: new BorderSide(color: Colors.grey[200])))
            : null),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme
            .of(context)
            .accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    onChanged: (String text)  {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(
                        hintText: "Send a message"),
                  ),
                ),
                new Container(
                  child: Theme.of(context).platform == TargetPlatform.iOS ?
                  new CupertinoButton(
                    child: new Text("Send"),
                    onPressed: _isComposing
                        ? () =>  _handleSubmitted(_textController.text)
                        : null,) :
                  new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing ?
                      () =>  _handleSubmitted(_textController.text) :
                       null,

                ),
                )
              ]
          ),
        )
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose()
  {
    //new
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose(); //new
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOut
        ),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

