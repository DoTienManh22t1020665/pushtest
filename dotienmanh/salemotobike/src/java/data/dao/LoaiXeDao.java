
package data.dao;

import java.util.List;
import model.LoaiXe;


public interface LoaiXeDao {
    public List<LoaiXe> findAll();
    public boolean insert(LoaiXe loaixe);
    public boolean delete(int id);
    public boolean update(LoaiXe loaixe);
    public LoaiXe find(int id);
}
