import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/Database/wishlistMovie.dart';
import 'package:movie_app/main.dart';
import 'package:movie_app/screens/sign/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyProfile(),
    );
  }
}

class MyProfile extends StatefulWidget {
  MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List<String> _imagePath = [];
  final ImagePicker _picker = ImagePicker();
  late SharedPreferences loginData;
  String? username;
  bool isFavorite = false;

  Future<String> getImage(bool isCamera) async {
    final XFile? image;
    if (isCamera) {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }
    final imagePath = image!.path;
    final box = Hive.box<WishlistMovie>(imagePicker);
    box.add(WishlistMovie(imagePath: imagePath));

    return imagePath;
  }

  int _getRandomNumber(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  @override
  void initState() {
    super.initState();
    initial();
    openBox();
  }

  void openBox() async {
    await Hive.openBox<WishlistMovie>(imagePicker);
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    String? savedUsername = loginData.getString('username');

    if (savedUsername != null) {
      setState(() {
        username = savedUsername;
      });
    } else {
      print('Username is null');
    }

    final box = Hive.box<WishlistMovie>(imagePicker);
    setState(() {
      _imagePath = box.values.map((e) => e.imagePath!).toList();
    });
  }

  void _removedImage(int index) {
    final box = Hive.box<WishlistMovie>(imagePicker);
    box.deleteAt(index);
    setState(() {
      _imagePath.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Remove Post Success'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildImageRow(int start, int end) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(end - start + 1, (index) {
          return GestureDetector(
            onLongPress: () {
              _removedImage(index);
            },
            child: Container(
              width: 100.0,
              height: 100.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Image.file(
                File(_imagePath[index]),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_imagePath.isEmpty) {
      return Container(); //
    }

    List<Widget> rows = [];
    for (int i = 0; i < _imagePath.length; i += 3) {
      int start = i;
      int end = (i + 2 < _imagePath.length) ? i + 2 : _imagePath.length - 1;
      rows.add(_buildImageRow(start, end));
    }

    return Column(
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/logo.png",
                                ),
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username ?? '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "124210006 & 124210021",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                //description
                                Text(
                                  "Pemrograman Mobile Mudah dan Menyenangkan",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Logout'),
                                    content:
                                        Text('Are you sure want to logout?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          loginData.setBool('login', true);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MyLoginPage(),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Logout Success'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                        child: Text('Logout',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.logout),
                          )
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  _imagePath.length.toString(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Posts",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  _getRandomNumber(50, 2000).toString(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  _getRandomNumber(1, 100).toString(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Reels",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Feeds",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Tag",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Divider(color: Colors.grey),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_buildImageGrid()],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          String imagePath = await getImage(true);
                          setState(() {
                            _imagePath.add(imagePath);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Add New Post Success'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text(
                          "Add New Post",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          String imagePath = await getImage(false);
                          setState(() {
                            _imagePath.add(imagePath);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Add New Post Success'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text(
                          "Get from Gallery",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
