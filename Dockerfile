# Use nginx alpine image for a lightweight web server
FROM nginx:alpine

# Set maintainer information
LABEL maintainer="Sid Joshi <dr34mhacks@github.com>"
LABEL description="JWTAuditor - Professional JWT Security Testing Platform"
LABEL version="1.0"

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy application files to nginx html directory
COPY . /usr/share/nginx/html/

# Create custom nginx configuration for SPA routing
RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 80;' >> /etc/nginx/conf.d/default.conf && \
    echo '    server_name localhost;' >> /etc/nginx/conf.d/default.conf && \
    echo '    root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    index index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    ' >> /etc/nginx/conf.d/default.conf && \
    echo '    # Enable gzip compression' >> /etc/nginx/conf.d/default.conf && \
    echo '    gzip on;' >> /etc/nginx/conf.d/default.conf && \
    echo '    gzip_vary on;' >> /etc/nginx/conf.d/default.conf && \
    echo '    gzip_min_length 1024;' >> /etc/nginx/conf.d/default.conf && \
    echo '    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;' >> /etc/nginx/conf.d/default.conf && \
    echo '    ' >> /etc/nginx/conf.d/default.conf && \
    echo '    # Security headers' >> /etc/nginx/conf.d/default.conf && \
    echo '    add_header X-Frame-Options "SAMEORIGIN" always;' >> /etc/nginx/conf.d/default.conf && \
    echo '    add_header X-XSS-Protection "1; mode=block" always;' >> /etc/nginx/conf.d/default.conf && \
    echo '    add_header X-Content-Type-Options "nosniff" always;' >> /etc/nginx/conf.d/default.conf && \
    echo '    add_header Referrer-Policy "no-referrer-when-downgrade" always;' >> /etc/nginx/conf.d/default.conf && \
    echo '    add_header Content-Security-Policy "default-src '\''self'\''; script-src '\''self'\'' '\''unsafe-inline'\'' '\''unsafe-eval'\'' https://cdnjs.cloudflare.com https://cdn.jsdelivr.net https://unpkg.com; style-src '\''self'\'' '\''unsafe-inline'\'' https://cdnjs.cloudflare.com; font-src '\''self'\'' https://cdnjs.cloudflare.com; img-src '\''self'\'' data: https:; connect-src '\''self'\'';" always;' >> /etc/nginx/conf.d/default.conf && \
    echo '    ' >> /etc/nginx/conf.d/default.conf && \
    echo '    # Handle SPA routing' >> /etc/nginx/conf.d/default.conf && \
    echo '    location / {' >> /etc/nginx/conf.d/default.conf && \
    echo '        try_files $uri $uri/ /index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '    ' >> /etc/nginx/conf.d/default.conf && \
    echo '    # Cache static assets' >> /etc/nginx/conf.d/default.conf && \
    echo '    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {' >> /etc/nginx/conf.d/default.conf && \
    echo '        expires 1y;' >> /etc/nginx/conf.d/default.conf && \
    echo '        add_header Cache-Control "public, immutable";' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '    ' >> /etc/nginx/conf.d/default.conf && \
    echo '    # Prevent access to sensitive files' >> /etc/nginx/conf.d/default.conf && \
    echo '    location ~ /\. {' >> /etc/nginx/conf.d/default.conf && \
    echo '        deny all;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '    ' >> /etc/nginx/conf.d/default.conf && \
    echo '    location ~ \.(md|txt|log)$ {' >> /etc/nginx/conf.d/default.conf && \
    echo '        deny all;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

# Remove git directory and other unnecessary files for production
RUN rm -rf /usr/share/nginx/html/.git* /usr/share/nginx/html/Dockerfile /usr/share/nginx/html/docker-compose.yml

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]