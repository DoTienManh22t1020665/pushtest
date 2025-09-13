package controller;

import data.dao.Database;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import model.User;

@WebServlet(name="FavToggleServlet", urlPatterns={"/fav/toggle"})
public class FavToggleServlet extends HttpServlet {

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json; charset=UTF-8");
    PrintWriter out = resp.getWriter();

    User user = (User) req.getSession().getAttribute("user");
    if (user == null) { resp.setStatus(401); out.print("{\"ok\":false,\"reason\":\"not_logged_in\"}"); return; }

    int xeId;
    try { xeId = Integer.parseInt(req.getParameter("id")); }
    catch (Exception e){ resp.setStatus(400); out.print("{\"ok\":false}"); return; }

    try {
      var fav = Database.getFavoriteDao();
      boolean existed = fav.exists(user.getId(), xeId);
      boolean ok = existed ? fav.remove(user.getId(), xeId) : fav.add(user.getId(), xeId);
      int count = fav.countByUser(user.getId());

      // ✨ Đồng bộ session
      HttpSession session = req.getSession();
      Object obj = session.getAttribute("favIds");
      if (obj instanceof java.util.List) {
          @SuppressWarnings("unchecked")
          java.util.List<Integer> favIds = (java.util.List<Integer>) obj;
          if (existed) favIds.remove(Integer.valueOf(xeId));
          else if (!favIds.contains(xeId)) favIds.add(xeId);
      }
      session.setAttribute("favCount", count);

      out.printf("{\"ok\":%s,\"state\":\"%s\",\"count\":%d}",
                  ok?"true":"false", existed?"removed":"added", count);
    } catch (Exception e){
      resp.setStatus(500);
      out.print("{\"ok\":false}");
    }
  }
}
