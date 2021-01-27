import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Provider/employer_provider.dart';
import 'package:restaurant_freelance_job/pages/employer/employer_home.dart';
import 'package:restaurant_freelance_job/pages/place_service.dart';
import 'package:uuid/uuid.dart';
import '../address_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class EmployerForm extends StatefulWidget {
  final Employer employer;

  EmployerForm({this.employer});
  @override
  _EmployerFormState createState() => _EmployerFormState();
}

class _EmployerFormState extends State<EmployerForm> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  File imageFile;
  String _uploadedFileURL = null;
  EmployerProvider employerProvider = new EmployerProvider();
  var addressController = TextEditingController();
  var companyNameController = TextEditingController();
  var contactNameController = TextEditingController();
  var emailController = TextEditingController();
  var contactController = TextEditingController();

  @override
  void initState() {
    if (widget.employer.id.isNotEmpty) {
      //Edit
      employerProvider.loadAllEmployer(widget.employer);
      addressController.text = widget.employer.address;
      companyNameController.text = widget.employer.companyName;
      contactNameController.text = widget.employer.contactName;
      contactController.text = widget.employer.contactNo;
      emailController.text = widget.employer.email;
    } else {
      //Add
      employerProvider.loadAllEmployer(null);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future uploadPhoto() async {
    StorageReference storageReference = FirebaseStorage.instance.ref().
    child('profileImages/${Path.basename(imageFile.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        employerProvider.setPhotoUrl = fileURL;
      });
    });
  }

  submitNavigate(FormState form) {
    employerProvider.saveEmployer();
    form.save();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new EmployerHome(widget.employer)));
    //performLogin();
  }

  Future<void> _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      if (imageFile != null) {
        await uploadPhoto().then((value) =>
            submitNavigate(form));
      }
      else {
        submitNavigate(form);
      }
    }
  }
    void performLogin() {
      final snackbar = new SnackBar(
        content: new Text("Email :" + employerProvider.email),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }

    _openGallery(BuildContext context) async {
      Navigator.of(context).pop();
      File picture = await ImagePicker.pickImage(source: ImageSource.gallery,);
      this.setState(() {
        imageFile = picture;
        employerProvider.setPhotoUrl=imageFile.path;
      });
    }
    _openCamera(BuildContext context) async {
      var picture = await ImagePicker.pickImage(source: ImageSource.camera);
      this.setState(() {
        imageFile = picture;
        employerProvider.setPhotoUrl=imageFile.path;
      });
      Navigator.of(context).pop();
    }

    Future<void> _showChoiceDialog(BuildContext context) {
      return showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Make a Choice"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                ),
              ],
            ),
          ),
        );
      });
    }

    Widget _decideImageView() {
      if (employerProvider.photoUrl == "default") {
        return Text("No Image Selected!");
      }
      else {
        if(imageFile==null) {
          return CircleAvatar(radius:60, backgroundImage:NetworkImage(employerProvider.photoUrl));
        }
        else{
          return CircleAvatar(radius:60, backgroundImage: Image.file(imageFile, fit:BoxFit.cover).image);
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
          home: new Scaffold(
              key: scaffoldKey,
              appBar: new AppBar(
                title: new Text("Profile Information"),
              ),
              body: new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _decideImageView(),
                        new RaisedButton(onPressed: () {
                          _showChoiceDialog(context);
                        }, child: Text("Upload Image"),
                        ),
                        new TextFormField(
                          controller: companyNameController,
                          decoration: new InputDecoration(
                              labelText: "Company Name"),
                          validator: (val) =>
                          val.isEmpty
                              ? 'Please fill the Company Name!'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              employerProvider.setCompanyName = val;
                            });
                          },
                        ),
                        new TextFormField(
                          controller: addressController,
                          validator: (val) =>
                          val.isEmpty
                              ? 'Please fill the Address!'
                              : null,
                          onTap: () async {
                            // generate a new token here
                            final sessionToken = Uuid().v4();
                            final Suggestion result = await showSearch(
                              context: context,
                              delegate: AddressSearch(sessionToken),
                            );
                            // This will change the text displayed in the TextField
                            if (result != null) {
                              setState(() {
                                addressController.text = result.description;
                                employerProvider.setAddress =
                                    result.description;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            icon: Container(
                              width: 10,
                              height: 10,
                              child: Icon(
                                Icons.home,
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Company location",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 8.0, top: 16.0),
                          ),
                        ),
                        new TextFormField(
                          controller: contactNameController,
                          decoration: new InputDecoration(
                              labelText: "Contact Person Name"),
                          validator: (val) =>
                          val.isEmpty
                              ? 'Please fill the Contact Person Name!'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              employerProvider.setContactName = val;
                            });
                          },
                        ),
                        new TextFormField(
                          controller: contactController,
                          decoration: new InputDecoration(
                              labelText: "Contact No."),
                          validator: (val) =>
                          val.isEmpty
                              ? 'Please fill the Contact No.!'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              employerProvider.setContactNo = val;
                            });
                          },
                        ),
                        new TextFormField(
                          controller: emailController,
                          decoration: new InputDecoration(labelText: "Email"),
                          validator: (val) =>
                          !val.contains('@')
                              ? 'Please fill the Valid Email!'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              employerProvider.setEmail = val;
                            });
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                        ),
                        new RaisedButton(
                          child: new Text(
                            "Submit",
                            style: new TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: _submit,
                        )
                      ],
                    ),
                  ),
                ),
              )
          )
      );
    }
  }

