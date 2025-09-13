/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package data.dao;

import java.util.List;
import model.User;
import java.sql.SQLException;

/**
 *
 * @author ADMIN
 */
public interface UserDao {
    public User find(String emailphone, String password);
    public boolean insert(String username, String email,String fullname,  String password,String phone,String address);
    public boolean check(String emailphone);
    List<User> searchAdmin(String q, String role, String sort, int offset, int limit) throws SQLException;
    int countAdmin(String q, String role) throws SQLException;

    boolean insert(User u) throws SQLException;
    boolean update(User u, boolean changePassword) throws SQLException;
    boolean delete(int id) throws SQLException;

    User find(int id) throws SQLException;
}
