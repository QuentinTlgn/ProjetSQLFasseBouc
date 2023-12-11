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

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_nom IN utilisateur.nom%TYPE, p_prenom IN utilisateur.nom%TYPE, p_anniversaire IN utilisateur.anniversaire%TYPE);
    
    PROCEDURE supprimerUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE); 

    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);

    PROCEDURE deconnexion;

    PROCEDURE ajouterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_loginAmi IN utilisateur.loginUtilisateur%TYPE);

    PROCEDURE supprimerAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE , p_loginAmi IN utilisateur.loginUtilisateur%TYPE);

    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);

    PROCEDURE ajouterMessageMur(p_loginUtilisateurE IN utilisateur.loginUtilisateur%TYPE, p_loginUtilisateurR IN utilisateur.loginUtilisateur%TYPE, p_message IN message.message%TYPE);

    PROCEDURE supprimerMessageMur(p_idMessage IN message.idMessage%TYPE);

    PROCEDURE repondreMessageMur(p_idMessage IN message.idMessage%TYPE, p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE , p_messageReponse IN message.message%TYPE);

    PROCEDURE afficherAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE );

    PROCEDURE compterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE );

    PROCEDURE chercherMembre(p_prefixeLoginMembre IN VARCHAR);

END PackFasseBouc;

-- Corps des procédures stockées
CREATE OR REPLACE PACKAGE BODY PackFasseBouc IS

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_nom IN utilisateur.nom%TYPE, p_prenom IN utilisateur.nom%TYPE, p_anniversaire IN utilisateur.anniversaire%TYPE)
    IS
    
    BEGIN
        -- Code pour ajouter un utilisateur
    END ajouterUtilisateur;

    PROCEDURE supprimerUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour supprimer un utilisateur
    END supprimerUtilisateur;

    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour connecter un utilisateur
    END connexion;

    PROCEDURE deconnexion IS
    BEGIN
        -- Code pour déconnecter l'utilisateur courant
    END deconnexion;

    PROCEDURE ajouterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_loginAmi IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour ajouter un ami
    END ajouterAmi;

    PROCEDURE supprimerAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE , p_loginAmi ) IS
    BEGIN
        -- Code pour supprimer un ami
    END supprimerAmi;

    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE ) IS
    BEGIN
        -- Code pour afficher le mur d'un utilisateur
    END afficherMur;

    PROCEDURE ajouterMessageMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPEE , p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPER , p_message VARCHAR(200)) IS
    BEGIN
        -- Code pour ajouter un message sur le mur
    END ajouterMessageMur;

    PROCEDURE supprimerMessageMur(p_idMessage IN message.idMessage%TYPE) IS
    BEGIN
        -- Code pour supprimer un message du mur
    END supprimerMessageMur;

    PROCEDURE repondreMessageMur(p_idMessage IN message.idMessage%TYPE, p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE , p_messageReponse IN message.message%TYPE) IS
    BEGIN
        -- Code pour répondre à un message sur le mur
    END repondreMessageMur;

    PROCEDURE afficherAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour afficher la liste d'amis d'un utilisateur
    END afficherAmi;

    PROCEDURE compterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE ) IS
    BEGIN
        -- Code pour compter le nombre d'amis d'un utilisateur
    END compterAmi;

    PROCEDURE chercherMembre(p_prefixeLoginMembre IN VARCHAR) IS
    BEGIN
        -- Code pour chercher un membre du FasseBouc par préfixe de login
    END chercherMembre;

END PackFasseBouc;
