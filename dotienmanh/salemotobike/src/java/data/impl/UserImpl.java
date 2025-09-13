/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data.impl;

import data.dao.UserDao;
import data.driver.MySQLDriver;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
public class UserImpl implements UserDao {

    Connection con = MySQLDriver.getConnection();

    @Override
    public User find(String emailphone, String pass) {
        String sql;
        if (emailphone.contains("@")) {
            sql = "select * from user where email='" + emailphone + "' and password='" + pass + "'";
        } else {
            sql = "select * from user where phone='" + emailphone + "' and password='" + pass + "'";
        }
        try {
            PreparedStatement sttm = con.prepareStatement(sql);
            ResultSet rs = sttm.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("id");
                String username = rs.getString("username");
                String email = rs.getString("email");
                String fullname = rs.getString("fullname");
                String phone = rs.getString("phone");
                String password = rs.getString("password");
                String role = rs.getString("role");
                String address = rs.getString("address");
                return new User(id, username, email, fullname, password, phone, role, address);

            }
        } catch (SQLException ex) {
            Logger.getLogger(UserImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public boolean insert(String username, String email, String fullname, String password, String phone, String address) {
        String sql = "INSERT INTO `user`(username, email, fullname, password, phone, address) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, username);
            sttm.setString(2, email);
            sttm.setString(3, fullname);
            sttm.setString(4, password);
            sttm.setString(5, phone);
            sttm.setString(6, address);
            int rows = sttm.executeUpdate();
            System.out.println("Rows inserted: " + rows);
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;

    }

    @Override
    public boolean check(String emailphone) {
        String sql;
        if (emailphone.contains("@")) {
            sql = "select 1 from user where email='" + emailphone + "'";
        } else {
            sql = "select 1 from user where phone='" + emailphone + "'";
        }
        try {
            PreparedStatement sttm = con.prepareStatement(sql);
            ResultSet rs = sttm.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(UserImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }


    private User map(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("id"),
            rs.getString("username"),
            rs.getString("email"),
            rs.getString("fullname"),
            rs.getString("password"),
            rs.getString("phone"),
            rs.getString("role"),
            rs.getString("address")
        );
    }

    @Override
    public List<User> searchAdmin(String q, String role, String sort, int offset, int limit) throws SQLException {
        List<User> list = new ArrayList<>();
        if (con == null) return list;

        String like = "%" + (q == null ? "" : q.toLowerCase().trim()) + "%";

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT id,username,email,fullname,password,phone,role,address FROM user WHERE 1=1 ");
        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (LOWER(username) LIKE ? OR LOWER(email) LIKE ? OR LOWER(fullname) LIKE ? OR LOWER(COALESCE(phone,'')) LIKE ? OR LOWER(COALESCE(address,'')) LIKE ?) ");
        }
        if (role != null && !role.isEmpty()) {
            sql.append("AND role = ? ");
        }

        // sort: new(id desc), old(id asc), name_asc(username asc), name_desc(username desc)
        if ("old".equals(sort)) {
            sql.append("ORDER BY id ASC ");
        } else if ("name_asc".equals(sort)) {
            sql.append("ORDER BY username ASC ");
        } else if ("name_desc".equals(sort)) {
            sql.append("ORDER BY username DESC ");
        } else {
            sql.append("ORDER BY id DESC ");
        }
        sql.append("LIMIT ? OFFSET ?");

        try (PreparedStatement st = con.prepareStatement(sql.toString())) {
            int i = 1;
            if (q != null && !q.trim().isEmpty()) {
                st.setString(i++, like);
                st.setString(i++, like);
                st.setString(i++, like);
                st.setString(i++, like);
                st.setString(i++, like);
            }
            if (role != null && !role.isEmpty()) {
                st.setString(i++, role);
            }
            st.setInt(i++, limit);
            st.setInt(i++, offset);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    @Override
    public int countAdmin(String q, String role) throws SQLException {
        if (con == null) return 0;

        String like = "%" + (q == null ? "" : q.toLowerCase().trim()) + "%";
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM user WHERE 1=1 ");
        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (LOWER(username) LIKE ? OR LOWER(email) LIKE ? OR LOWER(fullname) LIKE ? OR LOWER(COALESCE(phone,'')) LIKE ? OR LOWER(COALESCE(address,'')) LIKE ?) ");
        }
        if (role != null && !role.isEmpty()) {
            sql.append("AND role = ? ");
        }

        try (PreparedStatement st = con.prepareStatement(sql.toString())) {
            int i = 1;
            if (q != null && !q.trim().isEmpty()) {
                st.setString(i++, like);
                st.setString(i++, like);
                st.setString(i++, like);
                st.setString(i++, like);
                st.setString(i++, like);
            }
            if (role != null && !role.isEmpty()) {
                st.setString(i++, role);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    @Override
    public boolean insert(User u) throws SQLException {
        if (con == null) return false;
        String sql = "INSERT INTO user(username,email,fullname,password,phone,role,address) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, u.getUsername());
            st.setString(2, u.getEmail());
            st.setString(3, u.getFullname());
            st.setString(4, u.getPassword()); // NOTE: hash nếu hệ thống bạn yêu cầu
            st.setString(5, emptyToNull(u.getPhone()));
            st.setString(6, u.getRole() == null ? "user" : u.getRole());
            st.setString(7, emptyToNull(u.getAddress()));
            return st.executeUpdate() > 0;
        }
    }

    @Override
    public boolean update(User u, boolean changePassword) throws SQLException {
        if (con == null) return false;
        StringBuilder sql = new StringBuilder();
        sql.append("UPDATE user SET username=?, email=?, fullname=?, ");
        if (changePassword) sql.append("password=?, ");
        sql.append("phone=?, role=?, address=? WHERE id=?");

        try (PreparedStatement st = con.prepareStatement(sql.toString())) {
            int i = 1;
            st.setString(i++, u.getUsername());
            st.setString(i++, u.getEmail());
            st.setString(i++, u.getFullname());
            if (changePassword) st.setString(i++, u.getPassword());
            st.setString(i++, emptyToNull(u.getPhone()));
            st.setString(i++, u.getRole() == null ? "user" : u.getRole());
            st.setString(i++, emptyToNull(u.getAddress()));
            st.setInt(i++, u.getId());
            return st.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        if (con == null) return false;
        try (PreparedStatement st = con.prepareStatement("DELETE FROM user WHERE id=?")) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        }
    }

    @Override
    public User find(int id) throws SQLException {
        if (con == null) return null;
        try (PreparedStatement st = con.prepareStatement("SELECT id,username,email,fullname,password,phone,role,address FROM user WHERE id=?")) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) { if (rs.next()) return map(rs); }
        }
        return null;
    }

    private String emptyToNull(String s){ return (s == null || s.isBlank()) ? null : s; }

}
