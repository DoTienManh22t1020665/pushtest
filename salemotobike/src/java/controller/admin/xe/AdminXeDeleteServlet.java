/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin.xe;


import data.dao.Database;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/xe/delete")
public class AdminXeDeleteServlet extends HttpServlet {
  @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws IOException {
    String cpath = req.getContextPath();
    try {
      int id = Integer.parseInt(req.getParameter("id"));
      boolean ok = Database.getXeDao().deleteCascade(id);
      resp.sendRedirect(cpath + "/admin/xe?msg=" + (ok ? "deleted" : "delete_failed"));
    } catch (Exception e) {
      e.printStackTrace();
      resp.sendRedirect(cpath + "/admin/xe?msg=delete_error");
    }
  }
}
