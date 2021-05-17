import 'package:fend/Databases/AvatarDB.dart';
import 'package:fend/Databases/UserDB.dart';
import 'package:fend/EntryPoint.dart';
import 'package:fend/classes/Avatar.dart';
import 'package:fend/screens/mainPage.dart';
import 'package:fend/widgets/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:fend/globals.dart' as global;

class AvatarChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var bottomNavIndex = 4;

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 57;
  List<String> avatars = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
    'assets/7.png',
    'assets/8.png',
    'assets/9.png',
    'assets/10.png',
    'assets/11.png',
    'assets/12.png',
    'assets/13.png',
    'assets/14.png',
    'assets/15.png',
    'assets/16.png',
    'assets/17.png',
    'assets/18.png',
    'assets/19.png',
    'assets/20.png',
    'assets/21.png',
    'assets/22.png',
    'assets/23.png',
    'assets/24.png',
    'assets/25.png',
    'assets/26.png',
    'assets/27.png',
    'assets/28.png',
    'assets/29.png',
    'assets/30.png',
    'assets/31.png',
    'assets/31.png',
    'assets/33.png',
    'assets/34.png',
    'assets/35.png',
    'assets/36.png',
    'assets/37.png',
    'assets/38.png',
    'assets/39.png',
    'assets/40.png',
    'assets/neutral.png',
    'assets/42.png',
    'assets/43.png',
    'assets/44.png',
    'assets/45.png',
    'assets/46.png',
    'assets/47.png',
    'assets/48.png',
    'assets/49.png',
    'assets/50.png',
    'assets/51.png',
    'assets/52.png',
    'assets/53.png',
    'assets/54.png',
    'assets/55.png',
    'assets/56.png',
    'assets/neutral_guy.png',
    'assets/neutral_girl.png'
  ];

  //default index of a first screen

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: HexColor('#F0F2F5'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    height: 35,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.teal,
                    ),
                  )
                ],
              ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                    return;
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: avatars.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.5,
                        mainAxisSpacing: 4.5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              print(selectedIndex);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(1.0, 1.0))
                                ],
                                color: Color(0xfff3f3f3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Image(
                              image: AssetImage(
                                avatars[index],
                              ),
                              height: 100,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 105,
                child: Row(
                  children: [
                    SizedBox(
                      width: 260,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Image(
                                image: AssetImage(avatars[selectedIndex]),
                                height: 80,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () async {
                                    var databaseHelper = UserDatabase.instance;
                                    var databaseUser =
                                        await databaseHelper.getAllUsers();
                                    var sid = databaseUser[0].sid;
                                    Map<String, String> headers = {
                                      "Content-type": "application/json"
                                    };
                                    String json =
                                        '{"SID": $sid, "Avatar": "${avatars[selectedIndex]}"}';

                                    Response response = await post(
                                        Uri.parse('${global.url}/avatar'),
                                        headers: headers,
                                        body: json);
                                    print(response.body);
                                    selectedAvatar = avatars[index];
                                    var avatarHelper = AvatarDatabase.instance;
                                    Avatar avatar = Avatar(
                                        id: 0, avatar: avatars[selectedIndex]);
                                    await avatarHelper.deleteTable();
                                    await avatarHelper.addAvatar(avatar);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EntryPoint()));
                                  })
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: bottomAppBar()),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
