#!/bin/bash

# Text colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Function to display an error
print_error() {
  local message="$1"
  echo -e "${RED}Error: $message${NC}"
}

# Function to display a confirmation
print_confirmation() {
  local message="$1"
  echo -e "${GREEN}Confirmation: $message${NC}"
}

# Function to delete a domain
delete_domain() {
  local domain="$1"

  echo -e "${YELLOW}Deleting domain '$domain'...${NC}"

  echo -e "${YELLOW}Deleting website folder...${NC}"
  if rm -r "/var/www/$domain"; then
    print_confirmation "Website folder deleted successfully."
  else
    print_error "Error deleting website folder."
    exit 1
  fi

  echo -e "${YELLOW}Deleting domain folder...${NC}"
  if rm -r "/etc/nginx/sites-available/$domain" "/etc/nginx/sites-enabled/$domain"; then
    print_confirmation "Domain folder deleted successfully."
  else
    print_error "Error deleting domain folder."
    exit 1
  fi

  echo -e "${YELLOW}Deleting SSL certificate...${NC}"
  if certbot delete --cert-name "$domain" > /dev/null 2>&1; then
    print_confirmation "SSL certificate deleted successfully."
  else
    print_error "Error deleting SSL certificate."
    exit 1
  fi
}

# Restart Nginx server
restart_nginx() {
  echo -e "${YELLOW}Restarting Nginx server...${NC}"
  if service nginx restart; then
    print_confirmation "Nginx server restarted successfully."
  else
    print_error "Error restarting Nginx server."
    exit 1
  fi
}

# List of available domains
available_domains=(/etc/nginx/sites-available/*)

# Check if there are any domains available
if [ ${#available_domains[@]} -eq 0 ]; then
  print_error "No domains available."
  exit 1
fi

# Display available domains
echo -e "${GREEN}Available domains:${NC}"
for domain_path in "${available_domains[@]}"; do
  domain=$(basename "$domain_path")
  echo "$domain"
done

# Ask for the domain name to delete
read -p "Enter the domain name you want to delete: " domain

# Check if the domain exists
domain_exists=false
for domain_path in "${available_domains[@]}"; do
  if [ "$domain" == "$(basename "$domain_path")" ]; then
    domain_exists=true
    break
  fi
done

if ! $domain_exists; then
  print_error "The domain '$domain' does not exist."
  exit 1
fi

# Confirmation before deletion
read -p "Are you sure you want to delete the domain '$domain'? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo -e "${YELLOW}Operation cancelled.${NC}"
  exit 0
fi

# Delete the domain
delete_domain "$domain"

# Restart Nginx server
restart_nginx

echo -e "${GREEN}The domain '$domain' has been successfully deleted.${NC}"
