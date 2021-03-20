import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluks_chat_app/services/auth.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';
import 'package:path/path.dart';
import 'package:pluks_chat_app/shared/shared.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthClass authClass = new AuthClass();
  final DatabaseClass databaseClass = new DatabaseClass();
  File _image;
  String name = "";
  String email = "";
  String userId = "";
  String error = '';
  String city = "";
  String country = "";
  final _key = GlobalKey<FormState>();
  TextEditingController cityController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  String userImageUrl;
  bool isLoading = false;

  @override
  void initState() {
    loadUserProfile();
    super.initState();
  }

  loadUserProfile() async {
    HelperFunctions.getUserIdSharedPreference().then((value) => setState(() {
          userId = value;
        }));
    HelperFunctions.getUserEmailSharedPreference().then((value) => setState(() {
          email = value;
        }));
    HelperFunctions.getUserNameSharedPreference().then((value) => setState(() {
          name = value;
          usernameController.text = value;
        }));
    HelperFunctions.getUserImageUrlSharedPreference()
        .then((value) => setState(() {
              userImageUrl = value;
            }));
    HelperFunctions.getUserCitySharedPreference().then((value) => setState(() {
          city = value;
          cityController.text = value;
        }));
    HelperFunctions.getUserCountrySharedPreference()
        .then((value) => setState(() {
              country = value;
              countryController.text = value;
            }));
  }

  saveProfile(BuildContext context) async {
    if (_key.currentState.validate()) {
      Map<String, String> userMap = {
        "id": userId,
        "name": usernameController.text.capitalize(),
        "email": email,
        "city": cityController.text,
        "country": countryController.text,
      };
      HelperFunctions.saveUserNameSharedPreference(usernameController.text);
      HelperFunctions.saveUserCountrySharedPreference(countryController.text);
      HelperFunctions.saveUserCitySharedPreference(cityController.text);

      try {
        await databaseClass.uploadUserInfo(userId, userMap).then((value) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Success",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                content: Text("Profile saved"),
              );
            },
          );
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget formDialog(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  controller: usernameController,
                  validator: (value) =>
                      value == '' ? 'Username can\'t be empty' : null,
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) =>
                      value == '' ? 'City can\'t be empty' : null,
                  controller: cityController,
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Country'),
                  validator: (value) =>
                      value == '' ? 'Country can\'t be empty' : null,
                  controller: countryController,
                ),
                SizedBox(height: 5),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    saveProfile(context);
                  },
                  elevation: 4,
                  splashColor: Colors.blueGrey,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future uploadFile(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      await taskSnapshot.ref.getDownloadURL().then((value) {
        setState(() {
          userImageUrl = value;
        });
        Map<String, String> userDataMap = {
          "id": userId,
          "name": name,
          "email": email,
          "city": city,
          "country": country,
          "imageUrl": userImageUrl,
        };
        databaseClass.uploadUserInfo(userId, userDataMap);
        HelperFunctions.saveUserImageUrlSharedPreference(userImageUrl);
        setState(() {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile Picture Uploaded"),
            ),
          );
        });
      });
    }

    Future getImage(context) async {
      File image = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedFile) => pickedFile.path));

      setState(() {
        _image = image;
      });
      uploadFile(context);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey,
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                )
                              : ClipOval(
                                  child: SizedBox(
                                    width: 140,
                                    height: 140,
                                    child: (userImageUrl == null)
                                        ? Image.asset(
                                            "assets/d-p.png",
                                            fit: BoxFit.fill,
                                          )
                                        : userImageUrl.isNotEmpty
                                            ? FullScreenWidget(
                                                child: Center(
                                                  child: Hero(
                                                    tag:
                                                        userImageUrl.toString(),
                                                    child: CachedNetworkImage(
                                                          imageUrl:
                                                              userImageUrl,
                                                          fit: BoxFit.fill,
                                                        ) ??
                                                        Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                ),
                                              ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: IconButton(
                          tooltip: "Change Profile Picture",
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 30,
                          ),
                          onPressed: () {
                            getImage(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 0.2,
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    "Username",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 0.2,
                ),
                ListTile(
                  title: Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    email,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 0.2,
                ),
                ListTile(
                  title: Text(
                    "Location",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "$city, $country.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            content: formDialog(context),
                          );
                        },
                      );
                    },
                    // elevation: 1,
                    splashColor: Theme.of(context).accentColor,
                    child: Icon(
                      Icons.edit,
                      // color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 0.2,
                ),
                SizedBox(height: 10),
                // RaisedButton(
                //   color: Theme.of(context).accentColor,
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) {
                //         return AlertDialog(
                //           title: Text(
                //             "Edit Profile",
                //             style: TextStyle(
                //               color: Theme.of(context).primaryColor,
                //             ),
                //           ),
                //           content: formDialog(context),
                //         );
                //       },
                //     );
                //   },
                //   elevation: 1,
                //   splashColor: Colors.blueGrey,
                //   child: Text(
                //     "Edit Profile",
                //     style: TextStyle(
                //       color: Theme.of(context).primaryColor,
                //       fontSize: 16,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
