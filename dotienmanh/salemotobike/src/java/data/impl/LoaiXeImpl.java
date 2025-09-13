
package data.impl;

import data.dao.LoaiXeDao;
import data.driver.MySQLDriver;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.LoaiXe;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.sql.SQLException;

public class LoaiXeImpl implements LoaiXeDao {
     public static Connection con = MySQLDriver.getConnection();
     @Override
     public List<LoaiXe> findAll() {
        List<LoaiXe> listLoaiXe = new ArrayList<>();
        String sql = "select * from loaixe";
        try {
            if (con == null) {
                System.err.println("Database connection is null!");
                return listLoaiXe;
            }
            PreparedStatement sttm = con.prepareStatement(sql);
            ResultSet rs = sttm.executeQuery();
            while(rs.next()){
                int idloaixe=rs.getInt("idloaixe");
                String tenloaixe= rs.getString("tenloaixe");
                listLoaiXe.add(new LoaiXe(idloaixe, tenloaixe));
            }
            System.out.println("Found " + listLoaiXe.size() + " loaixe");
        } catch (SQLException ex) {
            System.err.println("SQL Error in findAll(): " + ex.getMessage());
            Logger.getLogger(LoaiXeImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return listLoaiXe;
    }

    @Override
    public boolean insert(LoaiXe loaixe) {
        return true;
    }

    @Override
    public boolean delete(int id) {
        return true;
    }

    @Override
    public boolean update(LoaiXe loaixe) {
        return true;
    }

    @Override
    public LoaiXe find(int id) {
        return null;
    }
}
