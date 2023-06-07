[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/benjivrd/nginx-domain-tools/blob/main/README.md)
[![fr](https://img.shields.io/badge/lang-fr-blue.svg)](https://github.com/benjivrd/nginx-domain-tools/blob/main/README-FR.md)
[![fr](https://img.shields.io/github/downloads/benjivrd/nginx-domain-tools/total)](https://img.shields.io/github/downloads/benjivrd/nginx-domain-tools/total)
[![fr](https://img.shields.io/github/commit-activity/w/benjivrd/nginx-domain-tools)](https://img.shields.io/github/downloads/benjivrd/nginx-domain-tools/total)

# Nginx Management Scripts

This repository contains Bash scripts to facilitate the configuration and management of websites with Nginx. The scripts automate some common tasks such as creating new sites, adding SSL certificates, and deleting existing sites.

## Prerequisites

Before using these scripts, make sure you have installed the following:

- [Nginx](https://nginx.org/) - A popular and high-performance web server.
```bash
sudo apt update
sudo apt install nginx
```
- [Certbot](https://certbot.eff.org/) - A tool for generating and managing Let's Encrypt SSL/TLS certificates.
```bash
sudo apt install certbot python3-certbot-nginx
```

Also, ensure that you have administrator rights on your system to successfully execute the scripts.

## Installation

1. Clone this repository to your local machine:

```bash
git clone https://github.com/benjivrd/nginx-domain-tools.git
```
2. Navigate to the project directory:

```bash
cd nginx-domain-tools
```
3. Add read and execute permissions to the scripts:

```bash
sudo chmod +x add.sh delete.sh
```
## Usage

### Configuring a New Website

1. Run the `add.sh` script.

2. Choose the mode that corresponds to your type of website:
   - Single Page Application Mode: Use this option if you are developing a single-page application.
   - Classic Website Mode: Choose this option if you have a traditional website with multiple pages.
   - API Mode: Select this option if you have an API to expose.

3. Follow the on-screen instructions to provide the necessary information, such as the domain name and optionally the API port.

4. Once the configuration is complete, the script will create the necessary folders, generate an SSL certificate using Certbot, and configure Nginx accordingly.

### Deleting an Existing Website

1. Run the `delete.sh` script.

2. Choose the domain name you want to delete from the available options.

3. Confirm the deletion when prompted.

> **Note**: This operation will delete the website folder, Nginx configuration files, and the associated SSL certificate.

## Contributions

Contributions are welcome! If you have any suggestions for improvements, fixes, or new features to add, feel free to open a pull request or raise an issue.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
