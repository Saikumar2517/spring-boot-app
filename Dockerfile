# Use the official Maven image as a parent image
FROM maven:3.9.6-eclipse-temurin-8 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file
COPY pom.xml .

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package

# Use AdoptOpenJDK as a parent image
FROM openjdk:8-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the compiled JAR file from the build stage to the container
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the JAR application
ENTRYPOINT exec java -Djava.security.egd=file:/dev/./urandom -jar /app/app.jar 
