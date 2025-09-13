package controller;

import data.dao.Database;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Xe;
import model.User; // <-- thêm import

@WebServlet(name = "xemchitietServlet", urlPatterns = {"/xemchitiet"})
public class xemchitietServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            // lấy xe như cũ
            Xe xe = Database.getXeDao().find(id);
            request.setAttribute("xe", xe); // có thể null nếu không tìm thấy

            // ---- NEW: tính trạng thái yêu thích ban đầu ----
            boolean isFav = false;
            int favCount = 0;

            User user = (User) request.getSession().getAttribute("user");
            if (user != null && xe != null) {
                var favDao = Database.getFavoriteDao();
                isFav = favDao.exists(user.getId(), id);
                favCount = favDao.countByUser(user.getId());

                // đồng bộ badge trên navbar
                request.getSession().setAttribute("favCount", favCount);
            }
            // đẩy cờ xuống JSP để set class/aria/text cho nút
            request.setAttribute("isFav", isFav);
            // -----------------------------------------------

            request.getRequestDispatcher("/views/xemchitiet.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (SQLException ex) {
            Logger.getLogger(xemchitietServlet.class.getName()).log(Level.SEVERE, null, ex);
            // fallback an toàn
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
