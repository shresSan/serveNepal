import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Provider/hiringForm_provider.dart';
import 'package:restaurant_freelance_job/components/empty_state.dart';
import 'package:restaurant_freelance_job/core/Provider/priceList_provider.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';
import '../../services/auth.dart';
import 'employer_requestedEmpNotification.dart';
import 'hiringForm.dart';
import 'employer_home.dart';
import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class MultiForm extends StatefulWidget {
  final Employer employer;
  MultiForm(this.employer);
  var state=_MultiFormState();
  @override
  _MultiFormState createState(){
    return this.state= new _MultiFormState();
  }
}

class _MultiFormState extends State<MultiForm> {
  var _hiring= new HiringFormProvider();
  List<HiringForm> hiringList = [];
  Services firestoreService = Services();
  var uuid = Uuid();
  HiringFormProvider hiringFormProvider = new HiringFormProvider();
  GlobalKey<FormState> _loginFormKey=
  new GlobalKey<FormState>(debugLabel: '_loginFormKey');
  List<JobRoles> roles;
  @override
  void initState() {
    PriceListProvider priceListProvider = new PriceListProvider();
    priceListProvider.priceList.first.then(
            (value) => roles=value
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        leading: FlatButton(
              child: Icon(Icons.home),
              onPressed: onNavigate
        ),
        title: Text('HIRE EMPLOYEES'),
        backgroundColor: Colors.cyan,
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            textColor: Colors.white,
            onPressed: onSave,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF30C1FF),
              Color(0xFF2AA7DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: hiringList.length <= 0
            ? Center(
          child: EmptyState(
            title: 'No Records',
            message: 'Add form by tapping add button below',
          ),
        )
            : ListView.builder(
          key: _loginFormKey,
          addAutomaticKeepAlives: true,
          itemCount: hiringList.length,
          itemBuilder: (context, i) => hiringList[i],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddForm,
        foregroundColor: Colors.white,
      ),
    );
  }

  ///on form user deleted
  void onDelete(HiringFormProvider _hire) {
    setState(() {
      var find = hiringList.firstWhere(
            (it) => it.hiring ==_hire,
        orElse: () => null,
      );
      if (find != null) {
        hiringList.removeAt(hiringList.indexOf(find));
        if(_hire.id!=null) {
          hiringFormProvider.removeHiringForm(_hire.id);
        }
      }
    });
  }

  ///on add form
  void onAddForm() {
   setState(() {
      hiringList.add(HiringForm(
        hiring: _hiring,
        onDelete: () => onDelete(_hiring),
        roles: roles
      ));
    });
  }
  void onNavigate(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new EmployerHome(widget.employer)));
  }
  void onSubmit(){
    var transId= uuid.v1();
    List<JobRoles> roles;
      PriceListProvider priceListProvider = new PriceListProvider();
      priceListProvider.priceList.first.then(
              (value) => roles = value
      );
    List<String> selectedJobRolesId= [];
    DateTime now= DateTime.now();
    DateTime thirtyDaysFromNow = now.add(new Duration(days: 30));
    final DateFormat formatter= DateFormat('yyyy-MM-dd');
    List<HiringFormProvider> modelList= new List<HiringFormProvider>();
    for(HiringForm hiringForm in hiringList) {
      selectedJobRolesId.add(hiringForm.hiring.jobRole);
      hiringForm.hiring.setUpdatedDate = formatter.format(now);
      hiringForm.hiring.setDeadline = formatter.format(thirtyDaysFromNow);
      hiringForm.hiring.setTransactionId = transId;
      hiringForm.hiring.setTotalAmount = (int.parse(hiringForm.hiring.totalAmount) *
          int.parse(hiringForm.hiring.empNum)).toString();
      modelList.add(hiringForm.hiring);
    }
    hiringFormProvider.saveHiringForms(modelList);
    hiringFormProvider.getEmployeeListByJobRoles(selectedJobRolesId).then((result){
      List<Employee> availableEmployees= result;
      roles= roles.where((element) =>selectedJobRolesId.contains(element.id)).toList();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => new EmployerRequestedEmpNotification(widget.employer,availableEmployees,roles)));
    });
  }

  ///on save forms
  void onSave() {
    if (hiringList.length > 0) {
      var allValid = true;
      hiringList.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        var data = hiringList.map((it) => it.hiring).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('List of Selected Employees'),
              ),
              body: ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    child: Text(data[i].empNum.toString()),
                  ),
                  title: Text(roles.where((element) => element.id==data[i].jobRole).first.name),
                  subtitle: Text(data[i].jobShift),
                  trailing: Text("Rs." + (int.parse(data[i].totalAmount)* int.parse(data[i].empNum)).toString()),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: calculateTotal(),
                onPressed: onSubmit,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }

  calculateTotal() {
    var data = hiringList.map((it) => it.hiring).toList();
    int totalAmount=0;
    for(var hire in data)
      {
        totalAmount+= int.parse(hire.totalAmount)* int.parse(hire.empNum);
      }
    return Text("Pay Total Rs." + totalAmount.toString());
  }
}