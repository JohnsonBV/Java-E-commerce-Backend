# Use OpenJDK base image
FROM openjdk:17-jdk-slim

# Set work directory
WORKDIR /app

# Copy the built jar file dynamically (assumes only one jar exists in target/)
COPY target/*.jar app.jar

# Expose the port your app runs on
EXPOSE 9090

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
