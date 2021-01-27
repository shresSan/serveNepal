import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Provider/hiringForm_provider.dart';
import 'dart:async';
import 'dart:ui';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobShifts.dart';

typedef OnDelete();

class HiringForm extends StatefulWidget {
  final HiringFormProvider hiring;
  var state= _HiringFormState();
  final OnDelete onDelete;
  final List<JobRoles> roles;
  HiringForm({Key key, this.hiring, this.onDelete,this.roles}): super(key:key);
  @override
  _HiringFormState createState(){
    return this.state= new _HiringFormState();
  }
  bool isValid() => this.state.validate();
}

class _HiringFormState extends State<HiringForm> {
  var editingController = new TextEditingController();
  final form=GlobalKey<FormState>();
  List<DropdownMenuItem<JobRoles>> _dropdownMenuItems;
  JobRoles _selectedRole;
  List<JobShifts> _shifts = JobShifts.getJobShifts();
  List<DropdownMenuItem<JobShifts>> _dropdownShiftItems;
  JobShifts _selectedShift;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(widget.roles);
    _selectedRole = _dropdownMenuItems[0].value;
    _dropdownShiftItems = buildDropdownShiftItems(_shifts);
    _selectedShift = _dropdownShiftItems[0].value;
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
  List<DropdownMenuItem<JobShifts>> buildDropdownShiftItems(List shifts) {
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
  onChangeDropdownItem(JobRoles selectedRole) {
    setState(() {
      _selectedRole = selectedRole;
      widget.hiring.setJobRole=selectedRole.id;
      widget.hiring.setTotalAmount= selectedRole.pricePerHour;
    });
  }
  onChangeDropdownShift(JobShifts selectedShift) {
    setState(() {
      _selectedShift = selectedShift;
      widget.hiring.setJobShift=selectedShift.name;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                leading: Icon(Icons.verified_user),
                elevation: 0,
                title: Text('Hiring Role'),
                backgroundColor: Theme.of(context).accentColor,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new DropdownButtonFormField<JobRoles>(
                  value: _selectedRole,
                  items: _dropdownMenuItems,
                  hint: Text('Job Roles'),
                  onChanged: onChangeDropdownItem,
                  onSaved: (value){
                    setState(() {
                      widget.hiring.setJobRole=value.id;
                      widget.hiring.setTotalAmount= value.pricePerHour;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new DropdownButtonFormField<JobShifts>(
                  value: _selectedShift,
                  items: _dropdownShiftItems,
                  hint: Text('Shifts'),
                  onChanged: onChangeDropdownShift,
                  onSaved: (value){
                    setState(() {
                      widget.hiring.setJobShift=value.name;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:TextFormField(
                    controller: editingController,
                  decoration: InputDecoration(
                    labelText: 'No. of Employee',
                    hintText: 'Enter No. of Employee Needed'),
                  validator: (val)=> validateEmpNum(val),
                  onSaved: (val) => widget.hiring.setEmpNum = val
                ),
              ),
              SizedBox(
                    height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
  String validateEmpNum(String value) {
    if(!isNumber(value)) {
      editingController.clear();
      return 'Employee Number must be numeric' ;
    }
    else{
      if(value != "0"){
        return null ;
      }
      return 'Number of Employee must be atleast 1' ;
    }
  }
  bool isNumber(String value) {
    if(value == null) {
      return true;
    }
    final n = num.tryParse(value);
    return n!= null;
  }
}
