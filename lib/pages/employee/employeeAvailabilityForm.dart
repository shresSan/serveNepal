import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:restaurant_freelance_job/core/Models/EmpAvailability.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Provider/empAvailability_provider.dart';
import 'dart:ui';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobShifts.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_home.dart';
import 'package:intl/intl.dart';

class EmployeeAvailabilityForm extends StatefulWidget {
  final EmpAvailability empAvailability;
  final Employee employee;
  EmployeeAvailabilityForm({this.empAvailability,this.employee});

  @override
  _EmployeeAvailabilityFormState createState() => _EmployeeAvailabilityFormState();
}

class _EmployeeAvailabilityFormState extends State<EmployeeAvailabilityForm> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  EmpAvailabilityProvider empAvailabilityProvider = new EmpAvailabilityProvider();

  List<JobShifts> _shifts = JobShifts.getJobShifts();
  List<DropdownMenuItem<JobShifts>> _dropdownShiftItems;
  JobShifts _selectedShift;

  @override
  void initState() {
    empAvailabilityProvider.loadEmpAvailability(widget.empAvailability);
    _dropdownShiftItems = buildDropdownMenuItems(_shifts);
    int index=0;
    if(widget.empAvailability.jobShift!=''){
      index = _dropdownShiftItems.indexWhere((element) =>
      element.value.id == int.parse(widget.empAvailability.jobShift));
    }
    _selectedShift = _dropdownShiftItems[index].value;
    super.initState();
  }

  List<DropdownMenuItem<JobShifts>> buildDropdownMenuItems(List shifts) {
    List<DropdownMenuItem<JobShifts>> items = List();
    for (JobShifts shift in shifts) {
      items.add(
        DropdownMenuItem(
          value: shift,
          child: Text(shift.name),
        ),
      );
    }
    return items;
  }
  onChangeDropdownItem(JobShifts selectedShift) {
    setState(() {
      _selectedShift = selectedShift;
      empAvailabilityProvider.setJobShift=selectedShift.id.toString();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      final DateTime now= DateTime.now();
      final DateFormat formatter= DateFormat('yyyy-MM-dd');
      empAvailabilityProvider.setUpdatedDate= formatter.format(now);
      empAvailabilityProvider.saveEmpAvailability();
      form.save();
      performLogin();
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new EmployeeHome(widget.employee)));
    }
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Email : email"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
  Widget _chooseShift() {
    if (empAvailabilityProvider.isAvailable) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Select Job Shift",
                style: new TextStyle(fontSize: 16.0)),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
            ),
            DropdownButton(
              value: _selectedShift,
              items: _dropdownShiftItems,
              onChanged: onChangeDropdownItem,
            ),
            SizedBox(
              height: 20.0,
            )
          ]
      );
    }
    else{
      return Row();
    }
  }

    @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("Employee Availability"),
          leading: FlatButton(
              child: Icon(Icons.home),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new EmployeeHome(widget.employee)));
              }
          ),
        ),
        body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Form(
            key: formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FormBuilderChoiceChip(
                    decoration: InputDecoration(labelText: 'Your Availability'),
                    initialValue: widget.empAvailability.isAvailable,
                    validators: [FormBuilderValidators.required()],
                    options: [
                      FormBuilderFieldOption(
                          child: Text("Available"),
                          value: true
                      ),
                      FormBuilderFieldOption(
                          child: Text("Not Available"),
                          value: false
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        empAvailabilityProvider.setAvailability = value;
                      });
                    }
                ),
                _chooseShift(),
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
        ));
  }
}