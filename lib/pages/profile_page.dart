import '../main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  ProfilePage({this.name, this.email, this.image});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name;
  String email;
  String imagePath;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();
  File imageFile;
  @override
  initState() {
    usernameController.text = widget.name;
    emailController.text = widget.email;
    imagePath = (widget.image == null) ? 'assets/profile.jpg' : widget.image;
    setImageFun(imagePath);
    super.initState();
  }

  Widget setImageFun(String path) {
    if (path.length > 20) {
      return (imagePath == null)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/profile.jpg',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                File(imagePath),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            );
    } else {
      return (imagePath == null)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/profile.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            );
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      imageFile = File(pickedFile.path);
      imagePath =
          (imageFile.path == null) ? 'assets/profile.jpg' : imageFile.path;
    });
  }

  void bottomSheetFun() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10),
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an Image',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Information')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 3, color: Theme.of(context).accentColor),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                child:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? buildColumn(context)
                        : buildRow(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColumn(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildUsernameTextField(context),
          buildEmailTextField(context),
          SizedBox(),
          buildImageButton(context),
          setImageFun(imagePath),
          SizedBox(),
          SizedBox(),
          SizedBox(),
          buildSaveButton(context),
        ],
      ),
    );
  }

  Widget buildRow(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    buildUsernameTextField(context),
                    SizedBox(height: 10),
                    buildEmailTextField(context),
                    SizedBox(height: 15),
                    buildImageButton(context),
                  ],
                ),
              ),
              SizedBox(width: 10),
              setImageFun(imagePath),
            ],
          ),
          SizedBox(height: 10),
          buildSaveButton(context),
        ],
      ),
    );
  }

  TextFormField buildUsernameTextField(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
        labelText: 'Name',
        prefixIcon: Icon(
          Icons.person,
          size: 30,
          color: Theme.of(context).accentColor,
        ),
        focusColor: Theme.of(context).primaryColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (String value) {
        if (value.isEmpty || value.trim().length == 0) {
          return 'Enter your Name';
        }
        return null;
      },
      onSaved: (String value) {
        name = value;
      },
    );
  }

  TextFormField buildEmailTextField(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(
          Icons.email,
          size: 30,
          color: Theme.of(context).accentColor,
        ),
        focusColor: Theme.of(context).primaryColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Enter valed email';
        }
        return null;
      },
      onSaved: (String value) {
        email = value;
      },
    );
  }

  Container buildImageButton(BuildContext context) {
    return Container(
      width: 200,
      child: OutlineButton(
        borderSide: BorderSide(
          width: 2.0,
          color: Theme.of(context).accentColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10.0),
            Text(
              'Add Image',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        onPressed: bottomSheetFun,
      ),
    );
  }

  RaisedButton buildSaveButton(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0.0,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.save,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 10.0),
            Text(
              'Save',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(
                username: usernameController.text,
                email: emailController.text,
                imagePath: imagePath,
              ),
            ),
          );
        }
      },
    );
  }
}
