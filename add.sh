#!/bin/bash

# Language and encoding
export LANG=en_US.UTF-8

# Text colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Function to display a loading animation
show_loading_animation() {
  local delay=0.5
  local count=0

  printf "   "
  while true; do
    printf "\b"
    case $((count % 4)) in
      0) printf "." ;;
      1) printf ".." ;;
      2) printf "..." ;;
      3) printf "   " ;;
    esac
    ((count++))
    sleep ${delay}
  done
}

# Function to configure Nginx
configure_nginx() {
  local domain=$1
  local port=$2

  echo -e "${YELLOW}Creating the domain folder...${NC}"
  if mkdir /var/www/$domain; then
    echo -e "${GREEN}Folder created successfully.${NC}"
  else
    echo -e "${RED}Error creating the folder.${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Creating the basic HTML page...${NC}"
  if echo "<html><body><h1>Welcome to $domain</h1></body></html>" > /var/www/$domain/index.html; then
    echo -e "${GREEN}HTML page created successfully.${NC}"
  else
    echo -e "${RED}Error creating the HTML page.${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Creating the configuration file for $domain...${NC}"
  if touch $domain; then
    echo -e "${GREEN}Configuration file created successfully.${NC}"
  else
    echo -e "${RED}Error creating the configuration file.${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Generating the SSL certificate...${NC}"
  show_loading_animation &
  spinner_pid=$!

  if certbot certonly --nginx -d $domain > /dev/null 2>&1; then
    kill $spinner_pid
    printf "\b\b\b   \n"
    echo -e "${GREEN}SSL certificate generated successfully.${NC}"
  else
    kill $spinner_pid
    printf "\b\b\b   \n"
    echo -e "${RED}Error generating the SSL certificate.${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Configuring the Nginx server...${NC}"
  {
    echo "server {"
    echo "    listen 443 ssl;"
    echo "    server_name $domain;"
    echo "    root /var/www/$domain;"
    echo "    index index.html;"
    echo ""
    echo "    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;"
    echo "    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;"
    echo ""
    echo "    include /etc/letsencrypt/options-ssl-nginx.conf;"
    echo ""
    if [ "$mode" = "1" ]; then
      echo "    location / {"
      echo "        try_files \$uri \$uri/ /index.html;"
      echo "    }"
    fi
    echo ""
    if [ "$port" ]; then
      echo "    location / {"
      echo "        proxy_pass http://localhost:$port;"
      echo "        proxy_set_header Host \$host;"
      echo "        proxy_set_header X-

Real-IP \$remote_addr;"
      echo "        proxy_set_header X-Forwarded-Proto \$scheme;"
      echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;"
      echo "    }"
    fi
    echo "    access_log /var/log/nginx/access.log;"
    echo "    error_log /var/log/nginx/error.log;"
    echo "}"
    echo ""
    echo "server {"
    echo "    listen 80;"
    echo "    server_name $domain;"
    echo "    return 301 https://\$host\$request_uri;"
    echo "}"
  } >> $domain
}

echo -e "${YELLOW}Choose the mode:${NC}"
echo "1. Single Page Application"
echo "2. Classic Website"
echo "3. API"
read -p "Enter the corresponding mode number: " mode

case $mode in
1)
  # Single Page Application Mode
  echo -e "${YELLOW}Enter the domain name: ${NC}"
  read -p "" domain
  configure_nginx $domain
  ;;
2)
  # Classic Website Mode
  echo -e "${YELLOW}Enter the domain name: ${NC}"
  read -p "" domain
  configure_nginx $domain
  ;;
3)
  # API Mode
  echo -e "${YELLOW}Enter the domain name: ${NC}"
  read -p "" domain
  echo -e "${YELLOW}Enter the API port: ${NC}"
  read -p "" port
  configure_nginx $domain $port
  ;;
*)
  echo -e "${RED}Invalid mode. Exiting the script.${NC}"
  exit 1
  ;;
esac

echo -e "${GREEN}Finishing...${NC}"
if cp $domain /etc/nginx/sites-available/ && mv $domain /etc/nginx/sites-enabled/; then
  echo -e "${GREEN}Nginx configuration file created successfully.${NC}"
else
  echo -e "${RED}Error copying the Nginx configuration file.${NC}"
  exit 1
fi

echo -e "${YELLOW}Restarting the Nginx server${NC}"
if service nginx restart; then
  echo -e "${GREEN}Nginx server restarted successfully.${NC}"
else
  echo -e "${RED}Error restarting the Nginx server.${NC}"
  exit 1
fi

echo -e "${GREEN}The script has finished.${NC}"
