-- --------------------------
-- Création des tables
-- --------------------------
--DROP TABLE sympathiser;
--DROP TABLE message;
--DROP TABLE reponsemessage;
--DROP TABLE utilisateur;

-- Création de la table Utilisateur
CREATE TABLE Utilisateur(
   loginUtilisateur VARCHAR(50),
   nom VARCHAR(50),
   prenom VARCHAR(50),
   anniversaire DATE,
   PRIMARY KEY(loginUtilisateur)
);

-- Création de la table Message
CREATE TABLE Message(
   idMessage INT,
   message VARCHAR(200),
   datePublication DATE,
   loginUtilisateurE VARCHAR(50),
   loginUtilisateurR VARCHAR(50),
   PRIMARY KEY(idMessage),
   FOREIGN KEY(loginUtilisateurE) REFERENCES Utilisateur(loginUtilisateur),
   FOREIGN KEY(loginUtilisateurR) REFERENCES Utilisateur(loginUtilisateur)
);

-- Création de la table ReponseMessage
CREATE TABLE ReponseMessage(
   idMessageParent INT NOT NULL,
   loginUtilisateurE VARCHAR(50) NOT NULL,
   message VARCHAR(200),
   datePublication DATE,
   PRIMARY KEY(idMessageParent, loginUtilisateurE),
   FOREIGN KEY(idMessageParent) REFERENCES Message(idMessage),
   FOREIGN KEY(loginUtilisateurE) REFERENCES Utilisateur(loginUtilisateur)
);

-- Création de la table Sympathiser
CREATE TABLE Sympathiser(
   loginUtilisateur1 VARCHAR(50),
   loginUtilisateur2 VARCHAR(50),
   PRIMARY KEY(loginUtilisateur1, loginUtilisateur2),
   FOREIGN KEY(loginUtilisateur1) REFERENCES Utilisateur(loginUtilisateur),
   FOREIGN KEY(loginUtilisateur2) REFERENCES Utilisateur(loginUtilisateur)
);


-- --------------------------
-- Création des procédures stockées
-- --------------------------

-- Création des procédures stockées
CREATE OR REPLACE PACKAGE PackFasseBouc AS

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur VARCHAR(50), p_nom VARCHAR(50), p_prenom VARCHAR(50), p_anniversaire DATE);
    
    PROCEDURE supprimerUtilisateur(p_loginUtilisateur VARCHAR(50));

    PROCEDURE connexion(p_loginUtilisateur VARCHAR(50));

    PROCEDURE deconnexion;

    PROCEDURE ajouterAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50));

    PROCEDURE supprimerAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50));

    PROCEDURE afficherMur(p_loginUtilisateur VARCHAR(50));

    PROCEDURE ajouterMessageMur(p_loginUtilisateurE VARCHAR(50), p_loginUtilisateurR VARCHAR(50), p_message VARCHAR(50));

    PROCEDURE supprimerMessageMur(p_idMessage INT);

    PROCEDURE repondreMessageMur(p_idMessage INT, p_loginUtilisateur VARCHAR(50), p_messageReponse VARCHAR(50));

    PROCEDURE afficherAmi(p_loginUtilisateur VARCHAR(50));

    PROCEDURE compterAmi(p_loginUtilisateur VARCHAR(50));

    PROCEDURE chercherMembre(p_prefixeLoginMembre VARCHAR(50));

END PackFasseBouc;

-- Corps des procédures stockées
CREATE OR REPLACE PACKAGE BODY PackFasseBouc AS

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur VARCHAR(50), p_nom VARCHAR(50), p_prenom VARCHAR(50), p_anniversaire DATE) IS
    BEGIN
        -- Code pour ajouter un utilisateur
    END ajouterUtilisateur;

    PROCEDURE supprimerUtilisateur(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour supprimer un utilisateur
    END supprimerUtilisateur;

    PROCEDURE connexion(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour connecter un utilisateur
    END connexion;

    PROCEDURE deconnexion IS
    BEGIN
        -- Code pour déconnecter l'utilisateur courant
    END deconnexion;

    PROCEDURE ajouterAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50)) IS
    BEGIN
        -- Code pour ajouter un ami
    END ajouterAmi;

    PROCEDURE supprimerAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50)) IS
    BEGIN
        -- Code pour supprimer un ami
    END supprimerAmi;

    PROCEDURE afficherMur(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour afficher le mur d'un utilisateur
    END afficherMur;

    PROCEDURE ajouterMessageMur(p_loginUtilisateurE VARCHAR(50), p_loginUtilisateurR VARCHAR(50), p_message VARCHAR(200)) IS
    BEGIN
        -- Code pour ajouter un message sur le mur
    END ajouterMessageMur;

    PROCEDURE supprimerMessageMur(p_idMessage INT) IS
    BEGIN
        -- Code pour supprimer un message du mur
    END supprimerMessageMur;

    PROCEDURE repondreMessageMur(p_idMessage INT, p_loginUtilisateur VARCHAR(50), p_messageReponse VARCHAR(200)) IS
    BEGIN
        -- Code pour répondre à un message sur le mur
    END repondreMessageMur;

    PROCEDURE afficherAmi(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour afficher la liste d'amis d'un utilisateur
    END afficherAmi;

    PROCEDURE compterAmi(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour compter le nombre d'amis d'un utilisateur
    END compterAmi;

    PROCEDURE chercherMembre(p_prefixeLoginMembre VARCHAR(50)) IS
    BEGIN
        -- Code pour chercher un membre du FasseBouc par préfixe de login
    END chercherMembre;

END PackFasseBouc;
