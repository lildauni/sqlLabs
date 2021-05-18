#Кількість тем може бути в діапазоні від 5 до 10.
DELIMITER $$

CREATE 
	TRIGGER topics_before_insert BEFORE INSERT
    ON topics
    FOR EACH ROW
    	IF (SELECT COUNT(*) FROM topics) > 10 THEN
        	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кількість тем більша 10';
        END IF;
    $$

CREATE 
	TRIGGER themes_before_delete BEFORE DELETE
    ON topics
    FOR EACH ROW
    	IF (SELECT COUNT(*) FROM topics) < 5 THEN
        	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кількість тем меньша 5';
        END IF;
    $$

DELIMITER ;


#Новинкою може бути тільки книга видана в поточному році.
DELIMITER $$

CREATE PROCEDURE check_new_state_with_year (IN isNew VARCHAR(3), IN pub_year INT)
IF (pub_year < 2021 AND isNew = 'Yes') THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Книга, видана раніше поточного року, не може бути новую';
END IF
$$

CREATE 
	TRIGGER books_new_state_before_insert BEFORE INSERT
    ON maininfo
    FOR EACH ROW
    	CALL check_new_state_with_year(NEW.IsNovelty, YEAR(NEW.PublishingDate));
    $$

CREATE 
	TRIGGER books_new_state_before_update BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
    	CALL check_new_state_with_year(NEW.IsNew, YEAR(NEW.pub_date));
    $$

DELIMITER ; 


#Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 30 $.
DELIMITER $$

CREATE PROCEDURE check_price_with_pages (IN price INT, IN pages INT)
IF (pages < 100 AND price > 10
    OR pages < 200 AND price > 20
    OR pages < 300 AND price > 30) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Відношення сторінки/ціна не є вірним';
END IF
$$

CREATE 
	TRIGGER books_price_before_insert BEFORE INSERT
    ON maininfo
    FOR EACH ROW
    	CALL check_price_with_pages(NEW.Price, NEW.pages);
    $$

CREATE 
	TRIGGER books_price_before_update BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
    	CALL check_price_with_pages(NEW.Price, NEW.pages);
    $$

DELIMITER ;   


#Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000.
DELIMITER $$

CREATE PROCEDURE check_pub_with_ed (IN pub_id VARCHAR(50), IN tir INT)
BEGIN
    SET @pub_name = (SELECT publisher_name
                       FROM publishernames 
                      WHERE id = pub_id);
    IF (@pub_name = 'BHV С.-Петербург' AND ed < 5000) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво BHV С.-Петербург не випускає книги накладом меншим 5000';
    ELSEIF (@pub_name = 'Diasoft' AND ed < 10000) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво Diasoft не випускає книги накладом меншим 10000';
    END IF;
END $$

CREATE 
	TRIGGER books_pub_before_insert BEFORE INSERT
    ON maininfo
    FOR EACH ROW
    	CALL check_pub_with_ed(NEW.publisher, NEW.tirage);
    $$

CREATE 
	TRIGGER books_pub_before_update BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
    	CALL check_pub_with_ed(NEW.publisher, NEW.tirage);
    $$

DELIMITER ;  	


#Книги з однаковим кодом повинні мати однакові дані.
DELIMITER $$

CREATE PROCEDURE check_book_code (IN n INT)
BEGIN
    IF ((SELECT COUNT(*)
          FROM (
               SELECT * FROM maininfo
                WHERE BookCode = book_code
                GROUP BY N, 
                         IsNew, 
                         book_title, 
                         price, 
                         pages, 
                         b_format, 
                         pub_date, 
                         tirage, 
                         topic, 
                         category,
			 publisher
          	   ) AS CountRows) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Книги з однаковим кодом повинні мати однакові дані';
    END IF;
END $$

CREATE 
	TRIGGER books_code_before_insert BEFORE INSERT
    ON maininfo
    FOR EACH ROW
    	CALL check_book_code(NEW.N);
    $$

CREATE 
	TRIGGER books_code_before_update BEFORE UPDATE	
    ON maininfo
    FOR EACH ROW
    	CALL check_book_code(NEW.N);
    $$

DELIMITER ;


#При спробі видалення книги видається інформація про кількість видалених рядків. Якщо користувач не "dbo", то видалення забороняється.
DELIMITER $$

CREATE 
	TRIGGER books_rows_before_delete BEFORE DELETE
    ON maininfo
    FOR EACH ROW
    	IF (CURRENT_USER() != 'dbo') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Користувач не має прав на зміну ціни';
        END IF;
    $$

DELIMITER ;


#Kористувач "dbo" не має права змінювати ціну книги.
DELIMITER $$

CREATE 
	TRIGGER books_price_change_before_update BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
    	IF (NEW.Price != OLD.Price 
    		AND (CURRENT_USER() = 'dbo')) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Користувач dbo не має прав на зміну ціни';
        END IF;
    $$

DELIMITER ;


#Видавництва ДМК і Еком підручники не видають.
DELIMITER $$

CREATE PROCEDURE check_pub_with_cat (IN pub_id INT, IN cat_id INT)
BEGIN
    SET @pub_name = (SELECT PubName
                       FROM publishernames
                      WHERE Id = pub_id);
    SET @cat_name = (SELECT CatName
                       FROM categories 
                      WHERE Id = category_id);
    IF ((@pub_name = 'ДМК' OR @pub_name = 'Эком') AND @cat_name = 'Підручники') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництва ДМК та Еком не видають підручники';
    END IF;
END $$

CREATE 
	TRIGGER books_pub_and_cat_before_insert BEFORE INSERT
    ON maininfo
    FOR EACH ROW
    	CALL check_pub_with_cat(NEW.publisher, NEW.category);
    $$

CREATE 
	TRIGGER books_pub_and_cat_before_update BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
    	CALL check_pub_with_cat(NEW.publisher, NEW.category);
    $$

DELIMITER ;  


#Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.
DELIMITER $$

CREATE PROCEDURE check_pub_year_for_new (IN pub_date DATE, IN pub_id INT)
IF EXISTS (SELECT p.PubName AS pub_name,
                  pub_date,
                  COUNT(*) AS count_books
             FROM maininfo AS b
          	 JOIN publishernames AS p
               ON b.publisher = p.Id
         	WHERE MONTH(b.pub_date) = MONTH(pub_date)
              AND YEAR(b.pub_date) = 2021
              AND b.IsNew = 'Yes'
              AND p.Id = pub_id
         GROUP BY pub_name
           HAVING count_books > 10) 
           THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Перевищена кількість новинок за мысяць';
END IF;
$$

CREATE 
	TRIGGER books_pub_year_for_new_before_insert BEFORE INSERT
    ON maininfo
    FOR EACH ROW
    	CALL check_pub_year_for_new(NEW.pub_date, NEW.publisher);
    $$

CREATE 
	TRIGGER books_pub_year_for_new_before_update BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
    	CALL check_pub_year_for_new(NEW.pub_date, NEW.publisher);
    $$

DELIMITER ;    


#Видавництво BHV не випускає книги формату 60х88 / 16.
DELIMITER $$

CREATE PROCEDURE check_pub_with_format (IN pub_id INT, IN format VARCHAR(10))
BEGIN
    SET @pub_name = (SELECT PubName
                       FROM publishernames 
                      WHERE Id = pub_id);
    IF (@pub_name = 'BHV С.-Петербург' AND format = '60х88/16') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво BHV С.-Петербург не підтримує даний формат';
    END IF;
END $$

CREATE 
	TRIGGER books_pub_and_format_before_insert BEFORE INSERT
    ON mainifo
    FOR EACH ROW
    	CALL check_pub_with_format(NEW.publisher, NEW.b_format);
    $$

CREATE 
	TRIGGER books_pub_and_format_before_update BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
    	CALL check_pub_with_format(NEW.pub_id, NEW.b_format);
    $$

DELIMITER ; 