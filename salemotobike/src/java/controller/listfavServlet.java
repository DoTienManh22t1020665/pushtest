package controller;

import data.dao.Database;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet(name="listfavServlet", urlPatterns={"/listfav"})
public class listfavServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    User user = (User) req.getSession().getAttribute("user");
    if (user == null) {
      resp.sendRedirect(req.getContextPath() + "/login");
      return;
    }

    var favDao = Database.getFavoriteDao();
    var listXe = favDao.listXeByUser(user.getId());
    req.setAttribute("listFavXe", listXe);

    // Cập nhật luôn badge trên navbar (nếu bạn đang hiển thị favCount)
    int favCount = favDao.countByUser(user.getId());
    req.getSession().setAttribute("favCount", favCount);

    // NOTE: dùng đường dẫn tuyệt đối
    req.getRequestDispatcher("/views/listfav.jsp").forward(req, resp);
  }
}
