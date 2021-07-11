class EnemyData {
  final String name;
  final int width, height, rowsIdle, rowsRun, columnsIdle, columnsRun;
  final double speed;
  final bool canFly;

  EnemyData({
    required this.name,
    required this.width,
    required this.height,
    required this.rowsIdle,
    required this.rowsRun,
    required this.columnsIdle,
    required this.columnsRun,
    required this.speed,
    required this.canFly,
  });
}
