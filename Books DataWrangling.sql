
	Select *
	from dbo.books$
--------------------------------------------------------------------------------------------------------------------

-- Numbers of books (from 2000 - 2022)
 
	Select count (Distinct (title) ) as TotalNumber
	from dbo.books$
	where Year(dateConverted) >=2000
--------------------------------------------------------------------------------------------------------------------

-- Book ranked on bestseller ( from Year 2000 tp Year 2022)

	Select title, Year(dateConverted)as Year ,count (Year(dateConverted)) as No_of_Year
	from dbo.books$
	where Year(dateConverted)>=2000
	group by title,dateConverted
	having count (Year(dateConverted)) > 1
	order by dateConverted DESC
  
--------------------------------------------------------------------------------------------------------------------

-- Price summary

	Select min (price) as minPrice,
	max (price)as maxPrice,
	round(avg(price),2) as meanPrice
	from dbo.books$
	
--which book is expensive

	Select top 1 (title), sum(price) as total
	from dbo.books$
	group by title
	order by total DESC

-------------------------------------------------------------------------------------------------------------------- 

-- Author with most bestselling books

	Select top 1 author, count ( distinct title) as number_of_books
	from dbo.books$
	group by author
	order by number_of_books DESC

-- List of books from the bestselling author

	Select title,Year(dateConverted) as year, price,author
	from dbo.books$	
	where author =
	(
	 Select top 1 author
	 from dbo.books$	
	 group by author
	 order by count ( distinct title) DESC
	)
	order by Year(dateConverted),title

-------------------------------------------------------------------------------------------------------------------- 

-- Highest rating for each author 

	Select author, title, Year(dateConverted) as year, rating,
	max (rating) over (partition by author order by Year(dateConverted) ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as Max_rating
	from dbo.books$	
	order by Max_rating DESC,author
  
   
-------------------------------------------------------------------------------------------------------------------- 
-- Books with top 10 reviews each year  
 
  With top10_reviews as
  (
	Select title,Year(dateConverted) as year, author, reviews,
	rank() over (partition by Year(dateConverted) order by reviews DESC) as rank_of_reviews
	from dbo.books$	
  )
   
   Select *
   from top10_reviews
   where rank_of_reviews BETWEEN 1 AND 10
   order by 2 DESC, rank_of_reviews