class JobShifts {
  int id;
  String name;

  JobShifts(this.id, this.name);

  static List<JobShifts> getJobShifts() {
    return <JobShifts>[
      JobShifts(1, 'Morning Shift (9AM - 1PM)'),
      JobShifts(2, 'Evening Shift (4PM - 9PM)')
    ];
  }
}