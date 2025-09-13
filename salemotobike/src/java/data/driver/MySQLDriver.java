
package data.driver;

import data.utils.Constants;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySQLDriver {
      private static Connection connection = null;
    public static Connection getConnection() {
        if (connection == null) {
            try {
                Class.forName("com.mysql.jdbc.Driver"); 
                connection = DriverManager.getConnection(Constants.DB_URL, Constants.USER, Constants.PASS);
                System.out.println("Kết nối thành công tới database!");
            } catch (ClassNotFoundException | SQLException e) {
                System.err.println("Không thể kết nối CSDL: " + e.getMessage());
            }
        }
        return connection;
    }
}
