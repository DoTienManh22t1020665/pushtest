/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import data.dao.Database;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "registerServlet", urlPatterns = {"/register"})
public class registerServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        request.getRequestDispatcher("./views/register.jsp").include(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // processRequest(request, response);
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String fullname = request.getParameter("fullname");
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            boolean x = true;
            request.getSession().removeAttribute("pass_err");
            request.getSession().removeAttribute("email_err");
            request.getSession().removeAttribute("phone_err");
            
            if (password == "" || !password.equals(confirm)) {
                request.getSession().setAttribute("pass_err", "Passwords are not the same!");
                x = false;
            }
            if (Database.getUserDao().check(email)) {
                request.getSession().setAttribute("email_err", "Email already exists!");
                x = false;
            }
            if (Database.getUserDao().check(phone)) {
                request.getSession().setAttribute("phone_err", "Phone already exists!");
                x = false;
            }
            if (x) {
                try {
                    User user = Database.getUserDao().find(email, password);
                    Database.getUserDao().insert(username, email, fullname, password,phone, address);
                    request.getSession().setAttribute("user", user);
                    response.sendRedirect("login");
                } catch (SQLException ex) {
                    Logger.getLogger(registerServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else {
                response.sendRedirect("register");
            }
        } catch (SQLException ex) {
            Logger.getLogger(registerServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
