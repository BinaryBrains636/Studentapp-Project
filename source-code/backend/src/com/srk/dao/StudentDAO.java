package com.srk.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import vo.Student;

public class StudentDAO {

    private static String getDbUrl(ServletContext context) {
        return context.getInitParameter("dbUrl");
    }

    private static String getDbUsername(ServletContext context) {
        return context.getInitParameter("dbUsername");
    }

    private static String getDbPassword(ServletContext context) {
        return context.getInitParameter("dbPassword");
    }

    public static Connection getConnection(ServletContext context) throws Exception {
        String url = getDbUrl(context);
        String username = getDbUsername(context);
        String password = getDbPassword(context);

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, username, password);
    }

    public static int saveStudent(Student student, ServletContext context) {
        int status = 0;
        try {
            Connection con = getConnection(context);
            PreparedStatement ps = con.prepareStatement(
                "insert into students(student_name,student_addr,student_age,student_qual,student_percent,student_year_passed) values (?,?,?,?,?,?)");
            ps.setString(1, student.getStudentName());
            ps.setString(2, student.getStudentAddr());
            ps.setString(3, student.getAge());
            ps.setString(4, student.getQualification());
            ps.setString(5, student.getPercentage());
            ps.setString(6, student.getYearPassed());
            status = ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int updateStudent(Student student, ServletContext context) {
        int status = 0;
        try {
            Connection con = getConnection(context);
            PreparedStatement ps = con.prepareStatement(
                "update students set student_name=?,student_addr=?,student_age=?,student_qual=?,student_percent=?,student_year_passed=? where student_id=?");
            ps.setString(1, student.getStudentName());
            ps.setString(2, student.getStudentAddr());
            ps.setString(3, student.getAge());
            ps.setString(4, student.getQualification());
            ps.setString(5, student.getPercentage());
            ps.setString(6, student.getYearPassed());
            ps.setInt(7, student.getStudentId());
            status = ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int deleteStudent(int id, ServletContext context) {
        int status = 0;
        try {
            Connection con = getConnection(context);
            PreparedStatement ps = con.prepareStatement("delete from students where student_id=?");
            ps.setInt(1, id);
            status = ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static Student getStudentById(int id, ServletContext context) {
        Student student = new Student();
        try {
            Connection con = getConnection(context);
            PreparedStatement ps = con.prepareStatement("select * from students where student_id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student.setStudentId(rs.getInt("student_id"));
                student.setStudentName(rs.getString("student_name"));
                student.setStudentAddr(rs.getString("student_addr"));
                student.setAge(rs.getString("student_age"));
                student.setQualification(rs.getString("student_qual"));
                student.setPercentage(rs.getString("student_percent"));
                student.setYearPassed(rs.getString("student_year_passed"));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return student;
    }

    public static List<Student> getAllStudents(ServletContext context) {
        List<Student> list = new ArrayList<Student>();
        try {
            Connection con = getConnection(context);
            PreparedStatement ps = con.prepareStatement("select * from students");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setStudentName(rs.getString("student_name"));
                student.setStudentAddr(rs.getString("student_addr"));
                student.setAge(rs.getString("student_age"));
                student.setQualification(rs.getString("student_qual"));
                student.setPercentage(rs.getString("student_percent"));
                student.setYearPassed(rs.getString("student_year_passed"));
                list.add(student);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
