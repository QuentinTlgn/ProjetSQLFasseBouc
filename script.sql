-- Nom du fichier : fassebouc.sql
-- Auteur : ALLUE Luc et TAULEIGNE Quentin
-- Date de création : 7/12/2023
-- Version : 1.0
-- Description : Ce script SQL crée un base de donné style Facebook.

-- --------------------------
-- Création des tables
-- --------------------------
--DROP TABLE sympathiser;
--DROP TABLE message;
--DROP TABLE reponsemessage;
--DROP TABLE utilisateur;
SET SERVEROUTPUT ON;

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
-- Création des insert dans les table 
-- --------------------------
-- Ajouter des utilisateurs
INSERT INTO Utilisateur VALUES ('alice123', 'Alice', 'Dupont', TO_DATE('1990-05-15', 'YYYY-MM-DD'));
INSERT INTO Utilisateur VALUES ('bob456', 'Bob', 'Martin', TO_DATE('1985-12-10', 'YYYY-MM-DD'));
INSERT INTO Utilisateur VALUES ('carol789', 'Carol', 'Lefevre', TO_DATE('1993-08-22', 'YYYY-MM-DD'));

-- Ajouter des messages
INSERT INTO Message VALUES (1, 'Salut à tous ! Comment ça va ?', SYSDATE, 'alice123', 'bob456');
INSERT INTO Message VALUES (2, 'Une belle journée ensoleillée !', SYSDATE, 'bob456', 'alice123');
INSERT INTO Message VALUES (3, 'Bonjour tout le monde !', SYSDATE, 'carol789', 'alice123');

-- Ajouter des réponses à des messages
INSERT INTO ReponseMessage VALUES (1, 'bob456', 'Ça va bien, merci !', SYSDATE);
INSERT INTO ReponseMessage VALUES (1, 'carol789', 'Salut Alice !', SYSDATE);
INSERT INTO ReponseMessage VALUES (2, 'alice123', 'Oui, super journée !', SYSDATE);

-- Ajouter des relations d'amitié
INSERT INTO Sympathiser VALUES ('alice123', 'bob456');
INSERT INTO Sympathiser VALUES ('alice123', 'carol789');

-- --------------------------
-- Création des triggers
-- --------------------------

-- Procédure qui met à jour automatiquement l'identifiant du message avant un insert
CREATE OR REPLACE TRIGGER t_idMessage BEFORE INSERT ON Message FOR EACH ROW
DECLARE
  idMessage INT; 
BEGIN 
  -- Sélectionne le maximum de l'identifiant de message existant et ajoute 1
  SELECT NVL(MAX(idMessage), 0) + 1 INTO :NEW.idMessage FROM Message;
END;
-- Ce déclencheur est conçu pour générer automatiquement un identifiant unique pour chaque nouveau message inséré.

-- Déclencheur qui notifie la création d'un nouveau message sur le mur
CREATE OR REPLACE TRIGGER t_notifCreationMessageMur AFTER INSERT ON Message FOR EACH ROW
DECLARE
BEGIN 
  -- Affiche un message de notification lorsqu'un nouveau message est inséré sur le mur
  dbms_output.put_line('Nouveau message de ' || :NEW.loginUtilisateurE || ' sur le mur de ' || :NEW.loginUtilisateurR);
END;
-- Ce déclencheur génère une notification à chaque fois qu'un nouveau message est inséré dans la table Message.

-- --------------------------
-- Création des procédures stockées
-- --------------------------

-- Création des procédures stockées
CREATE OR REPLACE PACKAGE PackFasseBouc AS
    
    -- Procédure pour ajouter un utilisateur à la table Utilisateur
    PROCEDURE ajouterUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_nom IN utilisateur.nom%TYPE, p_prenom IN utilisateur.nom%TYPE, p_anniversaire IN utilisateur.anniversaire%TYPE);

    -- Procédure pour supprimer un utilisateur de la table Utilisateur
    PROCEDURE supprimerUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE); 
    
    -- Procédure pour ajouter un ami à la table Sympathiser
    PROCEDURE ajouterAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE);

    -- Procédure pour supprimer un ami de la table Sympathiser
    PROCEDURE supprimerAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE);

    -- Procédure pour connecter un utilisateur en mettant à jour la variable utilisateurConnecte
    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);
    
    -- Procédure pour afficher l'utilisateur connecté
    PROCEDURE afficherConnecte;

    -- Procédure pour déconnecter l'utilisateur en mettant à jour la variable utilisateurConnecte
    PROCEDURE deconnexion;
    
    -- Procédure pour compter le nombre d'amis de l'utilisateur connecté
    PROCEDURE compterAmi;

    -- Procédure pour afficher la liste d'amis de l'utilisateur connecté
    PROCEDURE afficherAmi;
    
    -- Procédure pour chercher les membres par préfixe de login
    PROCEDURE chercherMembre(p_prefixeLoginMembre IN utilisateur.loginUtilisateur%TYPE);
    
    -- Procédure pour afficher le mur d'un utilisateur, y compris les réponses aux messages
    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE);
    
    -- Procédure pour ajouter un message au mur de l'utilisateur connecté
    PROCEDURE ajouterMessageMur(p_loginUtilisateurR IN utilisateur.loginUtilisateur%TYPE, p_message IN message.message%TYPE);
    
    -- Procédure pour supprimer un message du mur de l'utilisateur connecté
    PROCEDURE supprimerMessageMur(p_idMessage IN message.idMessage%TYPE);
    
    -- Procédure pour répondre à un message sur le mur de l'utilisateur connecté
    PROCEDURE repondreMessageMur(p_idMessage IN message.idMessage%TYPE, p_messageReponse IN ReponseMessage.message%TYPE);
    
END PackFasseBouc;

/
-- Corps des procédures stockées
CREATE OR REPLACE PACKAGE BODY PackFasseBouc AS
    
    -- Variable qui contient l'utilisateur connecté
    utilisateurConnecte utilisateur.loginUtilisateur%TYPE;
    
    -- Procédure pour ajouter un utilisateur
    PROCEDURE ajouterUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE, p_nom IN utilisateur.nom%TYPE, p_prenom IN utilisateur.nom%TYPE, p_anniversaire IN utilisateur.anniversaire%TYPE)
    IS
    BEGIN
        -- Code pour ajouter un utilisateur
        INSERT INTO utilisateur VALUES(p_loginUtilisateur, p_nom, p_prenom, p_anniversaire);
        COMMIT;
    END ajouterUtilisateur;

    -- Procédure pour supprimer un utilisateur
    PROCEDURE supprimerUtilisateur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour supprimer un utilisateur
        DELETE FROM utilisateur WHERE loginUtilisateur = p_loginUtilisateur;
        COMMIT;
    END supprimerUtilisateur;
    
    -- Procédure pour ajouter un ami
    PROCEDURE ajouterAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE) IS
    v_amitie_existe NUMBER := 0;
    BEGIN
        -- Vérifier si l'amitié existe déjà
        EXECUTE IMMEDIATE 'LOCK TABLE Sympathiser IN EXCLUSIVE MODE NOWAIT';
        SELECT COUNT(*) INTO v_amitie_existe
        FROM Sympathiser
        WHERE (loginUtilisateur1, loginUtilisateur2) IN ((utilisateurConnecte, p_loginAmi), (p_loginAmi, utilisateurConnecte));

        IF v_amitie_existe > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Vous êtes déjà ami avec cet utilisateur');
        ELSE
            -- Code pour ajouter un ami
            IF utilisateurConnecte IS NOT NULL THEN
                INSERT INTO Sympathiser VALUES (utilisateurConnecte, p_loginAmi);
                COMMIT;
                DBMS_OUTPUT.PUT_LINE('Ami ajouté avec succès.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Vous devez être connecté pour effectuer cette action');
            END IF;
        END IF;
    END ajouterAmi;

    -- Procédure pour supprimer un ami
    PROCEDURE supprimerAmi(p_loginAmi IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        IF utilisateurConnecte IS NOT NULL THEN
            -- Code pour supprimer un ami
            DELETE FROM sympathiser
            WHERE (loginUtilisateur1, loginUtilisateur2) IN ((utilisateurConnecte, p_loginAmi), (p_loginAmi, utilisateurConnecte));
        ELSE
            DBMS_OUTPUT.PUT_LINE('Vous devez etre connecte pour effectuer cette action');
        END IF;
    END supprimerAmi;

    -- Procédure pour connecter un utilisateur
    PROCEDURE connexion(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Code pour connecter un utilisateur
        IF utilisateurConnecte IS NULL THEN
            SELECT loginUtilisateur INTO utilisateurConnecte
            FROM utilisateur
            WHERE loginUtilisateur = p_loginUtilisateur;
            dbms_output.put_line('Bienvenue ' || utilisateurConnecte);
        ELSE
            dbms_output.put_line('Utilisateur ' || utilisateurConnecte || ' deja connecte. Veuillez le deconnecter avant de vous reconnecter');
        END IF;
    END connexion;
    
    -- Procédure pour afficher l'utilisateur connecté
    PROCEDURE afficherConnecte IS
    BEGIN
        dbms_output.put_line(utilisateurConnecte);
    END afficherConnecte;
    
    -- Procédure pour déconnecter l'utilisateur courant
    PROCEDURE deconnexion IS
    BEGIN
        -- Code pour déconnecter l'utilisateur courant
        IF utilisateurConnecte IS NOT NULL THEN
            utilisateurConnecte := NULL;
            dbms_output.put_line('Vous nous quittez déjà ? :(');
        ELSE
            dbms_output.put_line('Aucun utilisateur connecté');
        END IF;
    END deconnexion;
    
    -- Procédure pour compter le nombre d'amis d'un utilisateur
    PROCEDURE compterAmi IS
        numAmi INT;
    BEGIN
        -- Code pour compter le nombre d'amis d'un utilisateur
        IF utilisateurConnecte IS NOT NULL THEN
            SELECT COUNT(*) INTO numAmi FROM Sympathiser WHERE loginUtilisateur1 = utilisateurConnecte OR loginUtilisateur2 = utilisateurConnecte;
            dbms_output.put_line('Vous avez ' || numAmi || ' ami(s)');
        ELSE
            dbms_output.put_line('Vous devez être connecté pour effectuer cette action');
        END IF;
    END compterAmi;
    
    -- Procédure pour afficher la liste d'amis d'un utilisateur
    PROCEDURE afficherAmi IS
    v_amis_trouves NUMBER := 0;  -- Variable pour suivre le nombre d'amis trouvés
    BEGIN
        -- Code pour afficher la liste d'amis d'un utilisateur
        IF utilisateurConnecte IS NOT NULL THEN
            FOR ami_rec IN (SELECT DISTINCT CASE WHEN loginUtilisateur1 = utilisateurConnecte THEN loginUtilisateur2 ELSE loginUtilisateur1 
            END AS ami FROM sympathiser WHERE utilisateurConnecte IN (loginUtilisateur1, loginUtilisateur2)) 
            LOOP
                DBMS_OUTPUT.PUT_LINE('Ami : ' || ami_rec.ami);
                v_amis_trouves := 1;  -- Un ami trouvé
            END LOOP;
            -- Afficher le message si aucun ami n'a été trouvé
        IF v_amis_trouves = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Pas encore d''ami.');
        END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Vous devez être connecté pour afficher la liste d''amis.');
        END IF;
    END afficherAmi;
    
        -- PROCEDURE chercherMembre : Cherche un membre par préfixe de login
    PROCEDURE chercherMembre(p_prefixeLoginMembre IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Vérifie si un utilisateur est connecté
        IF utilisateurConnecte IS NOT NULL THEN
            -- Boucle sur les utilisateurs correspondant au préfixe du login
            FOR v_Utilisateur IN (SELECT DISTINCT loginutilisateur FROM Utilisateur WHERE loginUtilisateur LIKE ('%'||p_prefixeLoginMembre||'%')) 
            LOOP
                DBMS_OUTPUT.PUT_LINE('Utilisateur : '||v_Utilisateur.loginutilisateur);
            END LOOP;
        ELSE
            dbms_output.put_line('Vous devez être connecté pour effectuer cette action');
        END IF;
    END chercherMembre;
    
    -- PROCEDURE afficherMur : Affiche le mur d'un utilisateur avec les réponses aux posts
    PROCEDURE afficherMur(p_loginUtilisateur IN utilisateur.loginUtilisateur%TYPE) IS
    BEGIN
        -- Vérifie si un utilisateur est connecté
        IF utilisateurConnecte IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Mur de '||p_loginUtilisateur);
            -- Boucle sur les messages et les réponses associées
            FOR post IN (SELECT DISTINCT m.idMessage, m.message, m.datePublication, m.loginUtilisateurE, r.loginUtilisateurE AS reponse_auteur, r.message AS reponse_message, r.datePublication AS reponse_date
                FROM Message m
                LEFT JOIN ReponseMessage r ON m.idMessage = r.idMessageParent
                WHERE m.loginUtilisateurR = p_loginUtilisateur ORDER BY m.datePublication DESC, r.datePublication)
            LOOP
                DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Post '||post.idMessage||' de '||post.loginUtilisateurE|| ' posté le '|| post.datePublication ||' :'|| CHR(10) || post.message|| CHR(10)|| '--------------');
                -- Affiche la réponse associée, le cas échéant
                IF post.reponse_message IS NOT NULL THEN
                    DBMS_OUTPUT.PUT_LINE('Réponse de ' || post.reponse_auteur || ' le ' || post.reponse_date || ': ' || post.reponse_message|| CHR(10) || '--------------');
                END IF;
            END LOOP;
        ELSE
            dbms_output.put_line('Vous devez être connecté pour effectuer cette action');
        END IF;
    END afficherMur;
    
        -- PROCEDURE ajouterMessageMur : Ajoute un message au mur d'un utilisateur
    PROCEDURE ajouterMessageMur(p_loginUtilisateurR IN utilisateur.loginUtilisateur%TYPE, p_message IN message.message%TYPE) IS
        v_amitie_existe NUMBER := 0;
    BEGIN
        -- Vérifie si un utilisateur est connecté
        IF utilisateurConnecte IS NOT NULL THEN
            -- Vérifier si l'amitié existe déjà
            SELECT COUNT(*) INTO v_amitie_existe
            FROM Sympathiser
            WHERE (loginUtilisateur1, loginUtilisateur2) IN ((utilisateurConnecte, p_loginUtilisateurR), (p_loginUtilisateurR, utilisateurConnecte));
            
            -- Si l'amitié existe ou si l'utilisateur est lui-même, ajouter le message au mur
            IF v_amitie_existe > 0 OR utilisateurConnecte =  p_loginUtilisateurR THEN
                INSERT INTO message VALUES (1, p_message, SYSDATE, utilisateurConnecte, p_loginUtilisateurR);
                COMMIT;
            ELSE
                dbms_output.put_line('Vous devez être ami avec cette personne pour pouvoir effectuer cette action');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Vous devez être connecté pour effectuer cette action');
        END IF;
    END ajouterMessageMur;
    
    -- PROCEDURE supprimerMessageMur : Supprime un message du mur d'un utilisateur
    PROCEDURE supprimerMessageMur(p_idMessage IN message.idMessage%TYPE) IS
        idReceveur utilisateur.loginUtilisateur%TYPE;
    BEGIN
        -- Vérifie si un utilisateur est connecté
        IF utilisateurConnecte IS NOT NULL THEN
            -- Récupère le login de l'utilisateur receveur du message
            SELECT loginUtilisateurR INTO idReceveur FROM Message WHERE idMessage = p_idMessage;
            
            -- Si l'utilisateur connecté est le receveur, supprimer le message ainsi que les réponses
            IF idReceveur = utilisateurConnecte THEN
                DELETE FROM REPONSEMESSAGE WHERE IDMESSAGEPARENT = p_idMessage;
                DELETE FROM Message WHERE idMessage = p_idMessage;
                COMMIT;
                DBMS_OUTPUT.PUT_LINE('Le message a bien été supprimé');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Vous pouvez uniquement supprimer les messages de votre mur');
            END IF;
        ELSE
            dbms_output.put_line('Vous devez être connecté pour effectuer cette action');
        END IF;
    END supprimerMessageMur;
    
    -- PROCEDURE repondreMessageMur : Répond à un message sur le mur d'un utilisateur
    PROCEDURE repondreMessageMur(p_idMessage IN message.idMessage%TYPE, p_messageReponse IN ReponseMessage.message%TYPE) IS
        idMessage message.idMessage%TYPE;
        idReceveur message.loginUtilisateurR%TYPE;
        v_amitie_existe NUMBER := 0;
    BEGIN
        -- Vérifie si un utilisateur est connecté
        IF utilisateurConnecte IS NOT NULL THEN
            -- Récupère l'ID du message et le login du receveur
            EXECUTE IMMEDIATE 'LOCK TABLE ReponseMessage IN EXCLUSIVE MODE NOWAIT';
            SELECT idMessage, loginUtilisateurR INTO idMessage, idReceveur FROM Message WHERE idMessage = p_idMessage;
            
            -- Vérifie si l'amitié existe
            SELECT COUNT(*) INTO v_amitie_existe
            FROM Sympathiser
            WHERE (loginUtilisateur1, loginUtilisateur2) IN ((utilisateurConnecte, idReceveur), (idReceveur, utilisateurConnecte));
            
            -- Si l'amitié existe et l'ID du message est valide, ajouter la réponse au message
            IF (v_amitie_existe > 0 OR utilisateurConnecte =  idReceveur) AND idMessage IS NOT NULL THEN
                INSERT INTO ReponseMessage VALUES (p_idMessage, utilisateurConnecte, p_messageReponse, SYSDATE);
                COMMIT;
            ELSE
                dbms_output.put_line('Vous devez être ami avec cette personne pour pouvoir effectuer cette action');
            END IF;
        ELSE
            dbms_output.put_line('Vous devez être connecté pour effectuer cette action');
        END IF;
    END repondreMessageMur;
    
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

EXECUTE PackFasseBouc.chercherMembre('a');

EXECUTE PackFasseBouc.afficherMur('tauleigq');

EXECUTE PackFasseBouc.supprimerMessageMur(1);

EXECUTE PackFasseBouc.ajouterMessageMur('tauleigq','onix');

EXECUTE PackFasseBouc.repondreMessageMur(3, 'bienvue');
SELECT * FROM ReponseMessage;
