import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';

class CloudFirestoreSearch extends StatefulWidget {
  const CloudFirestoreSearch({Key? key}) : super(key: key);

  @override
  State<CloudFirestoreSearch> createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = '';
  int schoolName = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  var pageIndex = 0;
  String email = '';
  List commentsData = [];
  List chatData = [];
  CollectionReference newComment =
      FirebaseFirestore.instance.collection('schools');

  void schoolPageIndex() {
    setState(() {
      pageIndex = 1;
    });
  }

  void homePageIndex() {
    setState(() {
      pageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return pageIndex == 0
        ? Scaffold(
            appBar: AppBar(
              title: Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search ...'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: (name != '' && name != null)
                  ? FirebaseFirestore.instance
                      .collection('schools')
                      .where("searchKeyWords", arrayContains: name)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("schools")
                      .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          return Container(
                            padding: EdgeInsets.only(top: 16),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    data['name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: CircleAvatar(
                                    child: Image.network(
                                      data['imageURL'],
                                      width: 100,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                                    radius: 40,
                                    backgroundColor: Colors.lightBlue,
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          schoolName = data['id'];
                                        });
                                        print(schoolName);
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          // Do something
                                          schoolPageIndex();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.arrow_right,
                                      )),
                                ),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            ),
                          );
                        });
              },
            ),
          )
        : pageIndex == 1
            ? // here is the second
            Card(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('Welcome To Our School'),
                    centerTitle: true,
                  ),
                  body: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("schools")
                        .where("id", isEqualTo: schoolName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      print(schoolName);
                      return (snapshot.connectionState ==
                              ConnectionState.waiting)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data =
                                    snapshot.data!.docs[index];
                                return Column(
                                  children: <Widget>[
                                    Card(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.arrow_back),
                                                onPressed: () {
                                                  homePageIndex();
                                                },
                                              ),
                                              Center(
                                                widthFactor: 2,
                                                child: Text(
                                                  data['name'],
                                                  style: TextStyle(
                                                    fontSize: 37,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 30,
                                          ),
                                          Image.network(
                                            data['imageURL'],
                                            width: 200,
                                            height: 100,
                                            fit: BoxFit.contain,
                                          ),
                                          Container(
                                            height: 30,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Description: ",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  data['description'],
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 30,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Price: ",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  data['price'],
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  "Comments",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                    ),
                                                    for (var item
                                                        in data['comments'])
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              item,
                                                              style: TextStyle(
                                                                  fontSize: 30),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                    ),
                                    Card(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.star,
                                              color: Colors.yellowAccent,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.star,
                                              color: Colors.yellowAccent,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.star,
                                              color: Colors.yellowAccent,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.star,
                                              color: Colors.yellowAccent,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.star,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          pageIndex = 2;
                                        });
                                      },
                                      child: Text(
                                        "Would you like to comment and rate us? please login",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.lightBlue),
                                      ),
                                    )
                                  ],
                                );
                              });
                    },
                  ),
                ),
              )
            : pageIndex == 2
                ? // here is the login
                Scaffold(
                    appBar: AppBar(
                      title: Text('Login Page'),
                      centerTitle: true,
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                    )),
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          homePageIndex();
                                        },
                                      ),
                                      Center(
                                        widthFactor: 3,
                                        child: Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/images/logo.png',
                                    height: 270,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Form(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: emailController,
                                      validator: (value) =>
                                          value != null && value.isEmpty
                                              ? 'Enter a valid email'
                                              : null,
                                      decoration: InputDecoration(
                                        labelText: 'Enter your email',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      validator: (value) => value != null &&
                                              value.length < 6
                                          ? 'your password must be longer than 6 chars'
                                          : null,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter your password',
                                      ),
                                      obscureText: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(250, 50)),
                                      onPressed: () {
                                        if (emailController.text ==
                                                'test@gmail.com' ||
                                            emailController.text ==
                                                'root@gmail.com') {
                                          if (passwordController.text ==
                                              '123456') {
                                            setState(() {
                                              email = emailController.text;
                                            });
                                          }
                                          setState(() {
                                            pageIndex = 3;
                                          });
                                          print(email);
                                        } else {
                                          showFlash(
                                              context: context,
                                              duration: Duration(seconds: 3),
                                              builder: (_, controller) {
                                                return Flash(
                                                  controller: controller,
                                                  position: FlashPosition.top,
                                                  behavior: FlashBehavior.fixed,
                                                  child: FlashBar(
                                                    icon: Icon(
                                                      Icons.no_accounts,
                                                      size: 36.0,
                                                      color: Colors.black,
                                                    ),
                                                    content: Text(
                                                        "Email or Password is Wrong"),
                                                  ),
                                                );
                                              });
                                        }
                                      },
                                      child: const Text('LOGIN'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : pageIndex == 3
                    ?
                    // here is the third
                    Scaffold(
                        appBar: AppBar(
                          title: Card(
                            child: TextField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'Search ...'),
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                            ),
                          ),
                        ),
                        body: StreamBuilder<QuerySnapshot>(
                          stream: (name != '' && name != null)
                              ? FirebaseFirestore.instance
                                  .collection('schools')
                                  .where("searchKeyWords", arrayContains: name)
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection("schools")
                                  .snapshots(),
                          builder: (context, snapshot) {
                            return (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot data =
                                          snapshot.data!.docs[index];
                                      return Container(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                data['name'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              leading: CircleAvatar(
                                                child: Image.network(
                                                  data['imageURL'],
                                                  width: 100,
                                                  height: 50,
                                                  fit: BoxFit.contain,
                                                ),
                                                radius: 40,
                                                backgroundColor:
                                                    Colors.lightBlue,
                                              ),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      schoolName = data['id'];
                                                    });
                                                    print(schoolName);
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 500),
                                                        () {
                                                      // Do something
                                                      setState(() {
                                                        pageIndex = 4;
                                                      });
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_right,
                                                  )),
                                            ),
                                            Divider(
                                              thickness: 2,
                                            )
                                          ],
                                        ),
                                      );
                                    });
                          },
                        ),
                      )
                    : pageIndex == 4
                        ?
                        // here is the last
                        Card(
                            child: Scaffold(
                              appBar: AppBar(
                                title: Text('Welcome: $email'),
                                centerTitle: true,
                              ),
                              body: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("schools")
                                    .where("id", isEqualTo: schoolName)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  print(snapshot.data);
                                  //print(schoolName);
                                  return (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot data =
                                                snapshot.data!.docs[index];
                                            return Column(children: <Widget>[
                                              Card(
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.arrow_back),
                                                          onPressed: () {
                                                            setState(() {
                                                              pageIndex = 3;
                                                            });
                                                          },
                                                        ),
                                                        Text(
                                                          data['name'],
                                                          style: TextStyle(
                                                            fontSize: 37,
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                email = '';
                                                              });
                                                              homePageIndex();
                                                            },
                                                            icon: Icon(
                                                                Icons.logout))
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 30,
                                                    ),
                                                    Image.network(
                                                      data['imageURL'],
                                                      width: 200,
                                                      height: 100,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    Container(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Description: ",
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            data['description'],
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Price: ",
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            data['price'],
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 30,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: Card(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Text(
                                                            "Comments",
                                                            style: TextStyle(
                                                              fontSize: 30,
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                height: 30,
                                                              ),

                                                              for (var item
                                                                  in data[
                                                                      'comments'])
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        item,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                30),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              data['id'] == 1 &&
                                                                      email ==
                                                                          'test@gmail.com'
                                                                  ? Column(
                                                                      children: <
                                                                          Widget>[
                                                                        TextFormField(
                                                                          controller:
                                                                              commentController,
                                                                          validator: (value) => value != null && value.isEmpty
                                                                              ? 'comment can\'t be empty'
                                                                              : null,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Enter your Comment',
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(minimumSize: const Size(250, 50)),
                                                                            onPressed: () => {
                                                                                  setState(() {
                                                                                    commentsData = data['comments'];
                                                                                    commentsData.add('$email : ${commentController.text}');
                                                                                  }),
                                                                                  newComment.doc("22DRtQQFVlqBO5kBn1cR").update({"comments": commentsData}).then((value) => print("comment updated")).catchError((error) => print("Failed to update user: $error"))
                                                                                },
                                                                            child: Text('Submit')),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : data['id'] ==
                                                                              2 &&
                                                                          email ==
                                                                              'root@gmail.com'
                                                                      ? Column(
                                                                          children: <
                                                                              Widget>[
                                                                            TextFormField(
                                                                              controller: commentController,
                                                                              validator: (value) => value != null && value.isEmpty ? 'comment can\'t be empty' : null,
                                                                              decoration: InputDecoration(
                                                                                labelText: 'Enter your Comment',
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(minimumSize: const Size(250, 50)),
                                                                                onPressed: () => {
                                                                                      setState(() {
                                                                                        commentsData = data['comments'];
                                                                                        commentsData.add('$email : ${commentController.text}');
                                                                                      }),
                                                                                      newComment.doc("BKSy0s5NqBm50rteKLcr").update({"comments": commentsData}).then((value) => print("comment updated")).catchError((error) => print("Failed to update user: $error"))
                                                                                    },
                                                                                child: Text('Submit')),
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Card(), //here is the comments
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                              ),
                                              Card(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellowAccent,
                                                        ),
                                                        onPressed: () {
                                                          if (data['id'] == 1 &&
                                                              email ==
                                                                  'test@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "1 star rating has been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          } else if (data[
                                                                      'id'] ==
                                                                  2 &&
                                                              email ==
                                                                  'root@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "1 star rating has been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellowAccent,
                                                        ),
                                                        onPressed: () {
                                                          if (data['id'] == 1 &&
                                                              email ==
                                                                  'test@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "2 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          } else if (data[
                                                                      'id'] ==
                                                                  2 &&
                                                              email ==
                                                                  'root@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "2 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellowAccent,
                                                        ),
                                                        onPressed: () {
                                                          if (data['id'] == 1 &&
                                                              email ==
                                                                  'test@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "3 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          } else if (data[
                                                                      'id'] ==
                                                                  2 &&
                                                              email ==
                                                                  'root@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "3 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellowAccent,
                                                        ),
                                                        onPressed: () {
                                                          if (data['id'] == 1 &&
                                                              email ==
                                                                  'test@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "4 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          } else if (data[
                                                                      'id'] ==
                                                                  2 &&
                                                              email ==
                                                                  'root@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "4 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          if (data['id'] == 1 &&
                                                              email ==
                                                                  'test@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "5 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          } else if (data[
                                                                      'id'] ==
                                                                  2 &&
                                                              email ==
                                                                  'root@gmail.com') {
                                                            showFlash(
                                                                context:
                                                                    context,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                builder: (_,
                                                                    controller) {
                                                                  return Flash(
                                                                    controller:
                                                                        controller,
                                                                    position:
                                                                        FlashPosition
                                                                            .top,
                                                                    behavior:
                                                                        FlashBehavior
                                                                            .fixed,
                                                                    child:
                                                                        FlashBar(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            36.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      content: Text(
                                                                          "5 stars rating have been recorded thanks for voting!"),
                                                                    ),
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                              ),
                                              data['id'] == 1 &&
                                                      email == 'test@gmail.com'
                                                  ? Row(
                                                      children: <Widget>[
                                                        Text(
                                                          "Have an issue? chat with an admin",
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                pageIndex = 5;
                                                              });
                                                            },
                                                            icon: Icon(
                                                                Icons.chat))
                                                      ],
                                                    )
                                                  : data['id'] == 2 &&
                                                          email ==
                                                              'root@gmail.com'
                                                      ? Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "Have an issue? chat with an admin",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    pageIndex =
                                                                        5;
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                    Icons.chat))
                                                          ],
                                                        )
                                                      : Row(),
                                            ]);
                                          });
                                },
                              ),
                            ),
                          )
                        : Card(
                            child: Scaffold(
                              appBar: AppBar(
                                title: Text('Welcome: $email'),
                                centerTitle: true,
                              ),
                              body: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("schools")
                                    .where("id", isEqualTo: schoolName)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  print(schoolName);
                                  return (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot data =
                                                snapshot.data!.docs[index];
                                            return Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.arrow_back),
                                                      onPressed: () {
                                                        setState(() {
                                                          pageIndex = 3;
                                                        });
                                                      },
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        data['name'],
                                                        style: TextStyle(
                                                          fontSize: 37,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            email = '';
                                                          });
                                                          homePageIndex();
                                                        },
                                                        icon:
                                                            Icon(Icons.logout))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Center(
                                                  child: Text(
                                                    "You Are Now Chatting with an Admin of our schools",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Card(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Column(
                                                          children: <Widget>[
                                                            for (var chat
                                                                in data['chat'])
                                                              Card(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      chat,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            SizedBox(
                                                              height: 15,
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              TextFormField(
                                                                controller:
                                                                    chatController,
                                                                validator: (value) => value !=
                                                                            null &&
                                                                        value
                                                                            .isEmpty
                                                                    ? 'comment can\'t be empty'
                                                                    : null,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'start chatting',
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      chatData =
                                                                          data[
                                                                              'chat'];
                                                                      chatData.add(
                                                                          '$email : ${chatController.text}');
                                                                    });
                                                                    if (data['id'] ==
                                                                            1 &&
                                                                        email ==
                                                                            'test@gmail.com') {
                                                                      newComment
                                                                          .doc(
                                                                              "22DRtQQFVlqBO5kBn1cR")
                                                                          .update({
                                                                            "chat":
                                                                                chatData
                                                                          })
                                                                          .then((value) => print(
                                                                              "comment updated"))
                                                                          .catchError((error) =>
                                                                              print("Failed to update user: $error"));
                                                                    } else if (data['id'] ==
                                                                            2 &&
                                                                        email ==
                                                                            'root@gmail.com') {
                                                                      newComment
                                                                          .doc(
                                                                              "BKSy0s5NqBm50rteKLcr")
                                                                          .update({
                                                                            "chat":
                                                                                chatData
                                                                          })
                                                                          .then((value) => print(
                                                                              "comment updated"))
                                                                          .catchError((error) =>
                                                                              print("Failed to update user: $error"));
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .send))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                },
                              ),
                            ),
                          );
  }
}
