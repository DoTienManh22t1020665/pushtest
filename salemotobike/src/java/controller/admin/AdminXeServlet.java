package controller.admin;

import data.dao.Database;
import data.dao.LoaiXeDao;
import data.dao.XeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import model.LoaiXe;
import model.Xe;

@WebServlet(name = "AdminXeServlet", urlPatterns = {"/admin/xe"})
public class AdminXeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // === Nhận param từ form (khớp với xe.jsp) ===
        String qRaw   = req.getParameter("q");
        String sort   = req.getParameter("sort");        // "new" | "old" | "asc" | "desc"
        String loai   = req.getParameter("loai");        // idloaixe
        String pStr   = req.getParameter("page");
        String sStr   = req.getParameter("size");

        String q = trimOrNull(qRaw);

        // Chuẩn hóa sort
        if (sort == null || sort.isBlank()) sort = "new";
        Set<String> allowedSort = Set.of("new", "old", "asc", "desc");
        if (!allowedSort.contains(sort)) sort = "new";

        // Page/size
        int page = parseIntOrDefault(pStr, 1);
        int size = parseIntOrDefault(sStr, 12);
        size = Math.max(6, Math.min(size, 48));
        page = Math.max(1, page);
        int offset = (page - 1) * size;

        // Loại xe (nullable)
        Integer loaixe = null;
        try {
            if (loai != null && !loai.isBlank()) {
                loaixe = Integer.valueOf(loai);
            }
        } catch (NumberFormatException ignore) {}

        try {
            XeDao xeDao = Database.getXeDao();

            // === Đếm & lấy danh sách ===
            int total = xeDao.countAdmin(q, loaixe);
            List<Xe> list = xeDao.searchAdmin(q, loaixe, sort, offset, size);

            // === Tính trang ===
            int pages = (int) Math.ceil(total / (double) size);
            if (pages == 0) pages = 1;
            if (page > pages) page = pages;

            // === Danh sách loại (đổ vào dropdown) ===
            LoaiXeDao loaiDao = Database.getLoaiXeDao();
            List<LoaiXe> dsLoai = loaiDao.findAll();

            // (tuỳ chọn) Map id->tên để hiển thị tên loại trong bảng
            Map<Integer, String> mapLoai = new HashMap<>();
            for (LoaiXe lx : dsLoai) {
                mapLoai.put(lx.getIdloaixe(), lx.getTenloaixe());
            }

            // === Flash từ session (nếu có) ===
            HttpSession ss = req.getSession(false);
            if (ss != null) {
                Object ok = ss.getAttribute("flash");
                Object er = ss.getAttribute("flash_err");
                if (ok != null) { req.setAttribute("flash", ok); ss.removeAttribute("flash"); }
                if (er != null) { req.setAttribute("flash_err", er); ss.removeAttribute("flash_err"); }
            }

            // === Gắn attribute cho JSP ===
            req.setAttribute("listXe", list);
            req.setAttribute("total", total);
            req.setAttribute("page", page);
            req.setAttribute("pages", pages);     // 👉 JSP đang dùng biến này
            req.setAttribute("size", size);
            req.setAttribute("dsLoai", dsLoai);
            req.setAttribute("mapLoai", mapLoai);

            // (không bắt buộc) echo lại tham số
            req.setAttribute("q", q == null ? "" : q);
            req.setAttribute("sort", sort);
            req.setAttribute("loai", loaixe);

            req.getRequestDispatcher("/views/admin/xe.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // ================= helpers =================
    private static String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
    private static int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
