<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Registration</title>
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

	button[type="submit"] {
		width: 100%;
		padding: 14px;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		color: white;
		border: none;
		border-radius: 10px;
		font-size: 16px;
		font-weight: 600;
		cursor: pointer;
		transition: all 0.3s ease;
		margin-top: 10px;
	}

	button[type="submit"]:hover {
		transform: translateY(-2px);
		box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
	}

	button[type="submit"]:active {
		transform: translateY(0);
	}

	.header-decoration {
		text-align: center;
		margin-bottom: 20px;
	}

	.header-decoration::before {
		content: "🎓";
		font-size: 48px;
		display: block;
		margin-bottom: 10px;
	}
</style>
</head>
<body>
	<div class="container">
		<div class="header-decoration"></div>
		<h1>Student Registration</h1>
		<form action="registrationController" method="post">
			<div class="form-group">
				<label for="fullname">Student Name</label>
				<input type="text" id="fullname" name="fullname" required placeholder="Enter full name"/>
			</div>
			<div class="form-group">
				<label for="address">Student Address</label>
				<input type="text" id="address" name="address" required placeholder="Enter address"/>
			</div>
			<div class="form-group">
				<label for="age">Student Age</label>
				<input type="number" id="age" name="age" required placeholder="Enter age"/>
			</div>
			<div class="form-group">
				<label for="qual">Student Qualification</label>
				<input type="text" id="qual" name="qual" required placeholder="Enter qualification"/>
			</div>
			<div class="form-group">
				<label for="percent">Student Percentage</label>
				<input type="number" id="percent" name="percent" required placeholder="Enter percentage" step="0.1"/>
			</div>
			<div class="form-group">
				<label for="yop">Year Passed</label>
				<input type="number" id="yop" name="yop" required placeholder="Enter year"/>
			</div>
			<button type="submit">Register Student</button>
		</form>
	</div>
</body>
</html>
