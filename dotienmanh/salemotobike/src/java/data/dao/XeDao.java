/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package data.dao;

import java.sql.SQLException;
import java.util.List;
import model.Xe;

public interface XeDao {

    List<Xe> findAll();

    // Lọc theo ID loại (tổng quát)
    List<Xe> findByLoai(int idLoai);

    // Các hàm tiện lợi cho từng nhóm
    List<Xe> findXeTayGa();   // loaixe = 1

    List<Xe> findXeSo();      // loaixe = 2

    List<Xe> findXeConTay();  // loaixe = 3

    List<Xe> findXeDien();    // loaixe = 4

    boolean insert(Xe xe);

    boolean delete(int id);

    Xe find(int id);

    List<Xe> searchAdmin(String q, Integer loaixe, String sort, int offset, int limit) throws SQLException;

    int countAdmin(String q, Integer loaixe) throws SQLException;

    int insertAdmin(Xe x) throws java.sql.SQLException;
    // interface XeDao (nếu có)

    boolean update(Xe x) throws SQLException;

    boolean deleteCascade(int id) throws SQLException;

    List<Xe> search(String keyword, Integer loaixeId, String sort, int offset, int limit);

    int countSearch(String keyword, Integer loaixeId);
}
