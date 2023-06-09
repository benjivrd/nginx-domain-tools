# Scripts de gestion de Nginx

Ce référentiel contient des scripts Bash pour faciliter la configuration et la gestion des sites web avec Nginx. Les scripts automatisent certaines tâches courantes telles que la création de nouveaux sites, l'ajout de certificats SSL et la suppression de sites existants.

## Prérequis

Avant d'utiliser ces scripts, assurez-vous d'avoir installé les éléments suivants :

- [Nginx](https://nginx.org/) - Un serveur web populaire et performant.
```bash
sudo apt update
sudo apt install nginx
```
- [Certbot](https://certbot.eff.org/) - Un outil pour générer et gérer des certificats SSL/TLS Let's Encrypt.
 ```bash
sudo apt install certbot python3-certbot-nginx
```

Assurez-vous également d'avoir les droits d'administrateur sur votre système pour exécuter les scripts avec succès.

## Installation

1. Clonez ce référentiel sur votre machine locale :
```bash
git clone https://github.com/benjivrd/nginx-domain-tools.git 
```
2. Accédez au répertoire du projet :
```bash
cd nginx-domain-tools/lib
```
3. Ajouter les droits d'écriture et de lecture pour éxecuter les scripts
```bash
sudo chmod +x add.sh delete.sh
```
## Utilisation

### Configuration d'un nouveau site web

1. Exécutez le script `add.sh` :

2. Choisissez le mode correspondant à votre type de site web :
- Mode Single Page Application : Utilisez cette option si vous développez une application à page unique.
- Mode Site Web Classique : Choisissez cette option si vous avez un site web traditionnel avec plusieurs pages.
- Mode API : Sélectionnez cette option si vous avez une API à exposer.

3. Suivez les instructions à l'écran pour fournir les informations nécessaires, telles que le nom de domaine et éventuellement le port de l'API.

4. Une fois la configuration terminée, le script créera les dossiers nécessaires, générera un certificat SSL à l'aide de Certbot et configurera Nginx en conséquence.

### Suppression d'un site web existant

1. Exécutez le script `delete.sh` :


2. Choisissez le nom de domaine que vous souhaitez supprimer parmi les options disponibles.

3. Confirmez la suppression lorsque vous y êtes invité.

> **Remarque**: Cette opération supprimera le dossier du site web, les fichiers de configuration de Nginx et le certificat SSL associé.

## Contributions

Les contributions sont les bienvenues ! Si vous avez des suggestions d'améliorations, des correctifs ou de nouvelles fonctionnalités à ajouter, n'hésitez pas à ouvrir une demande de fusion (pull request) ou à signaler un problème (issue).

## Licence

Ce projet est sous licence MIT. Consultez le fichier [LICENSE](LICENSE) pour plus d'informations.
