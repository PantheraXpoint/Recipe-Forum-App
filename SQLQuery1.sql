CREATE DATABASE RECIPE_APP
USE RECIPE_APP


CREATE TABLE ACCOUNT(
	ACC_ID INTEGER NOT NULL IDENTITY(1,1),
	EMAIL VARCHAR(255) NOT NULL,
	DONATION_AMOUNT INTEGER NULL,
	USERNAME VARCHAR(255) NOT NULL,
	FOLLOWER_COUNT INTEGER NULL,
	DONATION_COUNT INTEGER NULL,
	IMAGE_URL VARCHAR(255) NULL,
	PASSWORD_HASH VARCHAR(255) NOT NULL,
	PRIMARY KEY (ACC_ID)
);
GO
CREATE TABLE DONATION_REC(
	DON_ID INTEGER NOT NULL IDENTITY(1,1),
	DONOR_ID INTEGER NOT NULL,
	RECIPIENT_ID INTEGER NOT NULL,
	AMOUNT INTEGER NOT NULL,
	DATE_D VARCHAR(255) NOT NULL,
	PRIMARY KEY(DON_ID)
);
GO
CREATE TABLE COMMENT(
	COM_ID INTEGER NOT NULL IDENTITY(1,1),
	RATING INTEGER NOT NULL,
	DATE VARCHAR(255) NOT NULL,
	CONTENT VARCHAR(	255) NOT NULL,
	PROFILE_COMMENT_ID INTEGER NOT NULL,
	RECIPE_COMMENT_ID INTEGER NOT NULL,
	PRIMARY KEY (COM_ID)
);
GO
CREATE TABLE INGREDIENT(
	INGRE_ID INTEGER NOT NULL IDENTITY(1,1),
	NAME VARCHAR(255) NOT NULL,
	UNIT VARCHAR(255) NOT NULL,
	PRIMARY KEY (INGRE_ID)
);
GO
CREATE TABLE RECIPE(
	REC_ID INTEGER NOT NULL IDENTITY(1,1),
	RATING INTEGER NOT NULL,
	SAVE_COUNT INTEGER NOT NULL,
	TITLE VARCHAR(255) NOT NULL,
	THUMBNAIL_URL VARCHAR(255) NOT NULL,
	VIEW_COUNT VARCHAR(255) NOT NULL,
	PROFILE_ID INTEGER NOT NULL,
	PRIMARY KEY (REC_ID)
);
GO
CREATE TABLE STEP(
	S_ID INTEGER NOT NULL IDENTITY(1,1),
	CONTENT VARCHAR(255) NOT NULL,
	IMAGE_URL VARCHAR(255) NOT NULL,
	RECIPE_STEP_ID INTEGER NOT NULL,
	PRIMARY KEY (S_ID)
);
GO
CREATE TABLE CAT_GROUP(
	CG_ID INTEGER NOT NULL IDENTITY(1,1),
	NAME VARCHAR(255) NOT NULL,
	PRIMARY KEY (CG_ID)
);
GO
CREATE TABLE CATEGORY(
	CAT_ID INTEGER NOT NULL IDENTITY(1,1),
	NAME VARCHAR(255) NOT NULL,
	CG_ID INTEGER NOT NULL,
	PRIMARY KEY (CAT_ID)
);
GO
CREATE TABLE RECIPE_CAT(
	RECIPE_CAT_ID INTEGER NOT NULL,
	CATEGORY_ID INTEGER NOT NULL,
	PRIMARY KEY (RECIPE_CAT_ID , CATEGORY_ID)
);
GO
CREATE TABLE RECIPE_INGREDIENT(
	RECIPE_INGRE_ID INTEGER NOT NULL,
	INGREDIENT_ID INTEGER NOT NULL,
	QUANTITIATIVE FLOAT NOT NULL,
	PRIMARY KEY (RECIPE_INGRE_ID, INGREDIENT_ID)
);
GO

ALTER TABLE RECIPE_INGREDIENT
ADD CONSTRAINT FK_RECIPE_INGRE_ID FOREIGN KEY (RECIPE_INGRE_ID) REFERENCES RECIPE (REC_ID),
	CONSTRAINT FK_INGREDIENT_ID FOREIGN KEY (INGREDIENT_ID) REFERENCES INGREDIENT (INGRE_ID);
GO
ALTER TABLE RECIPE_CAT
ADD CONSTRAINT FK_RECIPE_CAT_ID FOREIGN KEY (RECIPE_CAT_ID) REFERENCES RECIPE(REC_ID),
	CONSTRAINT FK_CATEGORY_ID FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY (CAT_ID);
GO
ALTER TABLE CATEGORY 
ADD CONSTRAINT FK_CG_ID FOREIGN KEY (CG_ID) REFERENCES CAT_GROUP (CG_ID);
GO
ALTER TABLE STEP
ADD CONSTRAINT FK_RECIPE_STEP_ID FOREIGN KEY (RECIPE_STEP_ID) REFERENCES RECIPE (REC_ID);
GO
ALTER TABLE RECIPE
ADD CONSTRAINT FK_PROFILE_ID FOREIGN KEY (PROFILE_ID) REFERENCES ACCOUNT (ACC_ID);
GO
ALTER TABLE COMMENT
ADD CONSTRAINT FK_PROFILE_COMMENT_ID FOREIGN KEY (PROFILE_COMMENT_ID) REFERENCES ACCOUNT(ACC_ID),
	CONSTRAINT FK_RECIPE_COMMENT_ID FOREIGN KEY (RECIPE_COMMENT_ID) REFERENCES RECIPE(REC_ID);
GO
ALTER TABLE DONATION_REC
ADD CONSTRAINT FK_DONOR_ID FOREIGN KEY (DONOR_ID) REFERENCES ACCOUNT (ACC_ID),
	CONSTRAINT FK_RECIPIENT_ID FOREIGN KEY (RECIPIENT_ID) REFERENCES ACCOUNT (ACC_ID);
GO

-----------------------------------------

ALTER TABLE RECIPE_INGREDIENT
DROP CONSTRAINT FK_RECIPE_INGRE_ID,
	CONSTRAINT FK_INGREDIENT_ID;
GO
ALTER TABLE RECIPE_CAT
DROP CONSTRAINT FK_RECIPE_CAT_ID,
	CONSTRAINT FK_CATEGORY_ID;
GO
ALTER TABLE CATEGORY 
DROP CONSTRAINT FK_CG_ID;
GO
ALTER TABLE STEP
DROP CONSTRAINT FK_RECIPE_STEP_ID;
GO
ALTER TABLE RECIPE
DROP CONSTRAINT FK_PROFILE_ID;
GO
ALTER TABLE COMMENT
DROP CONSTRAINT FK_PROFILE_COMMENT_ID,
	CONSTRAINT FK_RECIPE_COMMENT_ID;
GO
ALTER TABLE DONATION_REC
DROP CONSTRAINT FK_DONOR_ID,
	CONSTRAINT FK_RECIPIENT_ID;
GO

--DROP TABLE ACCOUNT
--DROP TABLE DONATION_REC
--DROP TABLE COMMENT
--DROP TABLE CAT_GROUP
--DROP TABLE CATEGORY
--DROP TABLE RECIPE_CAT
--DROP TABLE INGREDIENT
--DROP TABLE RECIPE
--DROP TABLE RECIPE_INGREDIENT
--DROP TABLE STEP

-------------------------------------------------------

CREATE TRIGGER HANDLE_DONATION_COUNT
ON DONATION_REC AFTER INSERT AS 
BEGIN
	UPDATE ACCOUNT
	SET DONATION_COUNT = DONATION_COUNT + 1
	FROM inserted
	WHERE ACC_ID = inserted.RECIPIENT_ID
END;


CREATE TRIGGER HANDLE_DONATION_AMOUNT
ON DONATION_REC AFTER INSERT AS
BEGIN
	UPDATE ACCOUNT
	SET DONATION_AMOUNT = DONATION_AMOUNT + inserted.AMOUNT
	FROM inserted
	WHERE ACC_ID = INSERTED.RECIPIENT_ID
END;

INSERT INTO DONATION_REC(DONOR_ID,RECIPIENT_ID,AMOUNT,DATE_D) VALUES (12,13,14,'12/5')

SELECT * FROM DONATION_REC