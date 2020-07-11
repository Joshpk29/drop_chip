import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drop_chip/Navigation_Bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

TextEditingController title = new TextEditingController();
TextEditingController prepTime= new TextEditingController();
TextEditingController cookTime= new TextEditingController();
TextEditingController servingSize =new TextEditingController();
TextEditingController ingredients= new TextEditingController();
TextEditingController instructions =new TextEditingController();
TextEditingController Tag =new TextEditingController();
TextEditingController situation = new TextEditingController();


class Uploader extends StatefulWidget{
  final File img;
  final String uid;
  Uploader({Key key, this.img, @required this.uid}) : super(key: key);
  @override
  createState() => UploaderState();

}
class UploaderState extends State<Uploader>{
  final FirebaseStorage storage = new FirebaseStorage(storageBucket: 'gs://dropchip.appspot.com/');
  StorageUploadTask uploadTask;
  String url;
  final databaseReference = Firestore.instance.collection('UserRecipes');

  void clear(){
   title.clear();
   prepTime.clear();
   cookTime.clear();
   servingSize.clear();
   ingredients.clear();
   instructions.clear();
   Tag.clear();
   situation.clear();
  }
  void submitValue(String t,String pTime, String cTime, String ingr, String instr, String pUrl,String tag,String situation){
    DateTime date = DateTime.now();
    if(t.isEmpty ||pTime.isEmpty ||cTime.isEmpty || cTime.isEmpty || ingr.isEmpty || instr.isEmpty || pUrl.isEmpty || tag.isEmpty || situation.isEmpty){
    }
    else {
      String dateName = date.toString();
      databaseReference.document(dateName).setData({
        'Title': t,
        'Prep Time': pTime,
        'Cook Time': cTime,
        'photo_url': pUrl,
        'ingredients': ingr,
        'instructions': instr,
        'uid': widget.uid,
        'Date': date.toString(),
        'Tag': tag,
        'Likes':0,
        'Situation': situation
      });
    }
  }
  //Future<Widget>
  void startUpload() async{
    String filepath = '${DateTime.now()}.png';
    setState(() {
      uploadTask = storage.ref().child(filepath).putFile(widget.img);
    });
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      url = downUrl.toString();
    });
    submitValue(title.text, prepTime.text, cookTime.text, ingredients.text, instructions.text, url,Tag.text,situation.text);
    clear();
    BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.DiscoverPageClicked);
  }

  Widget build(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialButton(
      color: Color.fromRGBO(250, 168, 168, 1.0),
      onPressed: (){
        startUpload();
        },
      child:Container(
        width: screenWidth*.75,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        child:Text("Upload Form",style: TextStyle(color: Colors.white, fontSize: 15.0),),
      )
    );
  }
}

class ImageCapture extends StatefulWidget{
  final String uid;
  ImageCapture({Key key,@required this.uid}) : super(key : key);
  @override
  createState() => ImageCaptureState();
}
class ImageCaptureState extends State<ImageCapture>{
  File img;
  Future<void> imagePicker(ImageSource Source) async{
      File image = await ImagePicker.pickImage(source: Source);
      setState(() {
          img = image;
      });
  }
  Widget photoExists(){
    if(img == null){
      return MaterialButton(
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
        child: Container(
          height: 200,
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text("Add Photo", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w300),),
        ),
      );
    }
    return MaterialButton(
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
      child: Container(
        height: 200,
        width: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(
                img
              )
            )
        ),
      ),
    );
  }
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: photoExists(),
            ),
      ]
    ),
        SizedBox(height: 10,),
        Uploader(img: img,uid: widget.uid,)
    ]
    );
  }
}
class addRecipePage extends StatefulWidget with NavigationStates{
  final Function onMenuTap;
  final String uid;
  addRecipePage({Key key, this.onMenuTap, @required this.uid}) : super(key: key);
  createState() => addRecipePageState();
}

class addRecipePageState extends State<addRecipePage>{
  int _selectedIndex = 0;
  FocusNode nodeOne = new FocusNode();
  FocusNode nodeTwo = new FocusNode();

  Widget pageBuild(BuildContext context){
    if(_selectedIndex == 0){
      return Container(
        padding: EdgeInsets.symmetric(horizontal:15,vertical:75),
        child: ListView(
            children: <Widget>[
              TextField(
                controller: title,
                style: TextStyle(color:Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
                decoration: InputDecoration(labelText: "Title ",
                  labelStyle: TextStyle(color: Colors.grey,fontSize: 15, fontWeight: FontWeight.w300)
                ),
              ),
              TextField(
                controller: prepTime,
                style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
                decoration: InputDecoration(labelText: "Prep Time ",
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 10, fontWeight: FontWeight.w100)
                ),
              ),
              TextField(
                controller: cookTime,
                style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
                decoration: InputDecoration(labelText: "Cook Time ",
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 10, fontWeight: FontWeight.w100)
                ),
              ),
              TextField(
                controller: servingSize,
                style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
                decoration: InputDecoration(labelText: "Serving Size ",
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 10, fontWeight: FontWeight.w100)
                ),
              ),
              TextField(
                onTap: (){
                  return showDialog(context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: ListView(
                            children: <Widget>[
                              FlatButton(
                                child: Text("Breakfast"),
                                onPressed: (){
                                  Tag.text = "Breakfast";
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Lunch"),
                                onPressed: (){
                                  Tag.text = "Lunch";
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Snack"),
                                onPressed: (){
                                  Tag.text = "Snack";
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Appitizer"),
                                onPressed: (){
                                  Tag.text = "Appitizer";
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Dinner"),
                                onPressed: (){
                                  Tag.text = "Dinner";
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Dessert"),
                                onPressed: (){
                                  Tag.text = "Dessert";
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          )
                        );
                      }
                  );
                },
                readOnly: true,
                enableInteractiveSelection: false,
                keyboardAppearance: null,
                controller: Tag,
                style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
                decoration: InputDecoration(labelText: "Tag",
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 10, fontWeight: FontWeight.w100)
                ),
              ),
              TextField(
                onTap: (){
                  return showDialog(context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                            content: ListView(
                              children: <Widget>[
                                FlatButton(
                                  child: Text("Cook Out"),
                                  onPressed: (){
                                    situation.text = "Cook Out";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Date Night"),
                                  onPressed: (){
                                    situation.text = "Date Night";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Dinner Party"),
                                  onPressed: (){
                                    situation.text = "Dinner Party";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Dress to Impress"),
                                  onPressed: (){
                                    situation.text = "Dress to Impress";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Drunk"),
                                  onPressed: (){
                                    situation.text = "Drunk";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Healthy"),
                                  onPressed: (){
                                    situation.text = "Healthy";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Hungover"),
                                  onPressed: (){
                                    situation.text = "Hungover";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("I'm Hangry"),
                                  onPressed: (){
                                    situation.text = "I'm Hangry";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("I Need a Hug"),
                                  onPressed: (){
                                    situation.text = "I Need a Hug";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Quick, Easy and Cheap"),
                                  onPressed: (){
                                    situation.text = "Quick, Easy and Cheap";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Sporting Event"),
                                  onPressed: (){
                                    situation.text = "Sporting Event";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Vegetarian"),
                                  onPressed: (){
                                    situation.text = "Vegetarian";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Vegan"),
                                  onPressed: (){
                                    situation.text = "Vegan";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Weekday Meal"),
                                  onPressed: (){
                                    situation.text = "Weekday Meal";
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Weekend Treat"),
                                  onPressed: (){
                                    situation.text = "Weekend Treat";
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                        );
                      }
                  );
                },
                readOnly: true,
                enableInteractiveSelection: false,
                keyboardAppearance: null,
                controller: situation,
                style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
                decoration: InputDecoration(labelText: "Situation",
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 10, fontWeight: FontWeight.w100)
                ),
              ),
            ],
          ),
      );
    }
    if(_selectedIndex  == 1){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 75),
        child: TextField(
          focusNode: nodeTwo,
          onTap:(){
            FocusScope.of(context).requestFocus(nodeOne);
            },
          controller: ingredients,
          maxLines: null,
          style: TextStyle(color: Colors.black, fontSize: 18),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration.collapsed(hintText: "Enter Ingredients", hintStyle:TextStyle(
            color: Colors.grey, fontSize: 18
          )),
        ),
      );
    }
    if(_selectedIndex  == 2){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 75),
        child: TextField(
          onTap: (){
            FocusScope.of(context).requestFocus(nodeTwo);
          },
          focusNode: nodeOne,
          controller: instructions,
          maxLines: null,
          style: TextStyle(color: Colors.black, fontSize: 18),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration.collapsed(hintText: "Enter Instructions", hintStyle:TextStyle(
              color: Colors.grey, fontSize: 18
          )),
        ),
      );
    }
    else{
      return Positioned(
        top:150,
        child: Container(
          height: MediaQuery.of(context).size.height - 150,
            width: MediaQuery.of(context).size.width,
            child: ImageCapture(uid: widget.uid,)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                  ),
                ),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 16,right:16, top:35),
                  child:InkWell(
                    child:Icon(Icons.menu, color:Color.fromRGBO(175, 155, 155, 1.0)),
                    onTap: widget.onMenuTap,
                  ),
                ),
                Container(
                  child: pageBuild(context),
                )
              ],
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
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Color.fromRGBO(175, 155, 155, 1.0),
                tabs: [
                  GButton(
                    icon: Icons.title,
                    text: 'Title',
                  ),
                  GButton(
                    icon: Icons.apps,
                    text: 'Ingredients',
                  ),
                  GButton(
                    icon: Icons.assignment,
                    text: 'Instructions',
                  ),
                  GButton(
                    icon: Icons.photo_camera,
                    text: 'Photo',
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
}