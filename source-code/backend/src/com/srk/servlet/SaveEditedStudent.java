package com.srk.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.srk.dao.StudentDAO;
import vo.Student;

public class SaveEditedStudent extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        ServletContext context = getServletContext();

        String sid = request.getParameter("stdId");
        int id = Integer.parseInt(sid);
        String name = request.getParameter("stdname");
        String addrs = request.getParameter("stdaddrs");
        String age = request.getParameter("stdage");
        String qual = request.getParameter("stdqual");
        String percent = request.getParameter("stdpercent");
        String yearpass = request.getParameter("stdyearpass");

        Student student = new Student();
        student.setStudentId(id);
        student.setStudentName(name);
        student.setStudentAddr(addrs);
        student.setAge(age);
        student.setQualification(qual);
        student.setPercentage(percent);
        student.setYearPassed(yearpass);

        int status = StudentDAO.updateStudent(student, context);
        if (status > 0) {
            response.sendRedirect("viewStudents");
        } else {
            out.println("Sorry! unable to update record");
        }
        out.close();
    }
}
