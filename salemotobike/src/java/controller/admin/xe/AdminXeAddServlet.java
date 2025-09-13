/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin.xe;

import data.dao.Database;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import model.Xe;

@WebServlet(name="AdminXeAddServlet", urlPatterns={"/admin/xe/add"})
public class AdminXeAddServlet extends HttpServlet {

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");

    String tenxe   = trim(req.getParameter("tenxe"));
    String giabanS = trim(req.getParameter("giaban"));
    String img     = trim(req.getParameter("img"));
    String img1    = trim(req.getParameter("img1"));
    String img2    = trim(req.getParameter("img2"));
    String img3    = trim(req.getParameter("img3"));
    String img4    = trim(req.getParameter("img4"));
    String tinhnang = trim(req.getParameter("tinhnang"));
    String thietke  = trim(req.getParameter("thietke"));
    String dongco   = trim(req.getParameter("dongco"));
    String tienich  = trim(req.getParameter("tienichantoan"));
    String loaixeS  = trim(req.getParameter("loaixe"));
    boolean xemoi   = "on".equals(req.getParameter("xemoi")) || "1".equals(req.getParameter("xemoi"));

    HttpSession session = req.getSession();

    // validate tối thiểu
    if (tenxe.isEmpty() || giabanS.isEmpty() || img.isEmpty() || loaixeS.isEmpty()) {
      session.setAttribute("flash_err", "Vui lòng nhập đủ Tên xe, Giá bán, Ảnh chính và Loại xe.");
      resp.sendRedirect(req.getContextPath() + "/admin/xe");
      return;
    }

    try {
         Double giaban = null;
      if (giabanS != null && !giabanS.trim().isEmpty()) {
        // Loại bỏ ký tự không phải số hoặc dấu chấm, và bỏ dấu phẩy phân tách
        String cleaned = giabanS.replaceAll("[^\\d.,]", "").trim();
        // Quy ước: dùng dấu chấm làm thập phân, bỏ dấu phẩy (thường là phân tách hàng nghìn)
        cleaned = cleaned.replace(",", "");
        if (!cleaned.isEmpty()) {
            giaban = Double.valueOf(cleaned);
        }
    }
      int loaixe = Integer.parseInt(loaixeS);

      Xe x = new Xe();
      x.setTenxe(tenxe);
      x.setGiaban(giaban);
      x.setImg(img);
      x.setImg1(emptyToNull(img1));
      x.setImg2(emptyToNull(img2));
      x.setImg3(emptyToNull(img3));
      x.setImg4(emptyToNull(img4));
      x.setTinhnang(emptyToNull(tinhnang));
      x.setThietke(emptyToNull(thietke));
      x.setDongco(emptyToNull(dongco));
      x.setTienichantoan(emptyToNull(tienich));
      x.setLoaixe(loaixe);
      x.setXemoi(xemoi);

      int newId = Database.getXeDao().insertAdmin(x);
      if (newId > 0) {
        session.setAttribute("flash", "Đã thêm xe #" + newId + " thành công.");
      } else {
        session.setAttribute("flash_err", "Không thể thêm xe. Vui lòng thử lại.");
      }
    } catch (NumberFormatException e) {
      session.setAttribute("flash_err", "Giá/Loại xe không hợp lệ.");
    } catch (SQLException e) {
      session.setAttribute("flash_err", "Lỗi CSDL: " + e.getMessage());
    }

    resp.sendRedirect(req.getContextPath() + "/admin/xe");
  }

  private static String trim(String s){ return s==null ? "" : s.trim(); }
  private static String emptyToNull(String s){ s = trim(s); return s.isEmpty()? null : s; }
}

