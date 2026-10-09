<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="vo.Student" %>
<%@ page import="com.srk.dao.StudentDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Students List</title>
<style>
	* {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
	}

	body {
		font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		min-height: 100vh;
		padding: 20px;
	}

	.container {
		max-width: 1200px;
		margin: 0 auto;
		background: white;
		border-radius: 20px;
		box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
		padding: 40px;
	}

	.header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 30px;
	}

	h1 {
		color: #333;
		font-size: 28px;
		font-weight: 600;
	}

	.add-button {
		padding: 12px 25px;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		color: white;
		text-decoration: none;
		border-radius: 10px;
		font-weight: 600;
		transition: all 0.3s ease;
	}

	.add-button:hover {
		transform: translateY(-2px);
		box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
	}

	table {
		width: 100%;
		border-collapse: collapse;
		margin-top: 20px;
	}

	thead {
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		color: white;
	}

	th {
		padding: 15px;
		text-align: left;
		font-weight: 600;
		font-size: 14px;
		text-transform: uppercase;
		letter-spacing: 0.5px;
	}

	tbody tr {
		border-bottom: 1px solid #f0f0f0;
		transition: background 0.3s ease;
	}

	tbody tr:hover {
		background: #f9f9f9;
	}

	td {
		padding: 15px;
		color: #555;
		font-size: 14px;
	}

	.action-buttons {
		display: flex;
		gap: 10px;
	}

	.edit-button {
		padding: 8px 16px;
		background: #4CAF50;
		color: white;
		text-decoration: none;
		border-radius: 6px;
		font-size: 13px;
		font-weight: 500;
		transition: all 0.3s ease;
	}

	.edit-button:hover {
		background: #45a049;
		transform: translateY(-1px);
	}

	.delete-button {
		padding: 8px 16px;
		background: #f44336;
		color: white;
		text-decoration: none;
		border-radius: 6px;
		font-size: 13px;
		font-weight: 500;
		transition: all 0.3s ease;
	}

	.delete-button:hover {
		background: #da190b;
		transform: translateY(-1px);
	}

	.no-data {
		text-align: center;
		padding: 40px;
		color: #999;
		font-size: 16px;
	}

	.empty-state {
		text-align: center;
		padding: 60px 20px;
	}

	.empty-state-icon {
		font-size: 64px;
		margin-bottom: 20px;
	}

	.empty-state-text {
		color: #666;
		font-size: 18px;
		margin-bottom: 20px;
	}
</style>
</head>
<body>
	<div class="container">
		<div class="header">
			<h1>🎓 Students List</h1>
			<a href="index.jsp" class="add-button">+ Register Student</a>
		</div>

		<%
			List<Student> students = StudentDAO.getAllStudents();
			if (students == null || students.isEmpty()) {
		%>
			<div class="empty-state">
				<div class="empty-state-icon">📋</div>
				<div class="empty-state-text">No students registered yet</div>
				<a href="index.jsp" class="add-button">Register First Student</a>
			</div>
		<%
			} else {
		%>
		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>Name</th>
					<th>Address</th>
					<th>Age</th>
					<th>Qualification</th>
					<th>Percentage</th>
					<th>Year</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody>
				<%
					for (Student student : students) {
				%>
				<tr>
					<td><%= student.getStudentId() %></td>
					<td><%= student.getStudentName() %></td>
					<td><%= student.getStudentAddr() %></td>
					<td><%= student.getAge() %></td>
					<td><%= student.getQualification() %></td>
					<td><%= student.getPercentage() %>%</td>
					<td><%= student.getYearPassed() %></td>
					<td>
						<div class="action-buttons">
							<a href="editStudent?stdId=<%= student.getStudentId() %>" class="edit-button">Edit</a>
							<a href="deleteStudent?stdId=<%= student.getStudentId() %>" class="delete-button">Delete</a>
						</div>
					</td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<%
			}
		%>
	</div>
</body>
</html>
