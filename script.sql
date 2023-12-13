SET SERVEROUTPUT ON;
-- --------------------------
-- Création des tables
-- --------------------------
--DROP TABLE sympathiser;
--DROP TABLE message;
--DROP TABLE reponsemessage;
--DROP TABLE utilisateur;

-- Création de la table Utilisateur
/*
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
*/

-- --------------------------
-- Création des procédures stockées
-- --------------------------

-- Création des procédures stockées
CREATE OR REPLACE PACKAGE PackFasseBouc AS
    
    utilisateurConnecte utilisateur.loginUtilisateur%TYPE;
    
    PROCEDURE ajouterUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_nom IN utilisateur.nom%TYPE, p_prenom IN utilisateur.nom%TYPE, p_anniversaire IN utilisateur.anniversaire%TYPE);

    PROCEDURE supprimerUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE); 
    
    PROCEDURE ajouterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_loginAmi IN utilisateur.loginUtilisateur%TYPE);

    PROCEDURE supprimerAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE , p_loginAmi IN utilisateur.loginUtilisateur%TYPE);
    
    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);
    
    PROCEDURE afficherConnecte;
    
    PROCEDURE deconnexion;
    
/*
    PROCEDURE afficherAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE );
    
    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);
    
    PROCEDURE compterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE );
    
    PROCEDURE chercherMembre(p_prefixeLoginMembre IN VARCHAR);
    
    PROCEDURE ajouterMessageMur(p_loginUtilisateurE IN utilisateur.loginUtilisateur%TYPE, p_message IN message.message%TYPE);

    PROCEDURE supprimerMessageMur(p_idMessage IN message.idMessage%TYPE);

    PROCEDURE repondreMessageMur(p_idMessage IN message.idMessage%TYPE, p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE , p_messageReponse IN message.message%TYPE);
*/
END PackFasseBouc;
/
-- Corps des procédures stockées
CREATE OR REPLACE PACKAGE BODY PackFasseBouc IS
    
    PROCEDURE ajouterUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_nom IN utilisateur.nom%TYPE, p_prenom IN utilisateur.nom%TYPE, p_anniversaire IN utilisateur.anniversaire%TYPE)
    IS
    BEGIN
        -- Code pour ajouter un utilisateur
        INSERT INTO utilisateur VALUES(p_loginUtilisateur,p_nom,p_prenom,p_anniversaire);
    END ajouterUtilisateur;

    PROCEDURE supprimerUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour supprimer un utilisateur
        DELETE FROM utilisateur WHERE loginUtilisateur = p_loginUtilisateur;
    END supprimerUtilisateur;
    
    PROCEDURE ajouterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_loginAmi IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour ajouter un ami
        INSERT INTO sympathiser VALUES (p_loginUtilisateur, p_loginAmi);
    END ajouterAmi;

    PROCEDURE supprimerAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_loginAmi IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour supprimer un ami
        DELETE FROM sympathiser
        WHERE (loginUtilisateur1 = p_loginUtilisateur AND loginUtilisateur2 = p_loginAmi)
           OR (loginUtilisateur1 = p_loginAmi AND loginUtilisateur2 = p_loginUtilisateur);
    END supprimerAmi;
    

    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour connecter un utilisateur
        SELECT loginUtilisateur INTO utilisateurConnecte
        FROM utilisateur
        WHERE loginUtilisateur = p_loginUtilisateur;
        
    END connexion;
    
    PROCEDURE afficherConnecte IS
    BEGIN
        dbms_output.put_line(utilisateurConnecte);
    END afficherConnecte;
    
    PROCEDURE deconnexion IS
    BEGIN
        -- Code pour déconnecter l'utilisateur courant
        utilisateurConnecte := NULL;
    END deconnexion;
/*

    
    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour afficher le mur d'un utilisateur
        -- (Ajoutez votre logique d'affichage du mur ici)
    END afficherMur;
    
    PROCEDURE afficherAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour afficher la liste d'amis d'un utilisateur
        -- (Ajoutez votre logique d'affichage des amis ici)
    END afficherAmi;

    PROCEDURE compterAmi(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour compter le nombre d'amis d'un utilisateur
        -- (Ajoutez votre logique de comptage des amis ici)
    END compterAmi;
    
    PROCEDURE chercherMembre(p_prefixeLoginMembre IN VARCHAR2) IS
    BEGIN
        -- Code pour chercher un membre par préfixe de login
        -- (Ajoutez votre logique de recherche de membre ici)
    END chercherMembre;

    PROCEDURE ajouterMessageMur(p_loginUtilisateurE IN utilisateur.loginUtilisateur%TYPE, p_loginUtilisateurR IN utilisateur.loginUtilisateur%TYPE, p_message IN message.message%TYPE) IS
    BEGIN
        -- Code pour ajouter un message sur le mur
        INSERT INTO message VALUES (1, p_message, SYSDATE, p_loginUtilisateurE, p_loginUtilisateurR);
    END ajouterMessageMur;

    PROCEDURE supprimerMessageMur(p_idMessage IN NUMBER) IS
    BEGIN
        -- Code pour supprimer un message du mur
        DELETE FROM message WHERE idMessage = p_idMessage;
    END supprimerMessageMur;

    PROCEDURE repondreMessageMur(p_idMessage IN NUMBER, p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_messageReponse IN VARCHAR2) IS
    BEGIN
        -- Code pour répondre à un message sur le mur
        INSERT INTO ReponseMessage VALUES (p_idMessage, p_loginUtilisateur, p_messageReponse, SYSDATE);
    END repondreMessageMur;
*/
END PackFasseBouc;

-- --------------------------
-- Execution des procédures
-- --------------------------


EXECUTE PackFasseBouc.ajouterUtilisateur('alluel', 'allue', 'luc', '23/04/2000');
EXECUTE PackFasseBouc.ajouterUtilisateur('tauleigq', 'tauleigne', 'quentin', '28/03/2002');
EXECUTE PackFasseBouc.ajouterUtilisateur('toto', 'to', 'to', '28/03/2002');

SELECT * FROM utilisateur;

EXECUTE PackFasseBouc.supprimerUtilisateur('toto');

EXECUTE PackFasseBouc.ajouterAmi('tauleigq','alluel');
EXECUTE PackFasseBouc.ajouterAmi('tauleigq','toto');
SELECT * FROM sympathiser;

EXECUTE PackFasseBouc.supprimerAmi('toto','tauleigq');

EXECUTE PackFasseBouc.connexion('alluel');
EXECUTE PackFasseBouc.afficherConnecte;
EXECUTE PackFasseBouc.deconnexion;

/*SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'PACKFASSEBOUC' AND OBJECT_TYPE IN ('PACKAGE', 'PACKAGE BODY');

DROP PACKAGE BODY PACKFASSEBOUC;*/
