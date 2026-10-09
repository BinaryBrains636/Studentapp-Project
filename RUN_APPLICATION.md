# Complete Steps to Run the Student Application

This document provides multiple ways to run the Student Application:

1. **Local Development** - Run locally with MySQL and Tomcat
2. **Docker** - Run with Docker Compose
3. **EC2** - Deploy to AWS EC2
4. **EKS** - Deploy to AWS EKS
5. **Jenkins CI/CD** - Automated pipeline

Choose the method that best fits your needs.

---

## Method 1: Local Development

### Prerequisites
- Java 8 or higher installed
- Maven installed
- MySQL Server installed and running
- Tomcat 9.x installed

---

## Step 1: Set Up MySQL Database

### 1.1 Start MySQL Server
```bash
# If MySQL is installed via Homebrew
brew services start mysql

# Or start it manually
mysql.server start
```

### 1.2 Create Database and Table
```bash
# Navigate to project directory
cd /Users/ishika/Desktop/studentapp

# Run the schema script
mysql -u root -p < source-code/database/schema.sql
```

**Or execute SQL manually:**
```bash
mysql -u root -p
```

Then run these commands:
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

EXIT;
```

---

## Step 2: Configure Database Credentials

### 2.1 Open web.xml
```bash
open /Users/ishika/Desktop/studentapp/source-code/student/WEB-INF/web.xml
```

### 2.2 Update Database Credentials
Find these lines in web.xml (around lines 11-19):

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

**Replace with your MySQL credentials:**
- Change `root` (first one) to your MySQL username
- Change `root` (second one) to your MySQL password

**Example:**
```xml
<context-param>
  <param-name>dbUsername</param-name>
  <param-value>your_mysql_username</param-value>
</context-param>
<context-param>
  <param-name>dbPassword</param-name>
  <param-value>your_mysql_password</param-value>
</context-param>
```

---

## Step 3: Build the Project with Maven

### 3.1 Navigate to Project Directory
```bash
cd /Users/ishika/Desktop/studentapp
```

### 3.2 Clean and Build
```bash
mvn clean package
```

**Expected Output:**
```
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  X.XXX s
```

This will:
- Download MySQL connector dependency (if not already cached)
- Compile all Java source files
- Create WAR file at: `target/studentapp-2.2-SNAPSHOT.war`

---

## Step 4: Deploy to Tomcat

### 4.1 Stop Tomcat (if running)
```bash
cd /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/bin
bash shutdown.sh
```

### 4.2 Clean Previous Deployments
```bash
# Remove old deployment directories and WAR files
cd /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/webapps
rm -rf studentapp student student.war studentapp.war
```

### 4.3 Deploy New WAR File
```bash
# Copy the new WAR file
cp /Users/ishika/Desktop/studentapp/target/studentapp-2.2-SNAPSHOT.war \
   /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/webapps/studentapp.war
```

### 4.4 Start Tomcat
```bash
cd /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/bin
bash startup.sh
```

**Expected Output:**
```
Tomcat started.
```

---

## Step 5: Verify Deployment

### 5.1 Wait for Tomcat to Start
```bash
sleep 5
```

### 5.2 Check if Application is Running
```bash
curl -I http://localhost:8081/studentapp/
```

**Expected Output:**
```
HTTP/1.1 200 OK
```

### 5.3 Check Tomcat Logs (if needed)
```bash
tail -50 /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/logs/catalina.out
```

---

## Step 6: Access the Application

### 6.1 Open in Browser
Navigate to:
```
http://localhost:8081/studentapp/
```

Or:
```
http://127.0.0.1:8081/studentapp/
```

### 6.2 Test the Application
1. **Register a Student:**
   - Fill in the registration form
   - Click "Register Student"
   - You should see the success page

2. **View Students List:**
   - Click "View All Students" or navigate to `http://localhost:8081/studentapp/viewStudents`
   - You should see the table with registered students

3. **Edit a Student:**
   - Click "Edit" button next to a student
   - Modify the details
   - Click "Update Student"

4. **Delete a Student:**
   - Click "Delete" button next to a student
   - Confirm deletion

---

## Step 7: Verify Database Connection

### 7.1 Check MySQL
```bash
mysql -u root -p -e "USE studentdb; SELECT * FROM students;"
```

You should see the student records you created through the application.

---

## Troubleshooting

### Issue: "Connection refused" to MySQL
**Solution:**
```bash
# Check if MySQL is running
brew services list | grep mysql

# Start MySQL if not running
brew services start mysql

# Or
mysql.server start
```

### Issue: "Access denied for user"
**Solution:**
- Verify your MySQL username and password in web.xml
- Make sure the user has privileges to access the studentdb database

### Issue: Tomcat 404 error
**Solution:**
```bash
# Check if WAR file is deployed
ls -la /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/webapps/

# Check Tomcat logs for errors
tail -100 /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/logs/catalina.out
```

### Issue: Build fails with compilation errors
**Solution:**
```bash
# Clean Maven cache
mvn clean

# Rebuild
mvn package
```

### Issue: Port 8081 already in use
**Solution:**
```bash
# Find what's using the port
lsof -i :8081

# Kill the process if needed
kill -9 <PID>

# Or change port in server.xml
```

---

## Quick Reference Commands

```bash
# Full setup and deployment (one-liner)
cd /Users/ishika/Desktop/studentapp && \
mysql -u root -p < source-code/database/schema.sql && \
mvn clean package && \
rm -rf /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/webapps/studentapp* && \
cp target/studentapp-2.2-SNAPSHOT.war /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/webapps/studentapp.war && \
cd /Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/bin && \
bash shutdown.sh && sleep 2 && bash startup.sh
```

---

## File Locations Reference

| File/Directory | Path |
|----------------|------|
| Project Root | `/Users/ishika/Desktop/studentapp` |
| Java Source | `/Users/ishika/Desktop/studentapp/source-code/backend/src/` |
| JSP Files | `/Users/ishika/Desktop/studentapp/source-code/student/` |
| web.xml | `/Users/ishika/Desktop/studentapp/source-code/student/WEB-INF/web.xml` |
| Schema SQL | `/Users/ishika/Desktop/studentapp/source-code/database/schema.sql` |
| pom.xml | `/Users/ishika/Desktop/studentapp/pom.xml` |
| WAR Output | `/Users/ishika/Desktop/studentapp/target/studentapp-2.2-SNAPSHOT.war` |
| Tomcat Webapps | `/Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/webapps/` |
| Tomcat Logs | `/Users/ishika/Desktop/studentapp/deployment/tomcat/apache-tomcat-9.0.122/logs/` |

---

## Application URLs

| Purpose | URL |
|---------|-----|
| Home/Registration | `http://localhost:8081/studentapp/` |
| View Students | `http://localhost:8081/studentapp/viewStudents` |
| Edit Student | `http://localhost:8081/studentapp/editStudent?stdId=<id>` |
| Delete Student | `http://localhost:8081/studentapp/deleteStudent?stdId=<id>` |

---

## Summary

1. **Start MySQL** and create the database using schema.sql
2. **Update credentials** in web.xml with your MySQL username/password
3. **Build the project** with `mvn clean package`
4. **Deploy WAR file** to Tomcat's webapps directory
5. **Start Tomcat** and wait for it to initialize
6. **Access the application** at `http://localhost:8081/studentapp/`
7. **Test the features** - register, view, edit, and delete students

That's it! Your application should now be running with direct database connectivity configured in web.xml.

---

## Method 2: Docker

### Prerequisites
- Docker installed
- Docker Compose installed

### Quick Start

```bash
cd /Users/ishika/Desktop/studentapp
docker-compose up -d
```

### Access the Application

Navigate to: `http://localhost:8080/studentapp/`

### Stop the Application

```bash
docker-compose down
```

### View Logs

```bash
docker-compose logs -f
```

### View Container Status

```bash
docker-compose ps
```

---

## Method 3: EC2 Deployment

### Prerequisites
- Terraform installed
- AWS CLI configured
- SSH key pair

### Quick Start

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your configuration
terraform init
terraform apply
```

### Access the Application

After Terraform completes, get the application URL:

```bash
terraform output application_url
```

### SSH to EC2 Instance

```bash
terraform output ssh_connection_string
```

### View Logs on EC2

```bash
ssh -i <private-key> ubuntu@<instance-public-dns>
cd ~/studentapp
docker compose logs -f
```

### Destroy Infrastructure

```bash
terraform destroy
```

For detailed instructions, see [terraform/README.md](terraform/README.md)

---

## Method 4: EKS Deployment

### Prerequisites
- Terraform installed
- AWS CLI configured
- kubectl installed
- Docker installed

### Quick Start

#### 1. Create EKS Cluster

```bash
cd eks-terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your configuration
terraform init
terraform apply
```

#### 2. Configure kubectl

```bash
aws eks update-kubeconfig --name studentapp-eks-cluster --region us-west-2
kubectl get nodes
```

#### 3. Build Docker Image

```bash
cd ..
docker build -t studentapp:latest .
```

#### 4. Deploy to EKS

```bash
cd k8s
kubectl apply -f .
```

#### 5. Access the Application

Get the LoadBalancer URL:

```bash
kubectl get svc studentapp -n studentapp
```

Access at: `http://<loadbalancer-url>/studentapp/`

### Destroy Infrastructure

```bash
cd ../eks-terraform
terraform destroy
```

For detailed instructions, see [eks-terraform/README.md](eks-terraform/README.md)

---

## Method 5: Jenkins CI/CD

### Prerequisites
- Docker installed
- Docker Compose installed
- AWS CLI configured
- kubectl configured
- EKS cluster running

### Quick Start

#### 1. Start Jenkins

```bash
cd jenkins
./setup-jenkins.sh
```

#### 2. Access Jenkins

Navigate to: `http://localhost:8081`

#### 3. Configure Jenkins

1. Unlock Jenkins with initial admin password
2. Install suggested plugins
3. Create admin user
4. Configure credentials (Docker, AWS, kubeconfig)
5. Create Pipeline job pointing to your repository

#### 4. Run Pipeline

Click "Build Now" in Jenkins to trigger the CI/CD pipeline.

### Pipeline Stages

1. Checkout code
2. Build application with Maven
3. Run unit tests
4. Build Docker image
5. Push to Docker registry
6. Deploy to EKS
7. Verify deployment

For detailed instructions, see [JENKINS_SETUP.md](JENKINS_SETUP.md) and [jenkins/README.md](jenkins/README.md)

---

## Deployment Comparison

| Method | Complexity | Scalability | Cost | Best For |
|--------|-----------|-------------|------|----------|
| Local Development | Low | None | Free | Development, testing |
| Docker | Low | Medium | Low | Local testing, demo |
| EC2 | Medium | Medium | Low-Medium | Single instance deployment |
| EKS | High | High | Medium-High | Production, microservices |
| Jenkins CI/CD | High | High | Medium-High | Automated deployments |

---

## Quick Reference

### Run Locally
```bash
mysql -u root -p < source-code/database/schema.sql
mvn clean package
cp target/studentapp-2.2-SNAPSHOT.war <tomcat-path>/webapps/studentapp.war
<tomcat-path>/bin/startup.sh
```

### Run with Docker
```bash
docker-compose up -d
```

### Deploy to EC2
```bash
cd terraform && terraform apply
```

### Deploy to EKS
```bash
cd eks-terraform && terraform apply
aws eks update-kubeconfig --name studentapp-eks-cluster
cd ../k8s && kubectl apply -f .
```

### Run Jenkins
```bash
cd jenkins && ./setup-jenkins.sh
```

---

## Additional Documentation

- [DATABASE_SETUP.md](DATABASE_SETUP.md) - Database configuration details
- [terraform/README.md](terraform/README.md) - EC2 deployment guide
- [eks-terraform/README.md](eks-terraform/README.md) - EKS deployment guide
- [JENKINS_SETUP.md](JENKINS_SETUP.md) - Jenkins CI/CD setup guide
- [jenkins/README.md](jenkins/README.md) - Jenkins configuration details
