# Use official Node image
FROM node:19-alpine3.16

# Set working directory
WORKDIR /react-app

# Copy dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the app source
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the app
CMD ["npm", "start"]

