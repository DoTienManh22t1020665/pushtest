
package data.dao;

import data.impl.FavoriteImpl;
import data.impl.LoaiXeImpl;
import data.impl.UserImpl;
import data.impl.XeImpl;
import java.sql.SQLException;

public class Database {
      public static  LoaiXeDao getLoaiXeDao() throws SQLException{
        return new LoaiXeImpl();
    }
      public static XeDao getXeDao() throws SQLException{
          return new XeImpl();
      }
      public static UserDao getUserDao() throws SQLException{
          return new UserImpl();
      }
        public static FavoriteDao getFavoriteDao() { return new FavoriteImpl(); }
        
}

