package data.impl;

import data.dao.XeDao;
import data.driver.MySQLDriver;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import model.Xe;

public class XeImpl implements XeDao {

    private static final Logger LOG = Logger.getLogger(XeImpl.class.getName());
    public static Connection con = MySQLDriver.getConnection();

    // Quy ước ID loại xe (tránh "magic numbers" rải rác code)
    private static final int LOAI_TAY_GA = 1;
    private static final int LOAI_XE_SO = 2;
    private static final int LOAI_CON_TAY = 3;
    private static final int LOAI_XE_DIEN = 4;

    @Override
    public List<Xe> findAll() {
        List<Xe> listXe = new ArrayList<>();
        final String sql = "SELECT * FROM xe";
        if (con == null) {
            System.err.println("Database connection is null!");
            return listXe;
        }
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                listXe.add(mapRow(rs));
            }
            LOG.info("Found " + listXe.size() + " xe");
        } catch (SQLException ex) {
            System.err.println("SQL Error in findAll(): " + ex.getMessage());
            ex.printStackTrace();
        }
        return listXe;
    }

    // --------- CÁC HÀM LỌC ---------
    @Override
    public List<Xe> findByLoai(int idLoai) {
        List<Xe> list = new ArrayList<>();
        final String sql = "SELECT * FROM xe WHERE loaixe = ?"; // cột FK đến bảng loaixe
        if (con == null) {
            return list;
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idLoai);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException ex) {
            System.err.println("SQL Error in findByLoai(): " + ex.getMessage());
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Xe> findXeTayGa() {
        return findByLoai(LOAI_TAY_GA);
    }

    @Override
    public List<Xe> findXeSo() {
        return findByLoai(LOAI_XE_SO);
    }

    @Override
    public List<Xe> findXeConTay() {
        return findByLoai(LOAI_CON_TAY);
    }

    @Override
    public List<Xe> findXeDien() {
        return findByLoai(LOAI_XE_DIEN);
    }

    // --------- CRUD còn lại (giữ nguyên stub của bạn) ---------
    @Override
    public boolean insert(Xe xe) {
        return true;
    }

    @Override
    public boolean delete(int id) {
        return true;
    }

    @Override
    public Xe find(int id) {
        final String sql = "SELECT * FROM xe WHERE id = ?"; // Nếu PK là 'idxe' thì đổi lại cho đúng
        if (con == null) {
            System.err.println("Database connection is null!");
            return null;
        }
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs); // đã map đủ: tenxe, giaban, img1..img4, tinhnang, thietke, dongco, tienichantoan...
                }
            }
        } catch (SQLException ex) {
            System.err.println("SQL Error in find(): " + ex.getMessage());
            ex.printStackTrace();
        }
        return null;
    }

    // --------- Helper: map 1 row -> Xe ---------
    private Xe mapRow(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String tenxe = rs.getString("tenxe");
        int idmau = rs.getInt("idmau");
        double giaban = rs.getDouble("giaban");
        String img = rs.getString("img");
        String img1 = rs.getString("img1");
        String img2 = rs.getString("img2");
        String img3 = rs.getString("img3");
        String img4 = rs.getString("img4");
        String tinhnang = rs.getString("tinhnang");
        String thietke = rs.getString("thietke");
        String dongco = rs.getString("dongco");          // ✅ Sửa: đọc đúng cột dongco
        String tienichantoan = rs.getString("tienichantoan");
        int loaixe = rs.getInt("loaixe");                  // ✅ Sửa: không dùng id thay cho loaixe
        boolean xemoi;
        try {
            // nếu có cột xemoi trong DB
            xemoi = rs.getBoolean("xemoi");
        } catch (SQLException ignore) {
            // nếu không có, set mặc định
            xemoi = true;
        }

        // Khởi tạo theo đúng constructor của bạn:
        return new Xe(
                id, tenxe, idmau, giaban,
                img, img1, img2, img3, img4,
                tinhnang, thietke, dongco, tienichantoan,
                loaixe, xemoi
        );
    }

    @Override
    public int countAdmin(String q, Integer loaixe) throws SQLException {
        StringBuilder sb = new StringBuilder("SELECT COUNT(*) FROM xe WHERE 1=1");
        if (q != null && !q.isBlank()) {
            sb.append(" AND (tenxe LIKE ? OR tinhnang LIKE ? OR thietke LIKE ?)");
        }
        if (loaixe != null) {
            sb.append(" AND loaixe=?");
        }

        try (PreparedStatement ps = con.prepareStatement(sb.toString())) {
            int idx = 1;
            if (q != null && !q.isBlank()) {
                String like = "%" + q + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (loaixe != null) {
                ps.setInt(idx++, loaixe);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    @Override
    public List<Xe> searchAdmin(String q, Integer loaixe, String sort, int offset, int limit) throws SQLException {
        StringBuilder sb = new StringBuilder(
                "SELECT * FROM xe WHERE 1=1"
        );
        if (q != null && !q.isBlank()) {
            sb.append(" AND (tenxe LIKE ? OR tinhnang LIKE ? OR thietke LIKE ?)");
        }
        if (loaixe != null) {
            sb.append(" AND loaixe=?");
        }

        // sort mapping
        String orderBy;
        switch (sort == null ? "" : sort) {
            case "name_asc" ->
                orderBy = "tenxe ASC";
            case "name_desc" ->
                orderBy = "tenxe DESC";
            case "price_asc" ->
                orderBy = "giaban ASC";
            case "price_desc" ->
                orderBy = "giaban DESC";
            case "oldest" ->
                orderBy = "id ASC";
            default ->
                orderBy = "id DESC"; // newest
        }
        sb.append(" ORDER BY ").append(orderBy).append(" LIMIT ? OFFSET ?");

        try (PreparedStatement ps = con.prepareStatement(sb.toString())) {
            int idx = 1;
            if (q != null && !q.isBlank()) {
                String like = "%" + q + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (loaixe != null) {
                ps.setInt(idx++, loaixe);
            }
            ps.setInt(idx++, limit);
            ps.setInt(idx, offset);

            List<Xe> list = new java.util.ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs)); // dùng mapXe/mapRow hiện có của bạn
                }
            }
            return list;
        }
    }

    @Override
    public int insertAdmin(Xe x) throws SQLException {
        String sql = "INSERT INTO xe (tenxe, giaban, img, img1, img2, img3, img4, "
                + "tinhnang, thietke, dongco, tienichantoan, loaixe, xemoi) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";

        // dùng con có sẵn trong DAO (giống UserImpl)
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, x.getTenxe());
            ps.setBigDecimal(2, BigDecimal.valueOf(x.getGiaban()));
            ps.setString(3, x.getImg());
            ps.setString(4, x.getImg1());
            ps.setString(5, x.getImg2());
            ps.setString(6, x.getImg3());
            ps.setString(7, x.getImg4());
            ps.setString(8, x.getTinhnang());
            ps.setString(9, x.getThietke());
            ps.setString(10, x.getDongco());
            ps.setString(11, x.getTienichantoan());
            ps.setInt(12, x.getLoaixe());
            ps.setBoolean(13, x.isXemoi());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);   // id mới
                    }
                }
            }
            return 0;
        }
    }

    @Override
    public boolean update(Xe x) throws SQLException {
        String sql = "UPDATE xe SET tenxe=?, giaban=?, img=?, img1=?, img2=?, img3=?, img4=?, "
                + "tinhnang=?, thietke=?, dongco=?, tienichantoan=?, loaixe=?, xemoi=? "
                + "WHERE id=?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, x.getTenxe());
            // giaban của bạn là Double -> dùng setDouble (giả sử không null)
            ps.setDouble(2, x.getGiaban() == null ? 0d : x.getGiaban());
            ps.setString(3, x.getImg());
            ps.setString(4, x.getImg1());
            ps.setString(5, x.getImg2());
            ps.setString(6, x.getImg3());
            ps.setString(7, x.getImg4());
            ps.setString(8, x.getTinhnang());
            ps.setString(9, x.getThietke());
            ps.setString(10, x.getDongco());
            ps.setString(11, x.getTienichantoan());
            ps.setInt(12, x.getLoaixe());
            ps.setBoolean(13, x.isXemoi());
            ps.setInt(14, x.getId());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xoá xe và những bảng con có tham chiếu idxe (nếu chưa ON DELETE CASCADE)
     */
    @Override
    public boolean deleteCascade(int id) throws SQLException {
        boolean ok = false;
        boolean oldAuto = con.getAutoCommit();
        con.setAutoCommit(false);
        try (
                PreparedStatement ps1 = con.prepareStatement("DELETE FROM mau WHERE idxe=?"); PreparedStatement ps2 = con.prepareStatement("DELETE FROM dongco WHERE idxe=?"); PreparedStatement ps3 = con.prepareStatement("DELETE FROM listfav WHERE idxe=?"); PreparedStatement ps4 = con.prepareStatement("DELETE FROM xe WHERE id=?")) {
            ps1.setInt(1, id);
            ps1.executeUpdate();
            ps2.setInt(1, id);
            ps2.executeUpdate();
            ps3.setInt(1, id);
            ps3.executeUpdate();
            ps4.setInt(1, id);
            ok = ps4.executeUpdate() > 0;

            con.commit();
        } catch (SQLException ex) {
            con.rollback();
            throw ex;
        } finally {
            con.setAutoCommit(oldAuto);
        }
        return ok;
    }
    @Override
  public List<Xe> search(String keyword, Integer loaixeId, String sort, int offset, int limit) {
    List<Xe> list = new ArrayList<>();
    if (con == null) return list;

    String like = "%" + keyword.toLowerCase() + "%";

    StringBuilder sql = new StringBuilder();
    sql.append(
      "SELECT id, tenxe, giaban, img, img1, img2, img3, img4, loaixe, xemoi " +
      "FROM xe " +
      "WHERE (" +
      "  LOWER(COALESCE(tenxe,'')) LIKE ? OR " +
      "  LOWER(COALESCE(tinhnang,'')) LIKE ? OR " +
      "  LOWER(COALESCE(thietke,'')) LIKE ? OR " +
      "  LOWER(COALESCE(dongco,'')) LIKE ? OR " +
      "  LOWER(COALESCE(tienichantoan,'')) LIKE ?" +
      ") "
    );

    if (loaixeId != null) {
      sql.append("AND loaixe = ? ");
    }

    // sort "rel": tên khớp ưu tiên, sau đó theo tên
    if (sort == null || sort.equals("rel")) {
      sql.append("ORDER BY (CASE WHEN LOWER(tenxe) LIKE ? THEN 0 ELSE 1 END), tenxe ASC ");
    } else if ("price_asc".equals(sort)) {
      sql.append("ORDER BY giaban ASC ");
    } else if ("price_desc".equals(sort)) {
      sql.append("ORDER BY giaban DESC ");
    } else {
      sql.append("ORDER BY tenxe ASC ");
    }

    sql.append("LIMIT ? OFFSET ?");

    try (PreparedStatement st = con.prepareStatement(sql.toString())) {
      int i = 1;
      st.setString(i++, like);
      st.setString(i++, like);
      st.setString(i++, like);
      st.setString(i++, like);
      st.setString(i++, like);
      if (loaixeId != null) st.setInt(i++, loaixeId);
      if (sort == null || sort.equals("rel")) st.setString(i++, like); // cho CASE WHEN
      st.setInt(i++, limit);
      st.setInt(i++, offset);

      try (ResultSet rs = st.executeQuery()) {
        while (rs.next()) {
            double p = rs.getDouble("giaban");
  // ✅ set Double, giữ null nếu cột NULL

          Xe x = new Xe();
          x.setId(rs.getInt("id"));
          x.setTenxe(rs.getString("tenxe"));
          x.setGiaban(rs.wasNull() ? null : p); 
          x.setImg(rs.getString("img"));
          x.setImg1(rs.getString("img1"));
          x.setImg2(rs.getString("img2"));
          x.setImg3(rs.getString("img3"));
          x.setImg4(rs.getString("img4"));
          x.setLoaixe(rs.getInt("loaixe"));
          x.setXemoi(rs.getBoolean("xemoi"));
          list.add(x);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return list;
  }

  @Override
  public int countSearch(String keyword, Integer loaixeId) {
    if (con == null) return 0;

    String like = "%" + keyword.toLowerCase() + "%";
    StringBuilder sql = new StringBuilder();
    sql.append(
      "SELECT COUNT(*) " +
      "FROM xe " +
      "WHERE (" +
      "  LOWER(COALESCE(tenxe,'')) LIKE ? OR " +
      "  LOWER(COALESCE(tinhnang,'')) LIKE ? OR " +
      "  LOWER(COALESCE(thietke,'')) LIKE ? OR " +
      "  LOWER(COALESCE(dongco,'')) LIKE ? OR " +
      "  LOWER(COALESCE(tienichantoan,'')) LIKE ?" +
      ") "
    );
    if (loaixeId != null) {
      sql.append("AND loaixe = ? ");
    }

    try (PreparedStatement st = con.prepareStatement(sql.toString())) {
      int i = 1;
      st.setString(i++, like);
      st.setString(i++, like);
      st.setString(i++, like);
      st.setString(i++, like);
      st.setString(i++, like);
      if (loaixeId != null) st.setInt(i++, loaixeId);

      try (ResultSet rs = st.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return 0;
  }

}
