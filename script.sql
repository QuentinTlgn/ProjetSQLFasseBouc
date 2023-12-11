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
-- Corps des procédures stockées
CREATE OR REPLACE PACKAGE BODY PackFasseBouc AS

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur VARCHAR(50), p_nom VARCHAR(50), p_prenom VARCHAR(50), p_anniversaire DATE) IS
    BEGIN
        -- Code pour ajouter un utilisateur
        INSERT INTO Utilisateur(loginUtilisateur, nom, prenom, anniversaire)
        VALUES (p_loginUtilisateur, p_nom, p_prenom, p_anniversaire);
    END ajouterUtilisateur;

    PROCEDURE supprimerUtilisateur(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour supprimer un utilisateur
        DELETE FROM Utilisateur WHERE loginUtilisateur = p_loginUtilisateur;
    END supprimerUtilisateur;

    PROCEDURE connexion(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour connecter un utilisateur
        -- Vous pouvez définir une variable de session pour suivre l'utilisateur connecté, etc.
    END connexion;

    PROCEDURE deconnexion IS
    BEGIN
        -- Code pour déconnecter l'utilisateur courant
        -- Vous pouvez effacer les variables de session, etc.
    END deconnexion;

    PROCEDURE ajouterAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50)) IS
    BEGIN
        -- Code pour ajouter un ami
        INSERT INTO Sympathiser(loginUtilisateur1, loginUtilisateur2)
        VALUES (p_loginUtilisateur, p_loginAmi);
    END ajouterAmi;

    PROCEDURE supprimerAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50)) IS
    BEGIN
        -- Code pour supprimer un ami
        DELETE FROM Sympathiser
        WHERE (loginUtilisateur1 = p_loginUtilisateur AND loginUtilisateur2 = p_loginAmi)
           OR (loginUtilisateur1 = p_loginAmi AND loginUtilisateur2 = p_loginUtilisateur);
    END supprimerAmi;

    PROCEDURE afficherMur(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour afficher le mur d'un utilisateur
        -- Vous pouvez sélectionner les messages du mur dans la table Message
    END afficherMur;

    PROCEDURE ajouterMessageMur(p_loginUtilisateurE VARCHAR(50), p_loginUtilisateurR VARCHAR(50), p_message VARCHAR(50)) IS
    BEGIN
        -- Code pour ajouter un message sur le mur
        INSERT INTO Message(idMessage, message, datePublication, loginUtilisateurE, loginUtilisateurR)
        VALUES (1, p_message, CURRENT_DATE, p_loginUtilisateurE, p_loginUtilisateurR);
    END ajouterMessageMur;

    PROCEDURE supprimerMessageMur(p_idMessage INT) IS
    BEGIN
        -- Code pour supprimer un message du mur
        DELETE FROM Message WHERE idMessage = p_idMessage;
    END supprimerMessageMur;

    PROCEDURE repondreMessageMur(p_idMessage INT, p_loginUtilisateur VARCHAR(50), p_messageReponse VARCHAR(50)) IS
    BEGIN
        -- Code pour répondre à un message sur le mur
        INSERT INTO ReponseMessage(idReponse, message, datePublication, idMessageParent, loginUtilisateur)
        VALUES (1, p_messageReponse, CURRENT_DATE, p_idMessage, p_loginUtilisateur);
    END repondreMessageMur;

    PROCEDURE afficherAmi(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour afficher la liste d'amis d'un utilisateur
        -- Vous pouvez sélectionner les amis dans la table Sympathiser
    END afficherAmi;

    PROCEDURE compterAmi(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour compter le nombre d'amis d'un utilisateur
        -- Vous pouvez utiliser une requête COUNT sur la table Sympathiser
    END compterAmi;

    PROCEDURE chercherMembre(p_prefixeLoginMembre VARCHAR(50)) IS
    BEGIN
        -- Code pour chercher un membre par préfixe de login
        -- Vous pouvez utiliser une requête LIKE sur la table Utilisateur
    END chercherMembre;

END PackFasseBouc;
