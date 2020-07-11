import 'dart:core';
import 'package:drop_chip/Navigation_Bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class recipe extends StatefulWidget with NavigationStates {
  final String img;
  final String ingredients;
  final String instructions;
  final String title;
  final String cookTime;
  final String prepTime;
  final String date;
  final String uid;
  final String cID;

  recipe(
      {Key key, this.img, this.ingredients, this.instructions, this.title, this.cookTime, this.prepTime,this.date,this.uid,this.cID})
      : super(key: key);

  @override
  _recipeState createState() => _recipeState();
}

class _recipeState extends State<recipe> {
  static final GlobalKey<FormFieldState<String>> _searchFormKey = GlobalKey<FormFieldState<String>>();
  int _selectedIndex = 0;
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.transparent,
            ),
            Container(
                height: screenHeight * .35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromRGBO(234, 158, 141, 1.0)
                )
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 35),
              child: InkWell(
                child: Icon(Icons.arrow_back, color: Colors.white,),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
                left: screenWidth / 2 + 35.0,
                bottom: screenHeight - 165,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: NetworkImage(widget.img),
                        fit: BoxFit.cover,
                      )
                  ),
                )
            ),
            Positioned(
              top: 190.0,
                child: Container(
                    width: screenWidth,
                    height: screenHeight - 190.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                      ),
                    ),
                    child: GestureDetector(
                            onHorizontalDragEnd: (DragEndDetails details) {
                              if (details.primaryVelocity == 0) {
                                //just a tap
                              }
                              else if (details.primaryVelocity.compareTo(0) == -1) {
                                if (_selectedIndex != 1) {
                                  setState(() {
                                    _selectedIndex += 1;
                                  });
                                }
                              }
                              else if (details.primaryVelocity.compareTo(0) == 1) {
                                if (_selectedIndex != 0) {
                                  setState(() {
                                    _selectedIndex -= 1;
                                  });
                                }
                              }
                            },
                        child: pageBuild(context))
                ),
            ),
          ],
        ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: GNav(
                gap: 16,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Color.fromRGBO(175, 155, 155, 1.0),
                tabs: [
                  GButton(
                    icon: Icons.assignment,
                    text: 'Recipe',
                  ),
                  GButton(
                    icon: Icons.comment,
                    text: 'Comments',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
  Widget pageBuild(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    if (_selectedIndex == 0) {
      return ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: screenWidth * .75,
                  child: Text(widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 25),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Cook Time: ", style: TextStyle(color: Colors
                      .black, fontSize: 15),),
                  SizedBox(
                    width: screenWidth * .33,
                    child: Text(widget.cookTime, style: TextStyle(
                        fontWeight: FontWeight.w600),),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Prep Time: ", style: TextStyle(color: Colors
                      .black, fontSize: 15),),
                  SizedBox(
                    width: screenWidth * .33,
                    child: Text(widget.prepTime, style: TextStyle(
                        fontWeight: FontWeight.w600),),
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth * .55,
                  height: null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular((40)),
                        topLeft: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(widget.ingredients, style: TextStyle(
                        fontSize: 17),),
                  ),
                ),
                Container(
                  width: screenWidth * .75,
                  height: null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular((40)),
                        topLeft: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(widget.instructions, style: TextStyle(
                        fontSize: 17),),
                  ),
                ),
                SizedBox(height:30),
              ],
            ),
          ]
      );
    }
    if (_selectedIndex == 1) {
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Comments').where('RecipeName',isEqualTo: widget.date.toString()).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading...');
        default:
          return Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: screenWidth * .75,
                      child: Text("Comments",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 25),
                      ),
                    ),
                  ]
              ),
              FlatButton(
                child: Text("Make comment"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => makeComment(recipeName: widget.date,uid:widget.cID)),
                  );
                },
              ),
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: snapshot.data.documents.map((DocumentSnapshot doc) {
                return Column(
                  children: <Widget>[
                    commentBuilder(doc, context),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(doc['comment'])
                    ),
                  ],
                );
              }).toList(),
              ),
            ],
          );
        }
          }
      );
    }
  }
  Widget commentBuilder(DocumentSnapshot doc, BuildContext context){
    String photo = "https://firebasestorage.googleapis.com/v0/b/dropchip.appspot.com/o/no_profile.png?alt=media&token=ff09bbcb-35bf-4643-abb8-3772bb692ae9";
    String userName = "Anon";
    return FutureBuilder(
      future: Firestore.instance.collection('UserProfiles').document(doc['uid']).get().then((data) {
          photo = data['photoImage'];
          userName = data['UserName'];
      }),
      initialData: Text("Loading"),
      builder: (context,snapshot){
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(
                      image:NetworkImage(
                        photo
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            Text(userName, style: TextStyle(fontSize: 15),),
          ],
        );
      }
    );
  }
}

class enableDelete extends StatefulWidget with NavigationStates {
  final String img;
  final String ingredients;
  final String instructions;
  final String title;
  final String cookTime;
  final String prepTime;
  final String uid;
  final String cUID;
  final String date;

  enableDelete(
      {Key key, this.img, this.ingredients, this.instructions, this.title, this.cookTime, this.prepTime, this.uid, this.date,this.cUID})
      : super(key: key);

  @override
  _enableDeleteState createState() => _enableDeleteState();
}

class _enableDeleteState extends State<enableDelete> {
  int _selectedIndex = 0;
    Widget build(BuildContext context) {
      final screenHeight = MediaQuery
          .of(context)
          .size
          .height;
      final screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.transparent,
            ),
            Container(
                height: screenHeight * .35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromRGBO(234, 158, 141, 1.0)
                )
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 35),
              child: InkWell(
                child: Icon(Icons.arrow_back, color: Colors.white,),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
                left: screenWidth / 2 + 35.0,
                bottom: screenHeight - 165,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: NetworkImage(widget.img),
                        fit: BoxFit.cover,
                      )
                  ),
                )
            ),
            Positioned(
              top: 190.0,
              child: Container(
                  width: screenWidth,
                  height: screenHeight - 190.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)
                    ),
                  ),
                  child: GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity == 0) {
                          //just a tap
                        }
                        else if (details.primaryVelocity.compareTo(0) == -1) {
                          if (_selectedIndex != 1) {
                            setState(() {
                              _selectedIndex += 1;
                            });
                          }
                        }
                        else if (details.primaryVelocity.compareTo(0) == 1) {
                          if (_selectedIndex != 0) {
                            setState(() {
                              _selectedIndex -= 1;
                            });
                          }
                        }
                      },
                      child: pageBuild(context))
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40)),
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
              ]),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 8),
              child: GNav(
                  gap: 16,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Color.fromRGBO(175, 155, 155, 1.0),
                  tabs: [
                    GButton(
                      icon: Icons.assignment,
                      text: 'Recipe',
                    ),
                    GButton(
                      icon: Icons.comment,
                      text: 'Comments',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
      );
    }
    Widget pageBuild(BuildContext context) {
      final screenHeight = MediaQuery
          .of(context)
          .size
          .height;
      final screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      if (_selectedIndex == 0) {
        return ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: screenWidth * .75,
                    child: Text(widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 25),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Cook Time: ", style: TextStyle(color: Colors
                        .black, fontSize: 15),),
                    SizedBox(
                      width: screenWidth * .33,
                      child: Text(widget.cookTime, style: TextStyle(
                          fontWeight: FontWeight.w600),),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Prep Time: ", style: TextStyle(color: Colors
                        .black, fontSize: 15),),
                    SizedBox(
                      width: screenWidth * .33,
                      child: Text(widget.prepTime, style: TextStyle(
                          fontWeight: FontWeight.w600),),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: screenWidth * .55,
                    height: null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular((40)),
                          topLeft: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.ingredients, style: TextStyle(
                          fontSize: 17),),
                    ),
                  ),
                  Container(
                    width: screenWidth * .75,
                    height: null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular((40)),
                          topLeft: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.instructions, style: TextStyle(
                          fontSize: 17),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom:15),
                    child: Container(
                      width: screenWidth * .75,
                      height: screenHeight *.08,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(214, 69, 80, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Firestore.instance.collection("UserRecipes").document(widget.date).delete();
                        },
                        child: Text("Delete Recipe"),
                      ),
                    ),
                  ),
                  SizedBox(height:50),
                ],
              ),
            ]
        );
      }
      if (_selectedIndex == 1) {
        return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Comments').where('RecipeName',isEqualTo: widget.date.toString()).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: screenWidth * .75,
                              child: Text("Comments",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25),
                              ),
                            ),
                          ]
                      ),
                      FlatButton(
                        child: Text("Make comment"),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => makeComment(recipeName: widget.date,uid:widget.cUID)),
                          );
                        },
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data.documents.map((DocumentSnapshot doc) {
                          return Column(
                            children: <Widget>[
                              commentBuilder(doc, context),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: Text(doc['comment'])
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  );
              }
            }
        );
      }
    }
    Widget commentBuilder(DocumentSnapshot doc, BuildContext context){
      String photo = "https://firebasestorage.googleapis.com/v0/b/dropchip.appspot.com/o/no_profile.png?alt=media&token=ff09bbcb-35bf-4643-abb8-3772bb692ae9";
      String userName = "Anon";
      return FutureBuilder(
          future: Firestore.instance.collection('UserProfiles').document(doc['uid']).get().then((data) {
            photo = data['photoImage'];
            userName = data['UserName'];
          }),
          initialData: Text("Loading"),
          builder: (context,snapshot){
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      image: DecorationImage(
                          image:NetworkImage(
                              photo
                          ),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
                Text(userName, style: TextStyle(fontSize: 15),),
              ],
            );
          }
      );
    }
}
class makeComment extends StatelessWidget{
  final String uid;
  final String recipeName;
  makeComment({Key key, this.uid,this.recipeName}) : super (key:key);
  FocusNode node1 = new FocusNode();
  TextEditingController comment = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(234, 158, 141, 1.0),
        actions: <Widget>[
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40,horizontal: 15),
        child: TextField(
          onTap: (){
            node1.requestFocus();
          },
          controller: comment,
          style: TextStyle(color: Colors.black, fontSize: 18),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration.collapsed(hintText: "Enter comment", hintStyle:TextStyle(
              color: Colors.grey, fontSize: 18
          )),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30.0, vertical: 8),
            child: FlatButton(
              focusNode: node1,
              child: Text("Submit comment"),
              onPressed: (){
                submitComment();
                Navigator.pop(context);
              },
            )
          ),
        ),
      ),
    );
  }
  Widget submitComment(){
    return FutureBuilder(
      future: Firestore.instance.collection('Comments').add({
        'comment':comment.text,
        'uid':uid,
        'RecipeName':recipeName
      }), builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Row(
        );
    },
    );
  }
}