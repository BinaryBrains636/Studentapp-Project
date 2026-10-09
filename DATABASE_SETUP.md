# Database Setup Instructions

## Prerequisites
- MySQL Server installed and running
- Maven for building the project
- Tomcat server for deployment

## Step 1: Create Database and Table

Run the SQL script to create the database and table:

```bash
mysql -u root -p < source-code/database/schema.sql
```

Or manually execute the SQL commands in MySQL:

```sql
CREATE DATABASE IF NOT EXISTS studentdb;

USE studentdb;

CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_addr VARCHAR(200) NOT NULL,
    student_age VARCHAR(10) NOT NULL,
    student_qual VARCHAR(100) NOT NULL,
    student_percent VARCHAR(10) NOT NULL,
    student_year_passed VARCHAR(10) NOT NULL
);
```

## Step 2: Update Database Credentials

Edit the database credentials in `source-code/student/WEB-INF/web.xml`:

```xml
<context-param>
  <param-name>dbUrl</param-name>
  <param-value>jdbc:mysql://localhost:3306/studentdb?useSSL=false&amp;serverTimezone=UTC&amp;allowPublicKeyRetrieval=true</param-value>
</context-param>
<context-param>
  <param-name>dbUsername</param-name>
  <param-value>root</param-value>
</context-param>
<context-param>
  <param-name>dbPassword</param-name>
  <param-value>root</param-value>
</context-param>
```

Replace:
- `root` (username) with your MySQL username
- `root` (password) with your MySQL password

## Step 3: Build the Project

```bash
mvn clean package
```

This will:
- Download the MySQL connector dependency
- Compile the Java source files
- Build the WAR file in the `target/` directory

## Step 4: Deploy to Tomcat

Copy the generated WAR file to Tomcat's webapps directory:

```bash
cp target/studentapp-2.2-SNAPSHOT.war /path/to/tomcat/webapps/studentapp.war
```

Or deploy using Tomcat Manager.

## Step 5: Verify Connection

1. Start Tomcat server
2. Access the application at: `http://localhost:8081/studentapp/`
3. Register a student
4. View the student list to verify database connectivity

## Troubleshooting

### Connection Issues
- Ensure MySQL server is running
- Verify username and password in web.xml
- Check that the database `studentdb` exists
- Verify MySQL is listening on port 3306

### Driver Issues
- Ensure MySQL connector is in the classpath
- The dependency is already added in pom.xml
- Check that mysql-connector-java-8.0.33.jar is included in the WAR

### Compilation Issues
- Ensure Java source files are in `source-code/backend/src/`
- Verify pom.xml has correct source directory configuration
- Check that all servlet classes are properly annotated or mapped in web.xml

## Database Configuration Details

The application uses direct JDBC connection (no JNDI):

- **Configuration Location**: `WEB-INF/web.xml` as context parameters
- **Connection Method**: Direct JDBC using DriverManager
- **Driver**: MySQL Connector/J 8.0.33
- **Database**: studentdb
- **Table**: students

This approach keeps all database configuration within the application's web.xml, making it self-contained and easier to manage without requiring server-level configuration.
