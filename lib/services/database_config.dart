//database_config

import 'package:mysql1/mysql1.dart';

class DatabaseConfig {
  static final settings = ConnectionSettings(
      host: 'your_host',
      port: 3306,
      user: 'your_username',
      password: 'your_password',
      db: 'your_database'
  );

  static Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(settings);
  }
}