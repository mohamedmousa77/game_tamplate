import 'package:drag_drop_game/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
typedef OnError = void Function(Exception exception);

class _HomeScreenState extends State<HomeScreen> {
  var player = AudioPlayer();
  List<ItemModel> items2 = [];
  late List<ItemModel> items;
  int score = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    // vertical: MediaQuery.of(context).size.height*0.
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Text.rich(TextSpan(children: [
                  const TextSpan(
                      text: 'score: ',
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                  TextSpan(
                      text: '$score',
                      style:
                          const TextStyle(color: Colors.green, fontSize: 45)),
                ])),
              ),
              !gameOver
                  ? Row(
                      children: [
                        Spacer(),
                        Column(
                            children: items.map((item) {
                          return Container(
                            margin: EdgeInsets.all(MediaQuery.of(context).size.height*0.01),
                            child: Draggable<ItemModel>(
                              data: item,
                              childWhenDragging: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(item.img),
                                backgroundColor: Colors.white,
                              ),
                              feedback: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(item.img),
                                backgroundColor: Colors.white,
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(item.img),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          );
                        }).toList()),
                        Spacer(flex: 2),
                        Column(
                          children: items2.map((item) {
                            return DragTarget<ItemModel>(
                            onAccept: (receivedItem) async {
                              if(item.value == receivedItem.value){

                                setState(() {
                                  items.remove(receivedItem);
                                  items2.remove(item);
                                  items.isEmpty? gameOver=true:gameOver=false;

                                });

                                debugPrint(items.length.toString());
                                score += 10;
                                item.accepting = false;
                                await player.play(AssetSource('true.wav'));

                              }
                              else {
                                setState(() {
                                  score -= 5;
                                  item.accepting = false;
                                  // player.prefix='assets/false.wav';

                                });
                               await player.play(AssetSource('false.wav'));
                              }
                            },
                            onWillAccept: (receivedItem){
                              player.stop();
                              setState(() {

                                item.accepting=true;
                              });
                              return true;
                            },
                            onLeave: (receivedItem) {
                               player.stop();
                              setState(() {
                                item.accepting = false;
                              });
                            },
                                builder: (context,acceptedItem,rejectedItem)=>
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: item.accepting
                                            ? Colors.grey[400]
                                            :Colors.grey[200]
                                      ),
                                      alignment: Alignment.center,
                                      height: MediaQuery.of(context).size.width/6.5,
                                      width: MediaQuery.of(context).size.width/3,
                                      margin:const EdgeInsets.all(8),
                                      child: Text(
                                        item.name,
                                        style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                      ),
                                    ),
                            );
                          }).toList(),
                        ),
                        Spacer(),
                      ],
                    )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                              child: const Text('Game Over' ,
                                style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.w500),)),
                           Container(
                             margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                             child: Text(result().toString() ,
                             style:const TextStyle(fontSize: 30,color: Colors.grey),),
                           ),
                         GestureDetector(
                           onTap:(){
                             initGame();
                             setState(() { });
                           },
                           child: Container(
                             margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                             height:MediaQuery.of(context).size.width*0.1 ,
                             width: MediaQuery.of(context).size.width*0.4 ,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(color: Colors.green,
                             borderRadius: BorderRadius.circular(5)
                             ),
                             child:const Text('New Game',
                               style: TextStyle(fontSize: 30,color: Colors.white),),
                           ),
                         )
                ],
              ),
                    ],
                  )
            ],
          ),
        ),
      ),
    );
  }

  initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(value: 'Lion',  name: 'Lion',   img: 'assets/lion.png'),
      ItemModel(value: 'panda', name: 'Panda', img: 'assets/panda.png'),
      ItemModel(value: 'camel', name: 'Camel', img: 'assets/camel.png'),
      ItemModel(value: 'dog',   name: 'Dog',     img: 'assets/dog.png'),
      ItemModel(value: 'cat',   name: 'Cat',     img: 'assets/cat.png'),
      ItemModel(value: 'horse', name: 'Horse', img: 'assets/horse.png'),
      ItemModel(value: 'sheep', name: 'Sheep', img: 'assets/sheep.png'),
      ItemModel(value: 'hen',   name: 'Hen',     img: 'assets/hen.png'),
      ItemModel(value: 'fox',   name: 'Fox',     img: 'assets/fox.png'),
      ItemModel(value: 'cow',   name: 'Cow',     img: 'assets/cow.png'),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle(); // for display the list Randomly
  }

  String result() {
    if(score == 100){
       player.play(AssetSource('success.wav'));
      return 'Awesome!';
    }
    else{
       player.play(AssetSource('tryAgain.wav'));
      return 'Play again to get better score';
    }
  }
}
