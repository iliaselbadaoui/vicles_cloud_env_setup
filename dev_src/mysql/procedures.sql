USE cary_DB;

DELIMITER $$
CREATE PROCEDURE `abortBooking`(IN `p_rent` INT(11))
BEGIN
	UPDATE rent r SET r.refused = 1 WHERE r.id = p_rent;
end$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getCarById`(IN `p_id` INT(11))
BEGIN
	SELECT * FROM car c WHERE c.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `cancelBooking`(IN p_rent INT(11))
BEGIN
	UPDATE rent r SET r.canceled = 1 WHERE r.id = p_rent;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `checkCostumerExistance`(IN `p_driverLicense` VARCHAR(32), IN `p_email` VARCHAR(100))
BEGIN
	SELECT c.id FROM costumer c WHERE c.driverLicense = p_driverLicense OR c.email = p_email;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `checkCostumersBooking`(IN `p_id` INT(11), IN `p_date` DATETIME)
BEGIN
	SELECT COUNT(r.id) AS 'count' FROM rent r WHERE r.start <= p_date AND r.end >= p_date AND r.costumer = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `checkGarageExistance`(IN `p_registryNumber` INT(11), IN `p_email` VARCHAR(100))
BEGIN 
	SELECT g.id FROM Garage g WHERE g.registryNumber = p_registryNumber OR g.email = p_email;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `checkNewGarageNotifs`(IN `p_garage` INT(11))
BEGIN
	SELECT COUNT(n.car) as 'count' FROM notifications n INNER JOIN car c ON c.id = n.car INNER JOIN Garage g ON g.id = c.garage WHERE g.id = p_garage and n.seen = 0 GROUP BY g.id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `deleteCar`(IN p_car int(11))
BEGIN
	DELETE FROM car WHERE id = p_car;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getBrandModels`(IN p_id int(11))
BEGIN
	SELECT m.id, m.modelName FROM model m WHERE m.brand = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getCarByMatricule`(IN `p_matricule` VARCHAR(32))
BEGIN
	SELECT c.id AS cars FROM car c WHERE c.matricule = p_matricule;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getCarsBrands`()
BEGIN
	SELECT b.id, b.brandName FROM brand b;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getCostumerNotifs`(IN `p_costumer` INT(11))
BEGIN
	SELECT r.id, r.start, r.end, g.companyName, g.logo as 'companyLogo', m.modelName, b.logo, r.validated, r.refused, r.canceled FROM rent r INNER JOIN costumer co ON r.costumer = co.id INNER JOIN car c ON r.car = c.id INNER JOIN Garage g ON c.garage = g.id INNER JOIN model m ON c.model = m.id INNER JOIN brand b ON b.id = m.brand WHERE co.id = p_costumer;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getCostumerPerformance`(IN `p_id` INT(11))
BEGIN
	SELECT cgr.garageCount, ctr.rentsCount, cp.carState, cp.behavior, cp.reactivity FROM costumer_total_rents ctr INNER JOIN costumer_garages_rent cgr ON ctr.costumer = cgr.costumer INNER JOIN costumer_perfprmance cp ON cgr.costumer = cp.costumer WHERE cp.costumer=p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getCostumerReviewNotification`(IN `p_costumer` INT(11))
BEGIN
	SELECT DISTINCT r.id as 'rentID', g.id, g.companyName, g.logo as 'companyLogo', m.modelName, b.logo,  b.logo FROM rent r INNER JOIN costumer co ON r.costumer = co.id INNER JOIN car c ON r.car = c.id INNER JOIN model m ON c.model = m.id INNER JOIN brand b ON m.brand = b.id INNER JOIN Garage g ON c.garage = g.id WHERE co.id = p_costumer AND r.validated=1 AND r.garageEvaluated = 0 AND r.end < NOW();
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getFuel`()
BEGIN
	SELECT * FROM fuel f ORDER BY f.fuelType ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getGarageNotifs`(IN `p_garage` INT(11))
BEGIN
	SELECT DISTINCT r.id as 'rentID', co.phone, co.fullName, co.photo, c.matricule, r.start, r.end, m.modelName, b.logo, n.seen, cpe.behavior, cpe.reactivity, cpe.carState FROM notifications n INNER JOIN car c ON n.car = c.id INNER JOIN model m ON c.model = m.id INNER JOIN brand b ON m.brand = b.id INNER JOIN rent r ON c.id = r.car INNER JOIN Garage g ON c.garage = g.id INNER JOIN costumer_perfprmance cpe ON n.costumer = cpe.costumer INNER JOIN costumer co ON n.costumer = co.id WHERE g.id = p_garage AND r.validated=0 AND r.refused = 0 AND r.canceled = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getGarageOldNotifs`(IN `p_garage` INT(11))
BEGIN
	SELECT r.id as 'rentID', co.phone, co.fullName, co.photo, c.matricule, r.start, r.end, m.modelName, b.logo, r.validated, r.refused, r.canceled, n.seen, AVG(cpe.behavior) AS 'behavior', AVG(cpe.reactivity) AS 'reactivity', AVG(cpe.carState) as 'carState' FROM rent r INNER JOIN car c ON r.car = c.id INNER JOIN Garage g ON g.id = c.garage INNER JOIN costumer co ON co.id = r.costumer INNER JOIN model m ON m.id = c.model INNER JOIN brand b ON b.id = m.brand INNER JOIN notifications n ON n.car = c.id INNER JOIN clientProfileEvaluation cpe ON cpe.costumer = r.costumer WHERE g.id = p_garage and (r.validated = 1 OR r.refused = 1 OR r.canceled = 1)
    GROUP BY r.id, co.fullName, co.photo, c.matricule, r.start, r.end, m.modelName, b.logo, n.seen, r.validated, r.refused, r.canceled;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getGaragePerformance`(IN `p_id` INT(11))
BEGIN
	SELECT gcc.costumersCount, gtr.rentsCount, gpv.behavior, gpv.reactivity, gpv.quality, gpv.service, gpv.price FROM garage_costumers_count gcc INNER JOIN garage_total_rents gtr ON gcc.garage = gtr.garage INNER JOIN garageperformanceview gpv ON gpv.id = gtr.garage WHERE gpv.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getGarageReviewNotification`(IN `p_garage` INT(11))
BEGIN
	SELECT DISTINCT r.id as 'rentID', co.id, co.phone, co.fullName, co.photo, c.matricule, r.start, r.end, m.modelName, b.logo, n.seen, cpe.behavior, cpe.reactivity, cpe.carState FROM notifications n INNER JOIN car c ON n.car = c.id INNER JOIN model m ON c.model = m.id INNER JOIN brand b ON m.brand = b.id INNER JOIN rent r ON c.id = r.car INNER JOIN Garage g ON c.garage = g.id INNER JOIN costumer_perfprmance cpe ON r.costumer = cpe.costumer INNER JOIN costumer co ON r.costumer = co.id WHERE g.id = p_garage AND r.validated=1 AND r.costumerEvaluated = 0 AND r.end < NOW();
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getGarageTotaleClients`(IN `p_garage` INT(11))
BEGIN
	SELECT r.costumer, COUNT(r.costumer) as 'costumers'  FROM rent r LEFT JOIN car c on r.car = c.id LEFT JOIN Garage g on c.garage = g.id WHERE g.id = p_garage GROUP BY r.costumer;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getUpdatedCostumerData`(IN p_id INT(11))
BEGIN
	SELECT c.id, c.fullName, c.driverLicense, c.address, c.email, c.phone, c.photo, c.active FROM costumer c WHERE c.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `getUpdatedGarageData`(IN p_id INT(11))
BEGIN
	SELECT g.id, g.companyName, g.registryNumber, g.address, g.phone, g.email, g.logo, g.active FROM Garage g WHERE g.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertCar`(IN `p_model` INT(11), IN `p_fuel` INT(11), IN `p_matricule` VARCHAR(32), IN `p_consumption` FLOAT, IN `p_price` INT(11), IN `p_pic1` LONGTEXT, IN `p_pic2` LONGTEXT, IN `p_pic3` LONGTEXT, IN `p_pic4` LONGTEXT, IN `p_garage` INT(11))
BEGIN 
	INSERT INTO car(model, fuel, matricule, consumption, price, pic1, pic2, pic3, pic4, garage)VALUES(`p_model`,`p_fuel`,`p_matricule`,`p_consumption`,`p_price`,`p_pic1`,`p_pic2`,`p_pic3`,`p_pic4`,`p_garage`);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertCostumer`(IN `p_fullName` VARCHAR(100), IN `p_driverLicense` VARCHAR(32), IN `p_address` VARCHAR(500), IN `p_email` VARCHAR(100), IN `p_phone` VARCHAR(12), IN `p_password` VARCHAR(128))
BEGIN
	INSERT INTO costumer (fullName, driverLicense, address, email, phone, `password`, active) VALUES
	(p_fullName, p_driverLicense, p_address, p_email, p_phone, p_password, TRUE);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertCostumerReview`(IN p_costumer INT(11), IN p_garage INT(11), IN p_carSatate INT(1), IN p_behavior INT(1), IN p_reactivity INT(1))
BEGIN
	INSERT INTO clientProfileEvaluation (costumer, garage, carState, behavior, reactivity) VALUES (p_costumer, p_garage, p_carSatate, p_behavior, p_reactivity);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertGarage`(IN `p_name` VARCHAR(250), IN `p_registry` INT(11), IN `p_address` VARCHAR(500), IN `p_phone` VARCHAR(12), IN `p_email` VARCHAR(100), IN `p_password` VARCHAR(128))
BEGIN
	INSERT INTO Garage (companyName, registryNumber, address, phone, email, password, active) VALUES (p_name, p_registry, p_address, p_phone, p_email, p_password, TRUE);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertGarageNotification`(IN `p_costumer` INT(11), IN `p_car` INT(11))
BEGIN
	INSERT INTO notifications (costumer, car, type) VALUES (p_costumer, p_car, 'g');
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertGarageReview`(IN p_costumer INT(11), IN p_garage INT(11), IN p_quality INT(1), IN p_behavior INT(1), IN p_reactivity INT(1), IN p_service INT(1), IN p_price INT(1))
BEGIN
	INSERT INTO garageProfileEvaluation (costumer, garage, quality, behavior, reactivity, service, price) VALUES (p_costumer, p_garage, p_quality, p_behavior, p_reactivity, p_service, p_price);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertInvalidRental`(IN `p_costumer` INT(11), IN `p_car` INT(11), IN `p_start` DATETIME, IN `p_end` DATETIME, IN `p_address` VARCHAR(500), IN `p_retAddress` VARCHAR(500))
BEGIN
	INSERT INTO rent (costumer, car, `start`, `end`, deliveryAddress, returnAddress, validated) VALUES (p_costumer, p_car, p_start, p_end, p_address, p_retAddress, 0);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `loginCostumer`(IN `p_email` VARCHAR(100), IN `p_password` VARCHAR(128))
BEGIN
	SELECT c.id, c.fullName, c.driverLicense, c.address, c.email, c.phone, c.photo, c.active FROM costumer c WHERE c.email = p_email and c.password = p_password;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `loginGarage`(IN p_email varchar(100), IN p_password varchar(128))
BEGIN
	SELECT g.id, g.companyName, g.registryNumber, g.address, g.phone, g.email, g.logo, g.active FROM Garage g WHERE g.email = p_email and g.password = p_password;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `rentCostumerReviewed`(IN p_rent INT(11))
BEGIN
	UPDATE rent r SET r.costumerEvaluated = 1 WHERE r.id = p_rent;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `rentGarageReviewed`(IN p_id INT(11))
BEGIN
	UPDATE rent r SET r.garageEvaluated = 1 WHERE r.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `retriveAllCars`()
BEGIN
	SELECT ca.*, m.modelName, b.logo, g.id as 'garageId', g.companyName, g.logo as 'garageLogo', f.fuelType, gpv.behavior, gpv.reactivity, gpv.quality, gpv.service, gpv.price as 'performance_price'  FROM car ca INNER JOIN model m ON m.id = ca.model INNER JOIN brand b ON b.id = m.brand INNER JOIN Garage g ON ca.garage = g.id INNER JOIN fuel f ON f.id = ca.fuel INNER JOIN garageperformanceview gpv ON g.id = gpv.id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `retriveCarHistory`(IN p_id INT(11))
BEGIN
	SELECT co.photo, co.fullName, c.matricule, co.phone, r.start, r.end, c.price, b.logo as 'brand', m.modelName FROM costumer co INNER JOIN rent r ON co.id = r.costumer INNER JOIN car c ON r.car = c.id INNER JOIN model m ON c.model = m.id INNER JOIN brand b ON m.brand = b.id  WHERE c.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `retriveCostumerHistory`(IN `p_id` INT(11))
BEGIN
	SELECT g.logo, g.companyName, r.start, r.end, c.price, b.logo as 'brand', m.modelName FROM costumer co INNER JOIN rent r ON co.id = r.costumer INNER JOIN car c ON r.car = c.id INNER JOIN model m ON c.model = m.id INNER JOIN brand b ON m.brand = b.id INNER JOIN Garage g ON c.garage = g.id WHERE co.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `retriveGarageCars`(IN `p_garage` INT(11))
BEGIN
	SELECT c.*, m.id as 'modelId', b.id as 'brandId',m.modelName, b.logo FROM car c INNER JOIN model m on c.model = m.id INNER JOIN brand b ON m.brand = b.id WHERE c.garage = p_garage;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `retriveGarageHistory`(IN `p_id` INT(11))
BEGIN
	SELECT co.photo, co.fullName, c.matricule, co.phone, r.start, r.end, c.price, b.logo as 'brand', m.modelName FROM costumer co INNER JOIN rent r ON co.id = r.costumer INNER JOIN car c ON r.car = c.id INNER JOIN model m ON c.model = m.id INNER JOIN brand b ON m.brand = b.id  WHERE c.garage = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateCar`(IN p_id INT(11), IN p_model INT(11), IN p_fuel INT(11), IN p_matricule VARCHAR(11), IN p_consumption FLOAT, IN p_price INT(11),
                          IN p_pic1 longtext, IN p_pic2 longtext, IN p_pic3 longtext, IN p_pic4 longtext)
BEGIN
	UPDATE car c SET c.model = p_model, c.fuel = p_fuel, c.matricule = p_matricule, c.consumption = p_consumption,
    		c.price = p_price, c.pic1 = p_pic1, c.pic2 = p_pic2, c.pic3 = p_pic3, c.pic4 = p_pic4 WHERE c.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateCostumer`(IN p_id INT(11), IN p_fullName VARCHAR(100), IN p_driverLicense VARCHAR(32), IN p_address VARCHAR(500),
                               IN p_email VARCHAR(100), IN p_phone VARCHAR(12))
BEGIN
	UPDATE costumer c set c.fullName = p_fullName, c.driverLicense = p_driverLicense, c.address = p_address, c.phone = p_phone;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateCostumerImage`(IN p_id INT(11), IN p_image LONGTEXT)
BEGIN
	UPDATE costumer c set c.photo = p_image WHERE c.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateCostumerPassword`(IN p_id INT(11), IN p_old VARCHAR(128), IN p_new VARCHAR(128))
BEGIN
	UPDATE costumer c set c.password = p_new WHERE c.id = p_id and c.password = p_old;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateGarage`(IN `p_id` INT(11), IN `p_companyName` VARCHAR(250), IN `p_registryNumber` INT(11), IN `p_address` VARCHAR(500), IN `p_email` VARCHAR(100), IN `p_phone` VARCHAR(12))
BEGIN
	UPDATE Garage SET 
    companyName = p_companyName, 
    registryNumber = p_registryNumber, 
    address = p_address, 
    email = p_email, 
    phone = p_phone WHERE id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateGarageImage`(IN `p_id` INT(11), IN `p_image` LONGTEXT)
BEGIN
	UPDATE Garage g SET g.logo = p_image WHERE g.id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateGaragePassword`(IN p_id INT(11),IN p_oldPassword varchar(128), IN p_newPassword varchar(128))
BEGIN
	UPDATE Garage g SET g.password = p_newPassword WHERE g.id = p_id and g.password = p_oldPassword;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `updateNotificationsStatus`(IN p_garage int(11))
BEGIN
	UPDATE notifications n INNER JOIN car c ON c.id = n.car INNER JOIN Garage g ON g.id = c.garage SET n.seen = 1 WHERE g.id = p_garage;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `validateBooking`(IN `p_rentId` INT(11))
BEGIN
	UPDATE rent r SET r.validated = 1 WHERE r.id = p_rentId;
END$$
DELIMITER ;
