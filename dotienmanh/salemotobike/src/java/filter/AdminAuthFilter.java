package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {"/admin/*", "/admin"})
public class AdminAuthFilter implements Filter {
  @Override public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {

    HttpServletRequest req  = (HttpServletRequest) request;
    HttpServletResponse resp = (HttpServletResponse) response;

    HttpSession session = req.getSession(false);
    User user = (session == null) ? null : (User) session.getAttribute("user");

    if (user == null) {
      resp.sendRedirect(req.getContextPath() + "/login");
      return;
    }
    if (user.getRole() == null || !"admin".equalsIgnoreCase(user.getRole())) {
      // Không đủ quyền
      resp.sendRedirect(req.getContextPath() + "/home");
      return;
    }
    chain.doFilter(request, response);
  }
}

