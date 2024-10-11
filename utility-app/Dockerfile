# Dockerfile for the MongoDB initialization container
FROM node:16-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy the script to the container
COPY init-mongo.js .

# Install MongoDB client library
RUN npm install mongodb

# Run the script
CMD ["node", "init-mongo.js"]