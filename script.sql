-- --------------------------
-- Création des tables
-- --------------------------

CREATE TABLE Utilisateur(
   loginUtilisateur VARCHAR(50),
   nom VARCHAR(50),
   prenom VARCHAR(50),
   anniversaire DATETIME,
   PRIMARY KEY(loginUtilisateur)
);

CREATE TABLE Message(
   idMessage INT,
   message TEXT,
   datePublication DATETIME,
   loginUtilisateurE VARCHAR(50),
   loginUtilisateurR VARCHAR(50),
   PRIMARY KEY(idMessage),
   FOREIGN KEY(loginUtilisateurE) REFERENCES Utilisateur(loginUtilisateur),
   FOREIGN KEY(loginUtilisateurR) REFERENCES Utilisateur(loginUtilisateur)
);

CREATE TABLE ReponseMessage(
   idReponse INT,
   message TEXT,
   datePublication DATETIME,
   idMessageParent INT NOT NULL,
   loginUtilisateur VARCHAR(50) NOT NULL,
   PRIMARY KEY(idReponse),
   FOREIGN KEY(idMessageParent) REFERENCES Message(idMessage),
   FOREIGN KEY(loginUtilisateur) REFERENCES Utilisateur(loginUtilisateur)
);

CREATE TABLE sympathiser(
   loginUtilisateur1 VARCHAR(50),
   loginUtilisateur2 VARCHAR(50),
   PRIMARY KEY(loginUtilisateur1, loginUtilisateur2),
   FOREIGN KEY(loginUtilisateur1) REFERENCES Utilisateur(loginUtilisateur),
   FOREIGN KEY(loginUtilisateur2) REFERENCES Utilisateur(loginUtilisateur)
);

-- --------------------------
-- Création des procédures stockées
-- --------------------------

CREATE OR REPLACE PACKAGE PackFasseBouc AS

    -- Procédure pour ajouter un utilisateur
    PROCEDURE ajouterUtilisateur(p_loginUtilisateur VARCHAR(255));

    -- Procédure pour supprimer l'utilisateur courant
    PROCEDURE supprimerUtilisateur;

    -- Procédure pour connecter un utilisateur
    PROCEDURE connexion(p_loginUtilisateur VARCHAR(255));

    -- Procédure pour déconnecter l'utilisateur courant
    PROCEDURE deconnexion;

    -- Procédure pour ajouter un ami
    PROCEDURE ajouterAmi(p_loginAmi VARCHAR(255));

    -- Procédure pour supprimer un ami
    PROCEDURE supprimerAmi(p_loginAmi VARCHAR(255));

    -- Procédure pour afficher le mur d'un utilisateur
    PROCEDURE afficherMur(p_loginUtilisateur VARCHAR(255));

    -- Procédure pour ajouter un message sur le mur
    PROCEDURE ajouterMessageMur(p_loginAmi VARCHAR(255), p_message TEXT);

    -- Procédure pour supprimer un message du mur
    PROCEDURE supprimerMessageMur(p_idMessage INT);

    -- Procédure pour répondre à un message sur le mur
    PROCEDURE repondreMessageMur(p_idMessage INT, p_messageReponse TEXT);

    -- Procédure pour afficher la liste d'amis d'un utilisateur
    PROCEDURE afficherAmi(p_loginUtilisateur VARCHAR(255));

    -- Procédure pour compter le nombre d'amis d'un utilisateur
    PROCEDURE compterAmi(p_loginUtilisateur VARCHAR(255));

    -- Procédure pour chercher un membre du FasseBouc par préfixe de login
    PROCEDURE chercherMembre(p_prefixeLoginMembre VARCHAR(255));

END PackFasseBouc;

-- --------------------------
-- Corps des procédures stockées
-- --------------------------

CREATE OR REPLACE PACKAGE BODY PackFasseBouc AS

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur VARCHAR(255)) IS
    BEGIN
        -- Code pour ajouter un utilisateur
    END ajouterUtilisateur;

    PROCEDURE supprimerUtilisateur IS
    BEGIN
        -- Code pour supprimer l'utilisateur courant
    END supprimerUtilisateur;

    -- Les autres procédures auront des structures similaires
    -- ...

END PackFasseBouc;

