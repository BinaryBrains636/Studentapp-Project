# Multi-stage build for Student Application
# Stage 1: Build the WAR file with Maven
FROM maven:3.9-eclipse-temurin-8 AS build

WORKDIR /app

# Copy pom.xml and download dependencies (cached layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY source-code ./source-code

# Build the WAR file
RUN mvn clean package -DskipTests

# Stage 2: Run with Tomcat
FROM tomcat:9.0-jdk8

# Copy the WAR file from build stage
COPY --from=build /app/target/studentapp-2.2-SNAPSHOT.war /usr/local/tomcat/webapps/studentapp.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
