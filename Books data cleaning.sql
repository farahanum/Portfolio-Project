/*
 Cleaning Data in SQL query
*/

	Select *
	from dbo.books$
--------------------------------------------------------------------------------------------------------------------

-- To check data type for each column

	Select column_name, data_type
	from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME = 'books$'

--------------------------------------------------------------------------------------------------------------------

-- Check for duplicate value 

	WITH CTE_SRC AS (
		Select *,
		ROW_NUMBER() OVER (PARTITION BY TITLE,Isbn,AUTHOR ORDER BY Date) ROWNUM
		from dbo.books$
		)
	SELECT *
	FROM CTE_SRC
	WHERE ROWNUM >1

 -- Delete Duplicate Value

	WITH CTE_SRC AS (
		Select *,
		ROW_NUMBER() OVER (PARTITION BY TITLE,Isbn,AUTHOR ORDER BY Date) ROWNUM
		from dbo.books$
		)
	DELETE
	FROM CTE_SRC
	WHERE ROWNUM >1

--------------------------------------------------------------------------------------------------------------------

--Change NULL value in Discounted_price field

	SELECT discount_rate, discounted_price, price,
	case
		when discounted_price IS NULL then (price - (discount_rate *100))
		else discounted_price
	end
	from dbo.books$

	UPDATE dbo.books$
	SET discounted_price = case
							when discounted_price IS NULL then (price - (discount_rate *100))
							else discounted_price
						   end
 
--------------------------------------------------------------------------------------------------------------------

 -- Change NULL value in Price field

	SELECT discount_rate, discounted_price, price,
	case
		when Price is NULL then (discounted_price/1- discount_rate)
		else Price
	end
	from dbo.books$

	UPDATE dbo.books$
	SET price = case
					when price IS NULL then (discounted_price / 1- discount_rate)
					else price
				end
--------------------------------------------------------------------------------------------------------------------

-- Drop NULL values in discounted_price and Price rows

	SELECT *
	from dbo.books$
	where price is null and discounted_price is null

	delete from dbo.books$
	where price is null and discounted_price is null

--------------------------------------------------------------------------------------------------------------------

 -- Standardize date format

	SELECT date,dateConverted
	from dbo.books$

	ALTER TABLE dbo.books$
	add dateConverted date
	
	UPDATE dbo.books$
	SET dateConverted = CONVERT (date,date)
	

--------------------------------------------------------------------------------------------------------------------	

 -- Changing data types

 ALTER TABLE dbo.books$
 ALTER COLUMN page INT 

--------------------------------------------------------------------------------------------------------------------

-- Standardize the price to 2 decimal places

 Select discounted_price,price,discount_rate
 from dbo.books$

 UPDATE dbo.books$
 SET discounted_price= CAST(discounted_price AS decimal(5,2))

 ALTER TABLE dbo.books$
 ALTER COLUMN discounted_price DECIMAL (5,2)

 UPDATE dbo.books$
 SET price= CAST(price AS decimal(5,2))

 ALTER TABLE dbo.books$
 ALTER COLUMN price DECIMAL (5,2)

 UPDATE dbo.books$
 SET discount_rate= CAST(discount_rate AS decimal(5,2))

 ALTER TABLE dbo.books$
 ALTER COLUMN discount_rate DECIMAL (5,2)

--------------------------------------------------------------------------------------------------------------------

 --delete unused column

 SELECT *
 FROM dbo.books$

 ALTER TABLE dbo.books$
 DROP COLUMN link,image,paper,date

 