package controller;

import data.dao.Database;
import data.dao.XeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.Normalizer;
import java.util.*;
import model.Xe;

@WebServlet(name = "ChatServlet", urlPatterns = {"/api/chat"})
public class ChatServlet extends HttpServlet {

    private XeDao xeDao;

    @Override
    public void init() throws ServletException {
        try {
            xeDao = Database.getXeDao();
        } catch (SQLException e) {
            throw new ServletException("Init ChatServlet failed", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        String message = nn(req.getParameter("message")).trim();
        String m = norm(message); // không dấu + lowercase

        String reply;
        List<Map<String, String>> results = new ArrayList<>();
        List<String> suggestions = Arrays.asList("tay ga", "xe số", "côn tay", "xe điện", "giá rẻ");

        try {
            /* ====== FAQ đơn giản ====== */
            if (m.contains("bao hanh")) {
                reply = "Chính sách bảo hành theo tiêu chuẩn Honda. Bạn muốn xem chi tiết dòng xe nào?";
            } else if (m.contains("tra gop")) {
                reply = "Bên mình hỗ trợ trả góp qua nhiều đơn vị tài chính. Bạn quan tâm mẫu xe nào vậy?";
            } else {

                /* ====== Nhận diện nhóm xe (điều chỉnh id nếu DB bạn khác 1..4) ====== */
                Integer loaixe = null;
                if (has(m, "tay ga", "tayga", "tay-ga", "scooter"))      loaixe = 1;
                else if (has(m, "xe so", "xeso"))                        loaixe = 2;
                else if (has(m, "con tay", "côn tay", "contay"))         loaixe = 3;
                else if (has(m, "xe dien", "xedien", "dien"))            loaixe = 4;

                /* ====== Nhận diện sort ====== */
                String sort = "new";
                if (has(m, "re", "gia re", "thap", "thap nhat"))         sort = "asc";
                else if (has(m, "dat", "mac", "cao", "cao nhat"))        sort = "desc";

                /* ====== Làm sạch keyword nhẹ ====== */
                String kw = message.replaceAll("[^\\p{L}\\p{Nd} ]+", " ").trim();

                /* ====== Tìm kiếm: 3-pass + thử HOA/thường ====== */
                List<Xe> ls = xeDao.search(kw, loaixe, sort, 0, 5);

                if ((ls == null || ls.isEmpty()) && loaixe != null) {
                    // người dùng chọn nhóm -> chỉ theo loại
                    ls = xeDao.search("", loaixe, sort, 0, 5);
                }
                if ((ls == null || ls.isEmpty()) && !kw.isBlank()) {
                    // thử không ràng buộc loại
                    ls = xeDao.search(kw, null, sort, 0, 5);
                }
                if ((ls == null || ls.isEmpty()) && kw.length() >= 2) {
                    // một số CSDL để COLLATION phân biệt HOA/thường (hiếm)
                    ls = xeDao.search(kw.toUpperCase(Locale.ROOT), loaixe, sort, 0, 5);
                    if (ls == null || ls.isEmpty()) {
                        ls = xeDao.search(kw.toLowerCase(Locale.ROOT), loaixe, sort, 0, 5);
                    }
                }

                if (ls != null && !ls.isEmpty()) {
                    for (Xe x : ls) {
                        Map<String, String> it = new HashMap<>();
                        it.put("title", nn(x.getTenxe()));
                        it.put("url", req.getContextPath() + "/xemchitiet?id=" + x.getId());
                        Double gb = x.getGiaban();
                        it.put("price", gb == null ? "" : String.format("%,.0f ₫", gb));
                        results.add(it);
                    }
                    reply = "Mình gợi ý một vài mẫu phù hợp, bạn bấm để xem chi tiết nhé:";
                } else {
                    reply = "Mình chưa tìm thấy mẫu phù hợp. Bạn thử gõ tên xe (vd: \"Winner X\", \"Vision\") hoặc chọn nhanh bên dưới nhé.";
                }
            }
        } catch (Exception e) {
            // Tránh lộ stacktrace ra client
            reply = "Có lỗi khi tìm xe, bạn thử lại sau nhé.";
        }

        resp.getWriter().write(buildJson(reply, suggestions, results));
    }

    /* ===================== helpers ===================== */

    // Chuẩn hóa tiếng Việt: bỏ dấu + lowercase
    private static String norm(String s) {
        if (s == null) return "";
        String t = Normalizer.normalize(s, Normalizer.Form.NFD);
        t = t.replaceAll("\\p{M}+", "");
        return t.toLowerCase(Locale.ROOT);
    }

    private static boolean has(String haystack, String... needles) {
        String h = norm(haystack);
        for (String n : needles) {
            if (h.contains(norm(n))) return true;
        }
        return false;
    }

    private String buildJson(String reply, List<String> suggestions, List<Map<String, String>> results) {
        StringBuilder sb = new StringBuilder();
        sb.append("{\"reply\":\"").append(esc(reply)).append("\",");
        sb.append("\"suggestions\":[");
        for (int i = 0; i < suggestions.size(); i++) {
            if (i > 0) sb.append(',');
            sb.append('"').append(esc(suggestions.get(i))).append('"');
        }
        sb.append("],\"results\":[");
        for (int i = 0; i < results.size(); i++) {
            if (i > 0) sb.append(',');
            Map<String, String> it = results.get(i);
            sb.append("{\"title\":\"").append(esc(it.get("title"))).append("\",")
              .append("\"url\":\"").append(esc(it.get("url"))).append("\",")
              .append("\"price\":\"").append(esc(it.getOrDefault("price", ""))).append("\"}");
        }
        sb.append("]}");
        return sb.toString();
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
    }

    private String nn(String s) { return s == null ? "" : s; }
}
