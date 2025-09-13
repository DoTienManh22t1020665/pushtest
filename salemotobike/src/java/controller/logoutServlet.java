/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "logoutServlet", urlPatterns = {"/logout"})
public class logoutServlet extends HttpServlet {

    /** Đặt no-cache để tránh back lại trang cũ sau khi logout */
    private void setNoCache(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0);     // Proxies
    }

    /** Xoá JSESSIONID (tuỳ chọn, tốt cho dọn dẹp) */
    private void clearSessionCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie cookie = new Cookie("JSESSIONID", "");
        // nên set path đúng context để browser xoá đúng cookie
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }

    private void performLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        setNoCache(response);

        // Lấy session nếu có, không tạo mới
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // -> xoá luôn user, favIds, favCount... trong session
        }

        // Xoá cookie phiên (tuỳ chọn)
        clearSessionCookie(request, response);

        // Về trang chủ
        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }

    /** Cho phép logout bằng POST nếu bạn gắn nút form POST */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Logout servlet - invalidate session & redirect to home";
    }
}
