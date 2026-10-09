<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.Student" %>
<%@ page import="com.srk.dao.StudentDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Student</title>
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
		max-width: 500px;
		width: 100%;
	}

	h1 {
		text-align: center;
		color: #333;
		margin-bottom: 30px;
		font-size: 28px;
		font-weight: 600;
	}

	.form-group {
		margin-bottom: 20px;
	}

	label {
		display: block;
		margin-bottom: 8px;
		color: #555;
		font-weight: 500;
		font-size: 14px;
	}

	input[type="text"],
	input[type="number"] {
		width: 100%;
		padding: 12px 15px;
		border: 2px solid #e0e0e0;
		border-radius: 10px;
		font-size: 15px;
		transition: all 0.3s ease;
		background: #f9f9f9;
	}

	input[type="text"]:focus,
	input[type="number"]:focus {
		outline: none;
		border-color: #667eea;
		background: white;
		box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
	}

	.button-group {
		display: flex;
		gap: 10px;
		margin-top: 20px;
	}

	button[type="submit"] {
		flex: 1;
		padding: 14px;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		color: white;
		border: none;
		border-radius: 10px;
		font-size: 16px;
		font-weight: 600;
		cursor: pointer;
		transition: all 0.3s ease;
	}

	button[type="submit"]:hover {
		transform: translateY(-2px);
		box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
	}

	.cancel-button {
		flex: 1;
		padding: 14px;
		background: #f44336;
		color: white;
		border: none;
		border-radius: 10px;
		font-size: 16px;
		font-weight: 600;
		cursor: pointer;
		transition: all 0.3s ease;
		text-decoration: none;
		text-align: center;
		display: inline-block;
	}

	.cancel-button:hover {
		background: #da190b;
		transform: translateY(-2px);
		box-shadow: 0 10px 20px rgba(244, 67, 54, 0.4);
	}

	.header-decoration {
		text-align: center;
		margin-bottom: 20px;
	}

	.header-decoration::before {
		content: "✏️";
		font-size: 48px;
		display: block;
		margin-bottom: 10px;
	}
</style>
</head>
<body>
<%
	String stdId = request.getParameter("stdId");
	Student student = StudentDAO.getStudentById(Integer.parseInt(stdId));
%>
	<div class="container">
		<div class="header-decoration"></div>
		<h1>Edit Student</h1>
		<form action="editStudent2" method="post">
			<input type="hidden" name="stdId" value="<%= student.getStudentId() %>"/>
			<div class="form-group">
				<label for="stdname">Full Name</label>
				<input type="text" id="stdname" name="stdname" value="<%= student.getStudentName() %>" required/>
			</div>
			<div class="form-group">
				<label for="stdaddrs">Address</label>
				<input type="text" id="stdaddrs" name="stdaddrs" value="<%= student.getStudentAddr() %>" required/>
			</div>
			<div class="form-group">
				<label for="stdage">Age</label>
				<input type="number" id="stdage" name="stdage" value="<%= student.getAge() %>" required/>
			</div>
			<div class="form-group">
				<label for="stdqual">Qualification</label>
				<input type="text" id="stdqual" name="stdqual" value="<%= student.getQualification() %>" required/>
			</div>
			<div class="form-group">
				<label for="stdpercent">Percentage</label>
				<input type="number" id="stdpercent" name="stdpercent" value="<%= student.getPercentage() %>" required step="0.1"/>
			</div>
			<div class="form-group">
				<label for="stdyop">Year Passed</label>
				<input type="number" id="stdyop" name="stdyop" value="<%= student.getYearPassed() %>" required/>
			</div>
			<div class="button-group">
				<button type="submit">Update Student</button>
				<a href="viewStudents.jsp" class="cancel-button">Cancel</a>
			</div>
		</form>
	</div>
</body>
</html>
