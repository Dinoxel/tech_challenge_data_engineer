-- Désactive le SAFEMODE
SET SQL_SAFE_UPDATES = 0;

-- Affiche la database
SELECT * FROM address;


-- Ajoute les colonnes vides
ALTER TABLE address
ADD latitude float,
ADD longitude float,
ADD full_address VARCHAR(255);

-- Ajoute une nouvelle colonne avec toute l'adresse pour s'en servir dans l'url
UPDATE address SET full_address = REPLACE(CONCAT(address, ' ', city, ' ', postal_code), ' ', '+');


-- On switch sur Python ici pour ajouter les coordonnées géographiques



-- Compteur de valeurs NULL
select count(*) 'total', count(*) - count(latitude) 'total null' from address;
-- Compteur de valeurs NULL


-- Affiche tous les clients ayant effectués le plus de commandes
SELECT *
FROM (SELECT c.first_name, c.last_name, COUNT(r.customer_id) total_location, a.address, a.city, a.postal_code, a.latitude, a.longitude
FROM customer c
INNER JOIN address a ON c.address_id=a.address_id
INNER JOIN rental r ON c.customer_id=r.customer_id
GROUP by r.customer_id
ORDER by COUNT(r.customer_id) DESC) as best_buyer
HAVING best_buyer.total_location = MAX(best_buyer.total_location);





-- TEST pour obtenir plus de résultats, non concluant
-- Ajoute une nouvelle colonne avec toute l'adresse sauf la ville
ALTER TABLE address
ADD address_postal VARCHAR(255),
ADD address_postal_test VARCHAR(10);
UPDATE address SET address_postal = REPLACE(CONCAT(address, ' ', postal_code), ' ', '+');

ALTER TABLE address
DROP COLUMN address_postal,
DROP COLUMN address_postal_test;
