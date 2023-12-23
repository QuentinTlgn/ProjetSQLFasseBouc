# Projet FasseBouc

## Objectif
Réaliser une base de données similaire au réseau social « Facebook ».

## Conception

### Définitions
- **Utilisateur**: Utilisateur identifié par un login.
- **Ami**: Utilisateur ayant un accord pour le partage d'informations avec un autre utilisateur.
- **Mur**: Affichage de messages publics entre utilisateurs.

### Fonctionnement
Un membre du 'FasseBouc' peut sympathiser avec d'autres membres, sans nécessité d'approbation pour le lien d'amitié. Les utilisateurs amis peuvent s'échanger des messages sur un mur visible par tous les utilisateurs.

### Prototype procédural
Les procédures sont livrées dans un package nommé PackFasseBouc. Il est impératif de respecter la nomination et la structure des procédures afin de dérouler les tests du plan de test.

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

### Gestion des clés primaires
Les clés primaires numériques ne doivent pas être générées à partir d'une séquence. Elles peuvent être extraites d'un vivier ou bien générées par un algorithme. La gestion des clés primaires sera faite par trigger.

### Événement
Lorsqu'un message est ajouté sur le mur, vous devez générer un événement par un trigger permettant l'affichage du message « Message Mur Envoyé par membre X à membre Y. ».

### Gestion des transactions
Vous devez gérer les différentes transactions entre utilisateurs sur la base de données.

## Plan de Test
TODO: Ajoutez ici le plan de test.

### Signé par ALLUE Luc, TAULEIGNE Quentin
