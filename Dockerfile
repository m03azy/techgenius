# Lightweight static site container for Google Cloud Run
FROM nginx:1.27-alpine

# Copy website files into Nginx html root
# (nginx image serves from /usr/share/nginx/html by default)
COPY . /usr/share/nginx/html

# Custom Nginx config (static file serving)
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Cloud Run expects the app to listen on $PORT (default 8080)
# Our Nginx config listens on 8080.
EXPOSE 8080

