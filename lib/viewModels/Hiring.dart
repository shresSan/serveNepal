import 'JobRoles.dart';
import 'JobShifts.dart';

class Hiring {
  JobRoles jobRole;
  int numOfEmp;
  JobShifts shift;
  int pricePerRole;

  Hiring({this.jobRole, this.numOfEmp, this.shift, this.pricePerRole});
}
