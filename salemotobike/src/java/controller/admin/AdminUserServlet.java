package controller.admin;

import data.dao.Database;
import data.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

@WebServlet(name="AdminUsersServlet", urlPatterns={
        "/admin/users", "/admin/users/add", "/admin/users/update", "/admin/users/delete"
})
public class AdminUserServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        try {
            userDao = Database.getUserDao();
        } catch (SQLException ex) {
            Logger.getLogger(AdminUserServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        if ("/admin/users".equals(path)) {
            list(req, resp);
        } else {
            resp.sendError(404);
        }
    }

    private void list(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = param(req, "q");
        String role = param(req, "role");
        String sort = paramDefault(req, "sort", "new");

        int size = parseIntDefault(req.getParameter("size"), 12);
        int page = parseIntDefault(req.getParameter("page"), 1);
        size = Math.max(6, Math.min(size, 48));
        page = Math.max(1, page);
        int offset = (page - 1) * size;

        try {
            List<User> list = userDao.searchAdmin(q, role, sort, offset, size);
            int total = userDao.countAdmin(q, role);
            int pages = (int)Math.ceil((double)total / size);

            req.setAttribute("listUsers", list);
            req.setAttribute("total", total);
            req.setAttribute("page", page);
            req.setAttribute("pages", pages);
            req.setAttribute("size", size);

            req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        try {
            switch (path) {
                case "/admin/users/add" -> add(req, resp);
                case "/admin/users/update" -> update(req, resp);
                case "/admin/users/delete" -> delete(req, resp);
                default -> resp.sendError(404);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void add(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        User u = new User(
            0,
            req.getParameter("username"),
            req.getParameter("email"),
            req.getParameter("fullname"),
            req.getParameter("password"), // NOTE: hash nếu hệ thống bạn bắt buộc
            req.getParameter("phone"),
            defaultIfBlank(req.getParameter("role"), "user"),
            req.getParameter("address")
        );
        try {
            boolean ok = userDao.insert(u);
            flash(req, ok ? "Đã thêm user." : "Không thể thêm user.", !ok);
        } catch (java.sql.SQLIntegrityConstraintViolationException dup) {
            flash(req, "Username hoặc Email đã tồn tại.", true);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        int id = parseIntDefault(req.getParameter("id"), 0);
        String password = req.getParameter("password");
        boolean changePwd = password != null && !password.isBlank();

        User u = new User(
            id,
            req.getParameter("username"),
            req.getParameter("email"),
            req.getParameter("fullname"),
            changePwd ? password : null,
            req.getParameter("phone"),
            defaultIfBlank(req.getParameter("role"), "user"),
            req.getParameter("address")
        );

        boolean ok = userDao.update(u, changePwd);
        flash(req, ok ? "Đã cập nhật user." : "Không thể cập nhật user.", !ok);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        int id = parseIntDefault(req.getParameter("id"), 0);

        // Optional: chặn xóa chính mình (nếu có session user)
        Object sessUser = req.getSession().getAttribute("user");
        if (sessUser instanceof model.User mu && mu.getId() == id) {
            flash(req, "Không thể tự xóa tài khoản đang đăng nhập.", true);
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        boolean ok = userDao.delete(id);
        flash(req, ok ? "Đã xóa user." : "Không thể xóa user.", !ok);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    // Helpers
    private String param(HttpServletRequest r, String k){ String v=r.getParameter(k); return (v==null||v.isBlank())?null:v.trim(); }
    private String paramDefault(HttpServletRequest r, String k, String d){ String v=r.getParameter(k); return (v==null||v.isBlank())?d:v.trim(); }
    private int parseIntDefault(String s, int d){ try{ return Integer.parseInt(s);}catch(Exception e){ return d; } }
    private String defaultIfBlank(String s, String d){ return (s==null||s.isBlank())?d:s; }

    private void flash(HttpServletRequest req, String msg, boolean err){
        HttpSession session = req.getSession();
        if(err) session.setAttribute("flash_err", msg); else session.setAttribute("flash", msg);
    }
}
