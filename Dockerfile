# Use nginx alpine for lightweight container
FROM nginx:alpine

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy website files to nginx html directory
COPY . /usr/share/nginx/html/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -fsS http://localhost/ || exit 1

# Add labels for better container management
LABEL maintainer="Hubert Zych <hubert.zych@example.com>"
LABEL description="DevOps Portfolio Website"
LABEL version="1.0"

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
