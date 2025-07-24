# Dockerfile

# Step 1: Use Node 20 as base image
FROM node:20

# Step 2: Set working directory
WORKDIR /app

# Step 3: Copy package files
COPY package.json yarn.lock ./

# Step 4: Install dependencies
RUN yarn install

# Step 5: Copy the rest of the project
COPY . .

# Step 6: Build the admin panel (optional but common)
RUN yarn build

# Step 7: Expose port and start
EXPOSE 1337
CMD ["yarn", "develop"]
