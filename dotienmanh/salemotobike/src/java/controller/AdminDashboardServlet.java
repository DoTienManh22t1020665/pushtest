/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import data.driver.MySQLDriver;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet(name="AdminDashboardServlet", urlPatterns={"/admin"})
public class AdminDashboardServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    // Lấy số liệu
    int totalXe = 0, totalUsers = 0, totalFavs = 0;
    List<Map<String,Object>> topXe = new ArrayList<>();
    List<Map<String,Object>> recentFav = new ArrayList<>();

    Connection con = MySQLDriver.getConnection();
    if (con != null) {
      try {
        // Tổng số
        try (Statement st = con.createStatement()) {
          try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM xe")) {
            if (rs.next()) totalXe = rs.getInt(1);
          }
        }
        // CHANGED: quote bảng `user`
        try (Statement st = con.createStatement()) {
          try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM `user`")) {
            if (rs.next()) totalUsers = rs.getInt(1);
          }
        }
        try (Statement st = con.createStatement()) {
          try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM listfav")) {
            if (rs.next()) totalFavs = rs.getInt(1);
          }
        }

        // Top 5 xe được yêu thích (giữ nguyên)
        final String sqlTop =
          "SELECT x.id, x.tenxe, x.img, COUNT(f.id) AS favs " +
          "FROM xe x JOIN listfav f ON f.idxe = x.id " +
          "GROUP BY x.id, x.tenxe, x.img " +
          "ORDER BY favs DESC LIMIT 5";
        try (PreparedStatement ps = con.prepareStatement(sqlTop);
             ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
            Map<String,Object> m = new HashMap<>();
            m.put("id", rs.getInt("id"));
            m.put("tenxe", rs.getString("tenxe"));
            m.put("img", rs.getString("img"));
            m.put("favs", rs.getInt("favs"));
            topXe.add(m);
          }
        }

        // CHANGED: Favorites mới nhất — dùng f.created_at thật, sắp xếp đúng
        final String sqlRecent =
          "SELECT f.id, f.iduser, u.email, f.idxe, x.tenxe, f.created_at AS created_at " +
          "FROM listfav f " +
          "JOIN `user` u ON u.id = f.iduser " +
          "JOIN xe   x ON x.id = f.idxe " +
          "ORDER BY f.created_at DESC, f.id DESC LIMIT 10";
        try (PreparedStatement ps = con.prepareStatement(sqlRecent);
             ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
            Map<String,Object> m = new HashMap<>();
            m.put("id", rs.getInt("id"));
            m.put("userId", rs.getInt("iduser"));
            m.put("userEmail", rs.getString("email"));
            m.put("xeId", rs.getInt("idxe"));
            m.put("tenxe", rs.getString("tenxe"));
            m.put("createdAt", rs.getTimestamp("created_at"));
            recentFav.add(m);
          }
        }
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }

    req.setAttribute("totalXe", totalXe);
    req.setAttribute("totalUsers", totalUsers);
    req.setAttribute("totalFavs", totalFavs);
    req.setAttribute("topXe", topXe);
    req.setAttribute("recentFav", recentFav);

    req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
  }
}
