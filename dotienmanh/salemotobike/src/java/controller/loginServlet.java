/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import data.dao.Database;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;       // ✨ thêm
import java.sql.SQLException;
import java.util.List;                          // ✨ thêm
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "loginServlet", urlPatterns = {"/login"})
public class loginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("./views/login.jsp").include(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            User user = Database.getUserDao().find(email, password);

            if (user == null) {
                request.getSession().setAttribute("login_err", "Your information login is incorrect!");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Xóa thông báo lỗi cũ (nếu có) và ĐẶT USER VÀO SESSION TRƯỚC
            HttpSession session = request.getSession(true);
            session.removeAttribute("login_err");
            session.setAttribute("user", user);

            // (Không bắt buộc) Nạp list yêu thích vào session cho user
            try {
                var favDao = Database.getFavoriteDao();
                java.util.List<Integer> favIds = favDao.listXeIdsByUser(user.getId());
                session.setAttribute("favIds", favIds);
                session.setAttribute("favCount", favIds.size());
            } catch (Exception ignore) {
                Logger.getLogger(loginServlet.class.getName())
                        .log(Level.WARNING, "Load listfav failed", ignore);
            }

            // (Tuỳ chọn) Nếu filter có lưu URL đích sau login, ưu tiên chuyển về đó
            String after = (String) session.getAttribute("afterLogin");
            if (after != null && !after.isBlank()) {
                session.removeAttribute("afterLogin");
                response.sendRedirect(after);  // 'after' đã bao gồm context path
                return;
            }

            // Phân nhánh điều hướng giữ nguyên đường dẫn cũ
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } catch (SQLException ex) {
            Logger.getLogger(loginServlet.class.getName()).log(Level.SEVERE, null, ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
