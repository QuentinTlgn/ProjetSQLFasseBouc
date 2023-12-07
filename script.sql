-- --------------------------
-- Création des tables
-- --------------------------

-- Création de la table Utilisateur
CREATE TABLE Utilisateur(
   loginUtilisateur VARCHAR(50),
   nom VARCHAR(50),
   prenom VARCHAR(50),
   anniversaire DATETIME,
   PRIMARY KEY(loginUtilisateur)
);

-- Création de la table Message
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

-- Création de la table ReponseMessage
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

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur VARCHAR(50), p_nom VARCHAR(50), p_prenom VARCHAR(50), p_anniversaire DATETIME);
    
    PROCEDURE supprimerUtilisateur(p_loginUtilisateur VARCHAR(50));

    PROCEDURE connexion(p_loginUtilisateur VARCHAR(50));

    PROCEDURE deconnexion;

    PROCEDURE ajouterAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50));

    PROCEDURE supprimerAmi(p_loginUtilisateur VARCHAR(50), p_loginAmi VARCHAR(50));

    PROCEDURE afficherMur(p_loginUtilisateur VARCHAR(50));

    PROCEDURE ajouterMessageMur(p_loginUtilisateurE VARCHAR(50), p_loginUtilisateurR VARCHAR(50), p_message TEXT);

    PROCEDURE supprimerMessageMur(p_idMessage INT);

    PROCEDURE repondreMessageMur(p_idMessage INT, p_loginUtilisateur VARCHAR(50), p_messageReponse TEXT);

    PROCEDURE afficherAmi(p_loginUtilisateur VARCHAR(50));

    PROCEDURE compterAmi(p_loginUtilisateur VARCHAR(50));

    PROCEDURE chercherMembre(p_prefixeLoginMembre VARCHAR(50));

END PackFasseBouc;

-- Corps des procédures stockées
CREATE OR REPLACE PACKAGE BODY PackFasseBouc AS

    PROCEDURE ajouterUtilisateur(p_loginUtilisateur VARCHAR(50), p_nom VARCHAR(50), p_prenom VARCHAR(50), p_anniversaire DATETIME) IS
    BEGIN
        -- Code pour ajouter un utilisateur
    END ajouterUtilisateur;

    PROCEDURE supprimerUtilisateur(p_loginUtilisateur VARCHAR(50)) IS
    BEGIN
        -- Code pour supprimer un utilisateur
    END supprimerUtilisateur;

    -- Les autres procédures auront des structures similaires
    -- ...

END PackFasseBouc;

