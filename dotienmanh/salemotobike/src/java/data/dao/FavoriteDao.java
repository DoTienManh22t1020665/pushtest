package data.dao;

import java.util.List;
import model.Xe;

public interface FavoriteDao {
    boolean add(int userId, int xeId);
    boolean remove(int userId, int xeId);
    boolean exists(int userId, int xeId);
    int countByUser(int userId);
    List<Integer> listXeIdsByUser(int userId);
    List<Xe> listXeByUser(int userId);

}
