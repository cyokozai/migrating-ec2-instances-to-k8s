%{ if false ~}
#!/bin/bash
# Template for user data script. This file is processed by Terraform.
# The following is a placeholder for syntax highlighting and is not executed.
%{ endif ~}
#!/bin/bash -xe

# Install necessary packages
yum update -y
yum install -y docker amazon-efs-utils nfs-utils git

# Start and enable Docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m).sha256" -o /usr/local/bin/docker-compose.sha256
cd /usr/local/bin
sha256sum -c docker-compose.sha256
if [ $? -ne 0 ]; then
    echo "Checksum verification failed for Docker Compose. Aborting."
    exit 1
fi
chmod +x /usr/local/bin/docker-compose

# Mount EFS
EFS_MOUNT_POINT=/mnt/efs_wp
mkdir -p ${EFS_MOUNT_POINT}
mount -t efs -o tls,iam ${efs_id}:/ ${EFS_MOUNT_POINT}
# Make mount permanent
echo "${efs_id}:/ ${EFS_MOUNT_POINT} efs _netdev,tls,iam 0 0" >> /etc/fstab

# Create WordPress data directory on EFS if it doesn't exist
WP_DATA_DIR=${EFS_MOUNT_POINT}/html
mkdir -p ${WP_DATA_DIR}
chown ec2-user:ec2-user ${EFS_MOUNT_POINT} -R

# Create docker-compose working directory
COMPOSE_DIR=/home/ec2-user/wordpress
mkdir -p ${COMPOSE_DIR}

# Create docker-compose.yml
cat <<EOF > ${COMPOSE_DIR}/docker-compose.yml
version: '3.8'

services:
  php:
    image: php:8.3-fpm-alpine
    restart: always
    volumes:
      - wp-data:/var/www/html
    environment:
      WORDPRESS_DB_HOST: ${db_endpoint}
      WORDPRESS_DB_USER: ${db_username}
      WORDPRESS_DB_PASSWORD: '${db_password}'
      WORDPRESS_DB_NAME: ${db_name}
    networks:
      - wp-net

  nginx:
    image: nginx:1.27.3-alpine
    restart: always
    ports:
      - "80:80"
    volumes:
      - wp-data:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php
    networks:
      - wp-net

networks:
  wp-net:

volumes:
  wp-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${WP_DATA_DIR}
EOF

# Create nginx.conf
cat <<EOF > ${COMPOSE_DIR}/nginx.conf
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.php;

    # Set client body size to handle large file uploads
    client_max_body_size 100M;

    # Add headers to serve security related headers
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Robots-Tag "none" always;
    add_header X-Download-Options "noopen" always;
    add_header X-Permitted-Cross-Domain-Policies "none" always;
    add_header Referrer-Policy "no-referrer" always;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass   php:9000;
        fastcgi_index  index.php;
        include        fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        log_not_found off;
        access_log off;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)\$ {
        expires 30d;
        log_not_found off;
    }
}
EOF

# Set correct ownership for docker-compose files
chown -R ec2-user:ec2-user ${COMPOSE_DIR}

# Run Docker Compose
cd ${COMPOSE_DIR}
/usr/local/bin/docker-compose up -d
