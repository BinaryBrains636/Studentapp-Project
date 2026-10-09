<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Details</title>
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
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 20px;
	}

	.container {
		background: white;
		border-radius: 20px;
		box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
		padding: 40px;
		max-width: 600px;
		width: 100%;
	}

	h1 {
		text-align: center;
		color: #333;
		margin-bottom: 30px;
		font-size: 28px;
		font-weight: 600;
	}

	.success-icon {
		text-align: center;
		font-size: 64px;
		margin-bottom: 20px;
	}

	.detail-row {
		display: flex;
		padding: 15px 0;
		border-bottom: 1px solid #f0f0f0;
		transition: background 0.3s ease;
	}

	.detail-row:hover {
		background: #f9f9f9;
	}

	.detail-row:last-child {
		border-bottom: none;
	}

	.label {
		flex: 1;
		font-weight: 600;
		color: #555;
		padding-right: 20px;
	}

	.value {
		flex: 1.5;
		color: #333;
	}

	.back-button {
		display: inline-block;
		padding: 12px 30px;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		color: white;
		text-decoration: none;
		border-radius: 10px;
		font-weight: 600;
		margin-top: 30px;
		transition: all 0.3s ease;
		text-align: center;
	}

	.back-button:hover {
		transform: translateY(-2px);
		box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
	}

	.button-container {
		text-align: center;
		display: flex;
		gap: 10px;
		justify-content: center;
	}
</style>
</head>
<body>
<%
	String name = request.getParameter("fullname");
	String Addr = request.getParameter("address");
	String age = request.getParameter("age");
	String Qual = request.getParameter("qual");
	String Persent = request.getParameter("percent");
	String Year = request.getParameter("yop");
%>
	<div class="container">
		<div class="success-icon">✅</div>
		<h1>Student Registered Successfully</h1>
		<div class="detail-row">
			<div class="label">Full Name</div>
			<div class="value"><%= name != null ? name : "" %></div>
		</div>
		<div class="detail-row">
			<div class="label">Address</div>
			<div class="value"><%= Addr != null ? Addr : "" %></div>
		</div>
		<div class="detail-row">
			<div class="label">Age</div>
			<div class="value"><%= age != null ? age : "" %></div>
		</div>
		<div class="detail-row">
			<div class="label">Qualification</div>
			<div class="value"><%= Qual != null ? Qual : "" %></div>
		</div>
		<div class="detail-row">
			<div class="label">Percentage</div>
			<div class="value"><%= Persent != null ? Persent : "" %>%</div>
		</div>
		<div class="detail-row">
			<div class="label">Year of Passout</div>
			<div class="value"><%= Year != null ? Year : "" %></div>
		</div>
		<div class="button-container">
			<a href="index.jsp" class="back-button">Register Another Student</a>
			<a href="viewStudents.jsp" class="back-button">View All Students</a>
		</div>
	</div>
</body>
</html>