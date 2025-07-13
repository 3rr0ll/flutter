class DashboardData {
  int activeFranchisees;
  int inactiveFranchisees;
  int activeOperators;
  int inactiveOperators;

  DashboardData({
    this.activeFranchisees = 0,
    this.inactiveFranchisees = 0,
    this.activeOperators = 0,
    this.inactiveOperators = 0,
  });

  int get totalFranchisees => activeFranchisees + inactiveFranchisees;
  int get totalOperators => activeOperators + inactiveOperators;

  void incrementActiveFranchisees() {
    activeFranchisees++;
  }

  void decrementActiveFranchisees() {
    if (activeFranchisees > 0) activeFranchisees--;
  }

  void incrementInactiveFranchisees() {
    inactiveFranchisees++;
  }

  void decrementInactiveFranchisees() {
    if (inactiveFranchisees > 0) inactiveFranchisees--;
  }

  void incrementActiveOperators() {
    activeOperators++;
  }

  void decrementActiveOperators() {
    if (activeOperators > 0) activeOperators--;
  }

  void incrementInactiveOperators() {
    inactiveOperators++;
  }

  void decrementInactiveOperators() {
    if (inactiveOperators > 0) inactiveOperators--;
  }
}
