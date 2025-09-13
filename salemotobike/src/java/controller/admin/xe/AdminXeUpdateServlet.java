/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin.xe;


import data.dao.Database;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import model.Xe;

@WebServlet("/admin/xe/update")
public class AdminXeUpdateServlet extends HttpServlet {
  @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String cpath = req.getContextPath();

    try {
      int id      = Integer.parseInt(req.getParameter("id"));
      String ten  = req.getParameter("tenxe");
      String giaS = req.getParameter("giaban");
      String img  = req.getParameter("img");
      String img1 = empty(req.getParameter("img1"));
      String img2 = empty(req.getParameter("img2"));
      String img3 = empty(req.getParameter("img3"));
      String img4 = empty(req.getParameter("img4"));
      String tn   = empty(req.getParameter("tinhnang"));
      String tk   = empty(req.getParameter("thietke"));
      String dc   = empty(req.getParameter("dongco"));
      String ta   = empty(req.getParameter("tienich")); // name cũ bạn dùng
      int loaixe  = Integer.parseInt(req.getParameter("loaixe"));
      boolean xemoi = "on".equalsIgnoreCase(req.getParameter("xemoi")) ||
                      "true".equalsIgnoreCase(req.getParameter("xemoi"));

      Double giaban = 0d;
      if (giaS != null && !giaS.isBlank()) {
        giaban = Double.parseDouble(giaS.replace(",", "").trim());
      }

      Xe x = new Xe(
        id, ten, 0, giaban, img, img1, img2, img3, img4,
        tn, tk, dc, ta, loaixe, xemoi
      );

      boolean ok = Database.getXeDao().update(x);
      resp.sendRedirect(cpath + "/admin/xe?msg=" + (ok ? "updated" : "update_failed"));
    } catch (Exception e) {
      e.printStackTrace();
      resp.sendRedirect(cpath + "/admin/xe?msg=update_error");
    }
  }

  private String empty(String s){ return (s==null || s.isBlank()) ? null : s; }
}
