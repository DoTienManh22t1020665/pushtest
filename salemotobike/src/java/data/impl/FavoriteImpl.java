package data.impl;

import data.dao.FavoriteDao;
import data.driver.MySQLDriver;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Xe;

public class FavoriteImpl implements FavoriteDao {
    private static final Connection con = MySQLDriver.getConnection();

    @Override
    public boolean add(int userId, int xeId) {
        final String sql = "INSERT IGNORE INTO listfav(iduser, idxe) VALUES(?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, xeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean remove(int userId, int xeId) {
        final String sql = "DELETE FROM listfav WHERE iduser=? AND idxe=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, xeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean exists(int userId, int xeId) {
        final String sql = "SELECT 1 FROM listfav WHERE iduser=? AND idxe=? LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, xeId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public int countByUser(int userId) {
        final String sql = "SELECT COUNT(*) FROM listfav WHERE iduser=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public List<Integer> listXeIdsByUser(int userId) {
        List<Integer> ids = new ArrayList<>();
        final String sql = "SELECT idxe FROM listfav WHERE iduser=? ORDER BY id DESC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ids;
    }

    @Override
    public List<Xe> listXeByUser(int userId) {
        List<Xe> list = new ArrayList<>();
        final String sql =
            "SELECT x.* FROM xe x JOIN listfav f ON x.id = f.idxe " +
            "WHERE f.iduser=? ORDER BY f.id DESC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapXe(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Map 1 row -> Xe (giống XeImpl.mapRow)
    private Xe mapXe(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String tenxe = rs.getString("tenxe");
        int idmau = rs.getInt("idmau");
        double giaban = rs.getDouble("giaban");
        String img  = rs.getString("img");
        String img1 = rs.getString("img1");
        String img2 = rs.getString("img2");
        String img3 = rs.getString("img3");
        String img4 = rs.getString("img4");
        String tinhnang = rs.getString("tinhnang");
        String thietke  = rs.getString("thietke");
        String dongco   = rs.getString("dongco");
        String tienichantoan = rs.getString("tienichantoan");
        int loaixe = rs.getInt("loaixe");
        boolean xemoi;
        try { xemoi = rs.getBoolean("xemoi"); } catch (SQLException ignore) { xemoi = true; }

        return new Xe(id, tenxe, idmau, giaban,
                      img, img1, img2, img3, img4,
                      tinhnang, thietke, dongco, tienichantoan,
                      loaixe, xemoi);
    }
}
