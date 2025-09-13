package controller;

import data.dao.Database;
import data.dao.XeDao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Xe;


@WebServlet(name="SearchServlet", urlPatterns={"/search"})
public class SearchServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String q = req.getParameter("q");
    if (q == null || q.trim().isEmpty()) {
      // Trống -> đưa về trang “xem tất cả” (hoặc /home tùy bạn)
      resp.sendRedirect(req.getContextPath() + "/xemtatca");
      return;
    }
    q = q.trim();

    // Phân trang nhẹ
    int size = parseIntOrDefault(req.getParameter("size"), 12);
    size = Math.max(6, Math.min(size, 48));
    int page = parseIntOrDefault(req.getParameter("page"), 1);
    page = Math.max(1, page);
    int offset = (page - 1) * size;

    // (Tuỳ chọn) lọc theo loại bằng query ?loai=ID
    Integer loai = null;
    try {
      String loaiStr = req.getParameter("loai");
      if (loaiStr != null && !loaiStr.isEmpty()) loai = Integer.parseInt(loaiStr);
    } catch (NumberFormatException ignore){}

    XeDao xeDao = null;
      try {
          xeDao = Database.getXeDao();
      } catch (SQLException ex) {
          Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
      }
    List<Xe> listXe = xeDao.search(q, loai, "rel", offset, size);
    int total = xeDao.countSearch(q, loai);

    int pages = (int) Math.ceil((double) total / size);

    req.setAttribute("q", q);
    req.setAttribute("listXe", listXe);
    req.setAttribute("total", total);
    req.setAttribute("page", page);
    req.setAttribute("pages", pages);
    req.setAttribute("size", size);
    req.setAttribute("loai", loai);

    // mapLoai nếu bạn đã set ở chỗ khác thì bỏ; không thì có thể inject trong filter/global
    // req.setAttribute("mapLoai", ...);

    req.getRequestDispatcher("/views/search.jsp").forward(req, resp);
  }

  private int parseIntOrDefault(String s, int d){
    try{ return Integer.parseInt(s);}catch(Exception e){ return d; }
  }
}
