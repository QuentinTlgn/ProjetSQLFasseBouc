# Projet FasseBouc

## Objectif
Réaliser une base de données similaire au réseau social « Facebook ». Parce que même les bases de données ont besoin d'amis.

## Conception

### Définitions
- **Utilisateur**: La star du spectacle, identifiée par un login.
- **Ami**: Compagnon(e) de base de données, avec qui l'on partage des informations sans se poser trop de questions.
- **Mur**: L'endroit où tout le monde vient s'épancher et partager ses états d'âme. Un peu comme un groupe de soutien virtuel.

### Fonctionnement
Un membre du 'FasseBouc' peut sympathiser avec d'autres membres, sans nécessité d'approbation pour le lien d'amitié. Les utilisateurs amis peuvent s'échanger des messages sur un mur visible par tous les utilisateurs. Parce que parfois, même une base de données a besoin d'un bon cri du cœur.

### Prototype procédural
Les procédures sont livrées dans un package nommé PackFasseBouc. Parce que même les bases de données peuvent être bien organisées.

- `ajouterUtilisateur(loginUtilisateur)`: Création d'un utilisateur.
- `supprimerUtilisateur()`: Suppression de l'utilisateur courant.
- `connexion(loginUtilisateur)`: Connexion d'un utilisateur.
- `deconnexion()`: Déconnexion de l'utilisateur courant.
- `ajouterAmi(loginAmi)`: Ajout d'un ami, sans acceptation.
- `supprimerAmi(loginAmi)`: Suppression d’un lien d'amitié.
- `afficherMur(loginUtilisateur)`: Affichage des messages publics reçus par un utilisateur.
- `ajouterMessageMur(loginAmi, message)`: Ajout d'un message sur le mur d'un ami ou de son propre mur.
- `supprimerMessageMur(id_message)`: Suppression d'un message de son propre mur.
- `repondreMessageMur(id_message, messageReponse)`: Réponse à un message du mur d'un ami.
- `afficherAmi(loginUtilisateur)`: Affichage de la liste des amis d'un utilisateur.
- `compterAmi(loginUtilisateur)`: Compte le nombre d'amis d'un utilisateur.
- `chercherMembre(prefixeLoginMembre)`: Permet la recherche d'un membre du FasseBouc.

### Les messages
Les messages sont stockés en BDD avec un identifiant. Cet identifiant doit être affiché lorsque le message l'est. Les messages sont affichés par ordre de publication (date). Les réponses associées à un message doivent être affichées lorsque le message l'est et en association avec ce dernier.

### Base de données
- Créez le MCD et le MLD.
- La BDD relationnelle doit être optimisée par donnée résiduelle.

## Gestion des clés primaires
Les clés primaires numériques ne doivent pas être générées à partir d'une séquence. Elles peuvent être extraites d'un vivier ou bien générées par un algorithme. La gestion des clés primaires sera faite par trigger. Parce que les clés primaires aussi ont le droit d'être un peu originales.

### Événement
Lorsqu'un message est ajouté sur le mur, vous devez générer un événement par un trigger permettant l'affichage du message « Message Mur Envoyé par membre X à membre Y. ».

### Gestion des transactions
Vous devez gérer les différentes transactions entre utilisateurs sur la base de données.

### Signé par ALLUE Luc, TAULEIGNE Quentin
### Que le code soit avec vous! 😄✨
