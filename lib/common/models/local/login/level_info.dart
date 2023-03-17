class LevelInfo {
  LevelInfo(
      {required this.currentLevel,
      required this.currentExp,
      required this.currentMin,
      required this.nextExp});
  static LevelInfo get zero =>
      LevelInfo(currentLevel: 0, currentExp: 0, currentMin: 0, nextExp: 0);

  ///当前等级
  int currentLevel;

  ///升到当前等级所需要的全部经验值
  int currentMin;

  ///当前经验值
  int currentExp;

  ///升到下一级所需要的全部经验值
  int nextExp;
}
