import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Provider/employee_provider.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_home.dart';
import 'package:restaurant_freelance_job/pages/place_service.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import '../address_search.dart';

class EmployeeForm extends StatefulWidget {
  final Employee employee;
  final List<JobRoles> priceList;

  EmployeeForm({this.employee,this.priceList});
  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  File imageFile;
  EmployeeProvider employeeProvider= new EmployeeProvider();
  var addressController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var contactController = TextEditingController();

  List<DropdownMenuItem<JobRoles>> _dropdownMenuItems;
  JobRoles _selectedRole;

  @override
  initState() {
    _dropdownMenuItems = buildDropdownMenuItems(widget.priceList);
    _selectedRole = _dropdownMenuItems[0].value;
    if (widget.employee != null){
      //Edit
      int index= _dropdownMenuItems.indexWhere((element) => element.value.id==widget.employee.jobRole);
      _selectedRole=_dropdownMenuItems[index].value;
      addressController.text =widget.employee.address;
      nameController.text = widget.employee.name;
      contactController.text = widget.employee.contactNo;
      employeeProvider.loadAll(widget.employee);
    } else {
      //Add
      employeeProvider.loadAll(null);
    }
    super.initState();
  }

  List<DropdownMenuItem<JobRoles>> buildDropdownMenuItems(List roles) {
    List<DropdownMenuItem<JobRoles>> items = List();
    for (JobRoles role in roles) {
      items.add(
        DropdownMenuItem(
          value: role,
          child: Text(role.name),
        ),
      );
    }
    return items;
  }
  onChangeDropdownItem(JobRoles selectedRole) {
    setState(() {
      _selectedRole = selectedRole;
      employeeProvider.setJobRole= selectedRole.id.toString();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  submitNavigate(FormState form){
    employeeProvider.saveEmployee();
    form.save();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new EmployeeHome(widget.employee)));
    performLogin();
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
      content: new Text("Email :"+ employeeProvider.email),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
  _openGallery(BuildContext context) async{
    var picture= await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile=picture;
      employeeProvider.setPhotoUrl=imageFile.path;
    });
    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context) async{
    var picture= await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile=picture;
      employeeProvider.setPhotoUrl=imageFile.path;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Make a Choice"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallery"),
                onTap:(){
                  _openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Camera"),
                onTap:(){
                  _openCamera(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _decideImageView(){
    if (employeeProvider.photoUrl == "default") {
      return Text("No Image Selected!");
    }
    else {
      if(imageFile==null) {
        return CircleAvatar(radius:60, backgroundImage:NetworkImage(employeeProvider.photoUrl));
      }
      else{
        return CircleAvatar(radius:60, backgroundImage: Image.file(imageFile, fit:BoxFit.cover).image);
      }
    }
  }
  Future uploadPhoto() async {
    StorageReference storageReference = FirebaseStorage.instance.ref().
    child('profileImages/${Path.basename(imageFile.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        employeeProvider.setPhotoUrl = fileURL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("Profile Information"),
        ),
        body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Form(
            key: formKey,
            child: SingleChildScrollView(
              child:new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _decideImageView(),
                new RaisedButton(onPressed:(){
                  _showChoiceDialog(context);
                }, child: Text("Upload Image"),
                ),
                new TextFormField(
                  controller: nameController,
                  decoration: new InputDecoration(labelText: "Full Name"),
                  validator: (val) => val.isEmpty ? 'Please fill the Name!' : null,
                  onChanged: (val) {
                  setState(() {
                    employeeProvider.setName = val;
                  });
                  },
                ),
                new TextFormField(
                  controller: contactController,
                  decoration: new InputDecoration(labelText: "Contact No."),
                  validator: (val) => val.isEmpty ? 'Please fill the Contact No.!' : null,
                  onChanged: (val) {
                  setState(() {
                    employeeProvider.setContactNo = val;
                  });
                  },
                  ),
                new FormBuilderChoiceChip(
                      decoration: InputDecoration(labelText: 'Gender'),
                      attribute: employeeProvider.gender,
                      initialValue: widget.employee.gender,
                      validators: [FormBuilderValidators.required()],
                    options: [
                      FormBuilderFieldOption(
                          child: Text("Male"),
                          value: "0"
                      ),
                      FormBuilderFieldOption(
                          child: Text("Female"),
                          value: "1"
                      ),
                    ],
                      onChanged: (value) {
                        setState(() {
                          employeeProvider.setGender = value;
                        });
                      }
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Select Job Role",
                          style: new TextStyle(fontSize: 16.0)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                      ),
                      DropdownButton(
                        value: _selectedRole,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                      ),
                      SizedBox(
                        height: 20.0,
                      )
                    ]
                ),
                new FormBuilderChoiceChip(
                  decoration: InputDecoration(labelText: 'Job Experience'),
                  attribute: employeeProvider.jobExperience,
                  initialValue: widget.employee.jobExperience,
                  validators: [FormBuilderValidators.required()],
                  options: [
                    FormBuilderFieldOption(
                        child: Text("None"),
                        value: "0"
                    ),
                    FormBuilderFieldOption(
                        child: Text("1 or + year"),
                        value: "1"
                    ),
                  ],
                    onChanged: (value) {
                      setState(() {
                        employeeProvider.setJobExperience = value;
                      });
                    }
                ),
               /* Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                    FlatButton.icon(
                    onPressed: () async{
                    dynamic result= await Navigator.pushNamed(context, '/location');
                    },
                    icon: Icon(
                        Icons.edit_location),
                    color: Colors.black12,
                    label: Text('Set Location',
                      style: TextStyle(
                        color: Colors.black,
                      ),)),
                      ]), */
                new TextFormField(
                    controller: addressController,
                  validator: (val) => val.isEmpty ? 'Please fill the Address!' : null,
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
                        employeeProvider.setAddress= result.description;
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
                    hintText: "Your address",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                  ),
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
        ));
  }
}
