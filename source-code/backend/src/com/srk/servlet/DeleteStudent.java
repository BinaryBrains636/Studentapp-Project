package com.srk.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.srk.dao.StudentDAO;

public class DeleteStudent extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        ServletContext context = getServletContext();

        String sid = request.getParameter("stdId");
        int id = Integer.parseInt(sid);

        int status = StudentDAO.deleteStudent(id, context);
        if (status > 0) {
            response.sendRedirect("viewStudents");
        } else {
            out.println("Sorry! unable to delete record");
        }
        out.close();
    }
}
