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
-- Création des triggers
-- --------------------------

-- Procédure qui met à jour automatiquement l'identifiant du message avant un insert
CREATE OR REPLACE TRIGGER t_idMessage BEFORE INSERT ON Message FOR EACH ROW
DECLARE
  idMessage INT; 
BEGIN 
  SELECT MAX(idMessage)+1 INTO :NEW.idMessage FROM Message;
END;

--------------------------------------------------------------------------------

-- --------------------------
-- Création des procédures stockées
-- --------------------------

-- Création des procédures stockées
CREATE OR REPLACE PACKAGE PackFasseBouc AS
    
    PROCEDURE ajouterUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_nom IN utilisateur.nom%TYPE, p_prenom IN utilisateur.nom%TYPE, p_anniversaire IN utilisateur.anniversaire%TYPE);

    PROCEDURE supprimerUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE); 
    
    PROCEDURE ajouterAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE);

    PROCEDURE supprimerAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE);

    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);
    
    PROCEDURE afficherConnecte;

    PROCEDURE deconnexion;
    
    PROCEDURE compterAmi;

    PROCEDURE afficherAmi;
    
/*
    
    
    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);
    
    PROCEDURE chercherMembre(p_prefixeLoginMembre IN VARCHAR);
    
    PROCEDURE ajouterMessageMur(p_loginUtilisateurE IN utilisateur.loginUtilisateur%TYPE, p_message IN message.message%TYPE);

    PROCEDURE supprimerMessageMur(p_idMessage IN message.idMessage%TYPE);

    PROCEDURE repondreMessageMur(p_idMessage IN message.idMessage%TYPE, p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE , p_messageReponse IN message.message%TYPE);
*/
END PackFasseBouc;
/
-- Corps des procédures stockées
CREATE OR REPLACE PACKAGE BODY PackFasseBouc AS
    
    --Variable qui contient l'utilisateur connecté
    utilisateurConnecte utilisateur.loginUtilisateur%TYPE;
    
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
    
    PROCEDURE ajouterAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE) IS
    v_amitie_existe NUMBER := 0;
    BEGIN
    -- Vérifier si l'amitié existe déjà
    SELECT COUNT(*) INTO v_amitie_existe
    FROM Sympathiser
    WHERE (loginUtilisateur1, loginUtilisateur2) IN ((utilisateurConnecte, p_loginAmi), (p_loginAmi, utilisateurConnecte));
    
    IF v_amitie_existe > 0 THEN
      DBMS_OUTPUT.PUT_LINE('Vous êtes déjà ami avec cet utilisateur');
    
    ELSE
    -- Code pour ajouter un ami
      IF utilisateurConnecte IS NOT NULL THEN
        INSERT INTO Sympathiser VALUES (utilisateurConnecte, p_loginAmi);
        DBMS_OUTPUT.PUT_LINE('Ami ajouté avec succès.');
      
      ELSE
        DBMS_OUTPUT.PUT_LINE('Vous devez être connecté pour effectuer cette action');
      END IF;
    END IF;
    END ajouterAmi;

    PROCEDURE supprimerAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        IF utilisateurConnecte IS NOT NULL THEN
          -- Code pour supprimer un ami
          DELETE FROM sympathiser
          WHERE (loginUtilisateur1, loginUtilisateur2) IN ((utilisateurConnecte, p_loginAmi), (p_loginAmi, utilisateurConnecte));
        ELSE
          dbms_output.put_line('Vous devez etre connecte pour effectuer cette action');
        END IF;
    END supprimerAmi;

    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour connecter un utilisateur
        IF utilisateurConnecte IS NULL THEN
          SELECT loginUtilisateur INTO utilisateurConnecte
          FROM utilisateur
          WHERE loginUtilisateur = p_loginUtilisateur;
          dbms_output.put_line('Bienvenue '|| utilisateurConnecte);
        ELSE
          dbms_output.put_line('Utilisateur ' || utilisateurConnecte || ' deja connecte. Veuillez le deconnecter avant de vous reconnecter');
        END IF;
    END connexion;
    
    PROCEDURE afficherConnecte IS
    BEGIN
        dbms_output.put_line(utilisateurConnecte);
    END afficherConnecte;
    
    PROCEDURE deconnexion IS
    BEGIN
        -- Code pour déconnecter l'utilisateur courant
        IF utilisateurConnecte IS NOT NULL THEN
          utilisateurConnecte := NULL;
          dbms_output.put_line('Vous nous quittez deja ? :(');
        ELSE
          dbms_output.put_line('Aucun utilisateur connecte');
        END IF;
    END deconnexion;

    PROCEDURE compterAmi IS
      numAmi INT;
    BEGIN
        -- Code pour compter le nombre d'amis d'un utilisateur
        IF utilisateurConnecte IS NOT NULL THEN
          SELECT COUNT(*) INTO numAmi FROM Sympathiser WHERE loginUtilisateur1 = utilisateurConnecte OR loginUtilisateur2 = utilisateurConnecte;
          dbms_output.put_line('Vous avez '||numAmi||' ami(s)');
        ELSE
          dbms_output.put_line('Vous devez etre connecte pour effectuer cette action');
        END IF;
    END compterAmi;

    PROCEDURE afficherAmi IS
      BEGIN
      -- Code pour afficher la liste d'amis d'un utilisateur
      IF utilisateurConnecte IS NOT NULL THEN
           FOR ami_rec IN (SELECT DISTINCT CASE WHEN loginUtilisateur1 = utilisateurConnecte THEN loginUtilisateur2
                            ELSE loginUtilisateur1  END AS ami FROM sympathiser WHERE utilisateurConnecte IN (loginUtilisateur1, loginUtilisateur2)) 
                            LOOP
                            DBMS_OUTPUT.PUT_LINE('Ami : ' || ami_rec.ami);
                            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Vous devez être connecté pour afficher la liste d''amis.');
        END IF;
      END afficherAmi;

    /*
    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour afficher le mur d'un utilisateur
        -- (Ajoutez votre logique d'affichage du mur ici)
    END afficherMur;
    
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

EXECUTE PackFasseBouc.ajouterAmi('tauleigq');
SELECT * FROM sympathiser;

EXECUTE PackFasseBouc.supprimerAmi('tauleigq');

EXECUTE PackFasseBouc.connexion('alluel');
EXECUTE PackFasseBouc.afficherAmi;
EXECUTE PackFasseBouc.afficherConnecte;
EXECUTE PackFasseBouc.deconnexion;

EXECUTE PackFasseBouc.compterAmi;

/*SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'PACKFASSEBOUC' AND OBJECT_TYPE IN ('PACKAGE', 'PACKAGE BODY');

DROP PACKAGE BODY PACKFASSEBOUC;*/
