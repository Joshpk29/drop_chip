import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Navigation_Bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe.dart';
import 'package:image_picker/image_picker.dart';


class settings extends StatefulWidget with NavigationStates{
  final Function onMenuTap;
  final String email;
  final String password;
  final String uid;
  settings({Key key, this.onMenuTap,@required this.email, @required this.password, @required this.uid}) : super(key: key);

  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  String searchTerm;
  String situationTerm;
  TextEditingController ingedientSearch = new TextEditingController();
  String searchIngredient = "";
  String orderBy = 'Date';
  String type = "Your Posts";
  bool myPosts = true;
  final FirebaseStorage storage = new FirebaseStorage(storageBucket: 'gs://dropchip.appspot.com/');
  StorageUploadTask uploadTask;
  String url;
  final databaseReference = Firestore.instance.collection('UserProfiles');
  File img;
  Future<void> imagePicker(ImageSource Source) async{
    File image = await ImagePicker.pickImage(source: Source);
    setState(() {
      img = image;
    });
    startUpload();
  }
  void submitValue(String pUrl){
    if(pUrl.isEmpty){
    }
    else {
      databaseReference.document(widget.uid).updateData({
        'photoImage': pUrl
      });
    }
  }
  void startUpload() async{
    String filepath = '${DateTime.now()}.png';
    setState(() {
      uploadTask = storage.ref().child(filepath).putFile(img);
    });
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      url = downUrl.toString();
    });
    submitValue(url);
  }


  Widget profileImage(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('UserProfiles').document(widget.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> document) {
          if(document.hasError){
            return Container(
              height: screenHeight * .30,
              width: screenWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage('Assets/front_page_IMG.jpg'),
                    fit: BoxFit.cover,
                  )
              ),
              child: MaterialButton(
                onPressed: (){
              return showDialog(context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      content: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: MaterialButton(
                              child: Text("From Gallery"),
                              onPressed: (){
                                imagePicker(ImageSource.gallery);
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: MaterialButton(
                              child: Text("Use Camera"),
                              onPressed: (){
                                imagePicker(ImageSource.camera);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            },
          ),
            );
          }
          switch(document.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
              break;
            default:
          return Container(
            width: screenWidth,
            height: screenHeight * .30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(document.data['photoImage']),
                  fit: BoxFit.cover,
                )
            ),
            child: MaterialButton(
                onPressed: (){
                  return showDialog(context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        content: Row(
                         children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            child: Text("From Gallery"),
                            onPressed: (){
                              imagePicker(ImageSource.gallery);
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            child: Text("Use Camera"),
                            onPressed: (){
                              imagePicker(ImageSource.camera);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
            );
          },
          ),
          );
          break;
        }
        }
    );
  }

  Widget build(BuildContext context){
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.transparent,
        ),
        profileImage(context),
        Container(
          padding: const EdgeInsets.only(left: 16,right:16, top:35),
          child:InkWell(
            child:Icon(Icons.menu, color:Colors.white),
            onTap: () {
              widget.onMenuTap();
              searchIngredient = "";
            },
          ),
        ),
        Positioned(
          left:screenWidth*.25,
          top: screenHeight*.20,
          child: Container(
            height:screenHeight * .75,
            width: screenWidth*.77,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), bottomLeft: Radius.circular(25.0),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 4.0,
                    color: Colors.grey.withOpacity(.2),
                    spreadRadius: 4.0,
                    offset: Offset(0.0, -0.2)
                )
              ],
            ),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 4,
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: (){
                          return showDialog(context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content: Container(
                                      height: 130.0,
                                      child: ListView(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text("Your Posts"),
                                            onPressed: () {
                                              setState(() {
                                                type = "Your Posts";
                                                myPosts = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Liked Posts"),
                                            onPressed: () {
                                              setState(() {
                                                type = "Liked Posts";
                                                myPosts = false;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                );
                              }
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, bottom:10),
                          child: Text(type,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit:FlexFit.loose,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed:() {
                          return showDialog(context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content: Container(
                                      height: MediaQuery.of(context).size.height*.50,
                                      child: ListView(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text("Breakfast"),
                                            onPressed: () {
                                              setState(() {
                                                searchTerm = "Breakfast";
                                              });

                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Lunch"),
                                            onPressed: () {
                                              setState(() {
                                                searchTerm = "Lunch";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Snack"),
                                            onPressed: () {
                                              setState(() {
                                                searchTerm = "Snack";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Appitizer"),
                                            onPressed: () {
                                              setState(() {
                                                searchTerm = "Appitizer";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Dinner"),
                                            onPressed: () {
                                              setState(() {
                                                searchTerm = "Dinner";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Dessert"),
                                            onPressed: () {
                                              setState(() {
                                                searchTerm = "Dessert";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("None"),
                                            onPressed: () {
                                              setState(() {
                                                searchTerm = null;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                );
                              }
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: myPosts?true:false,
                      child: Flexible(
                          flex: 1,
                          fit:FlexFit.loose,
                          child: IconButton(
                            icon: Icon(Icons.collections),
                            onPressed:() {
                              return showDialog(context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Container(
                                          height: 150.0,
                                          child: ListView(
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text("Date"),
                                                onPressed: () {
                                                  setState(() {
                                                    orderBy = "Date";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Visibility(
                                                visible: myPosts ? true : false,
                                                child: FlatButton(
                                                  child: Text("Liked"),
                                                  onPressed: () {
                                                    setState(() {
                                                      orderBy = "Likes";
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    );
                                  }
                              );
                            },
                          ),
                        ),
                    ),
                    Flexible(
                      flex: 1,
                      fit:FlexFit.loose,
                      child: IconButton(
                        icon: Icon(Icons.chrome_reader_mode),
                        onPressed:() {
                          return showDialog(context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content: Container(
                                      height: 150.0,
                                      child: Column(
                                        children: <Widget>[
                                          TextField(
                                            decoration: InputDecoration(labelText: "enter ingredients (eggs,sugar,flour)",
                                                labelStyle: TextStyle(color: Colors.grey,fontSize: 10, fontWeight: FontWeight.w100)
                                            ),
                                            controller: ingedientSearch,
                                            onSubmitted: (text){
                                              setState(() {
                                                searchIngredient = text;
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                          SizedBox(height: 15),
                                          Padding(
                                            padding: EdgeInsets.only(bottom:15),
                                            child: Container(
                                              width: 300,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(214, 69, 80, 1.0),
                                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                              ),
                                              child: FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    ingedientSearch.clear();
                                                    searchIngredient = "";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Clear"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                );
                              }
                          );
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit:FlexFit.loose,
                      child: IconButton(
                        icon: Icon(Icons.fastfood),
                        onPressed:() {
                          return showDialog(context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content: Container(
                                      height: 300.0,
                                      child: ListView(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text("Cook Out"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Cook Out";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Date Night"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Date Night";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Dinner Party"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Dinner Party";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Dress to Impress"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Dress to Impress";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Drunk"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Drunk";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Healthy"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Healthy";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Hungover"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Hungover";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("I'm Hangry"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "I'm Hangry";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("I Need a Hug"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "I Need a Hug";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("None"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = null;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Quick, Easy and Cheap"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Quick, Easy and Cheap";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Sporting Event"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Sporting Event";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Vegetarian"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Vegetarian";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Vegan"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Vegan";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Weekday Meal"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Weekday Meal";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Weekend Treat"),
                                            onPressed: () {
                                              setState(() {
                                                situationTerm = "Weekend Treat";
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                );
                              }
                          );
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left:25.0, bottom:10.0),
                  child: Container(
                      height:screenHeight*.55,
                      width: 310.0,
                      child: myPosts? recipeItem(context) : LikedItem(context)
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget LikedItem(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Likes').where('uid',isEqualTo: widget.uid).snapshots(),
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('No Recipes Found');
          default:
            return ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return likedBuilder(document, context);
            }).toList()
            );
        }
      },
    );
  }
  Widget likedBuilder(DocumentSnapshot document, BuildContext context){
    String img = "https://firebasestorage.googleapis.com/v0/b/dropchip.appspot.com/o/no_profile.png?alt=media&token=ff09bbcb-35bf-4643-abb8-3772bb692ae9";
    String title = "Loading";
    String cookTime = "loading";
    String ingredients = "loading...";
    String instructions = "Loading...";
    String prepTime = "loading";
    String uid = "loading...";
    String Date = "Loading...";
    int Likes = 0;
    String Tag = "Loading..";
    String situation = "Loading...";
    return FutureBuilder(
        future: Firestore.instance.collection('UserRecipes').document(document['RecipeName']).get().then((data){
          img = data['photo_url'];
          title = data['Title'];
          cookTime = data['Cook Time'];
          ingredients = data['ingredients'];
          instructions = data['instructions'];
          prepTime = data['Prep Time'];
          uid = data['uid'];
          Date = data['Date'];
          Likes = data['Likes'];
          Tag = data['Tag'];
          situation = data['Situation'];
        }),
        initialData: Text("Loading"),
        builder: (context,snapshot){
          bool inList = false;
          bool situationType = (situationTerm==null || situation.contains(situationTerm))?true:false;
          bool inMealType = (searchTerm == null || Tag==searchTerm )?true:false;
          List<String> ingredientsList = ingredientParse(searchIngredient);
          for(String x in ingredientsList){
            if(ingredients.contains(x)) {
              inList = true;
              break;
            }
          }
          if(inList&&inMealType&&situationType) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      enableDelete(
                        img: img,
                        ingredients: ingredients,
                        instructions: instructions,
                        title: title,
                        cookTime: cookTime,
                        prepTime: prepTime,
                        uid: uid,
                        date: Date,
                        cUID: widget.uid,
                      )),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10.0, bottom: 10.0),
                child: Stack(
                  children: [
                    Container(
                      height: 275.0,
                      width: 200,
                    ),
                    Positioned(
                        top: 7.0,
                        child: Container(
                          height: 250.0,
                          width: 175.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color.fromRGBO(234, 158, 141, 1.0)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(title,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text("Prep Time: " + prepTime,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text("Cook Time: " + cookTime,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: <Widget>[
                                    isLiked(Date, context),
                                    Text(Likes.toString(), style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200
                                    ),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    Positioned(
                      left: 90.0,
                      child: Hero(
                        tag: img,
                        child: Container(
                          height: 110.0,
                          width: 110.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: NetworkImage(img),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          else{
            return Container();
          }
        }
    );
  }

  Widget recipeItem(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('UserRecipes').orderBy(orderBy,descending: true).where("uid",isEqualTo: widget.uid).where('Tag',isEqualTo: searchTerm).where('Situation',isEqualTo: situationTerm).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('No Recipes Found');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                bool inList = false;
                List<String> ingredientsList = ingredientParse(searchIngredient);
                for(String x in ingredientsList){
                  if(document['ingredients'].toString().contains(x)) {
                    inList = true;
                    break;
                  }
                }
                if(inList) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            enableDelete(
                              img: document['photo_url'],
                              ingredients: document['ingredients'],
                              instructions: document['instructions'],
                              title: document['Title'],
                              cookTime: document['Cook Time'],
                              prepTime: document['Prep Time'],
                              uid: document['uid'],
                              date: document['Date'],
                              cUID: widget.uid,
                            )),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 10.0, bottom: 10.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 275.0,
                            width: 200,
                          ),
                          Positioned(
                              top: 7.0,
                              child: Container(
                                height: 250.0,
                                width: 175.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Color.fromRGBO(234, 158, 141, 1.0)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0),
                                      child: Text(document['Title'],
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0),
                                      child: Text(
                                        "Prep Time: " + document['Prep Time'],
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0),
                                      child: Text(
                                        "Cook Time: " + document['Cook Time'],
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: <Widget>[
                                          isLiked(document['Date'], context),
                                          Text(document['Likes'].toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w200
                                            ),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                          Positioned(
                            left: 90.0,
                            child: Hero(
                              tag: document['photo_url'],
                              child: Container(
                                height: 110.0,
                                width: 110.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          document['photo_url']),
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                else{
                  return Container();
                }
              }).toList(),
            );
        }
      },
    );
  }
  Widget isLiked(String recipeName, BuildContext context){
    Color likedColor = Colors.black;
    IconData likedIcon = Icons.favorite_border;
    String id = widget.uid;
    String likeID = '$recipeName$id';
    bool liked = false;
    return FutureBuilder(
      future: Firestore.instance.collection('Likes').document(likeID).get().then((data){
        if(data['uid'] == id && data['RecipeName'] == recipeName) {
          likedColor = Colors.redAccent;
          likedIcon = Icons.favorite;
          liked = true;
        }
      }),
      initialData: Icon(Icons.favorite_border, size: 18,),
      builder: (context, AsyncSnapshot snapshot){
        return IconButton(
          icon: Icon(
              likedIcon,
              size: 30,
              color: likedColor
          ),
          onPressed: (){
            if(liked == true){
              Firestore.instance.collection('Likes').document(likeID).delete();
              Firestore.instance.collection('UserRecipes').document(recipeName).updateData({
                'Likes':FieldValue.increment(-1)
              });
              liked = false;
            }
            else if(liked == false){
              Firestore.instance.collection('Likes').document(likeID).setData({
                'uid':id,
                'RecipeName':recipeName
              });
              Firestore.instance.collection('UserRecipes').document(recipeName).updateData({
                'Likes':FieldValue.increment(1)
              });
              liked = true;
            }
          },
        );
      },
    );
  }
  List<String> ingredientParse(String ingredientList){
    var ingredients = ingredientList.toString().split(',');
    return ingredients;
  }
}