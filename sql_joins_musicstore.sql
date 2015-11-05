
-- Problem set week 4

-- Please load music-store database

-- Please add the proper SQL query to follow the instructions below
-- Answer at least to 12 out of the 18 questions provided  


------------------------------------------------
use musicstore;
------------------------------------------------

-- 1.Show the Number of tracks whose composer is F. Baltes
-- (Note: there can be more than one composers or each track)

SELECT count(*) FROM Track
WHERE Composer LIKE '%F. Baltes%';


-- 2.Show the Number of invoices, and the number of invoices with a total amount =0

SELECT 
	count(*) AS Total_Invoices,
    sum(CASE WHEN Total=0 THEN 1 ELSE 0 END) AS Zero_Amount_Invoices
FROM Invoice;

-- 3.Show the album title and artist name of the first five albums sorted alphabetically

SELECT
	a.Title as Album_Title,
    b.Name as Artist_Name
FROM Album a
	LEFT JOIN Artist b
    ON a.ArtistId = b.ArtistId
ORDER BY a.Title asc
LIMIT 5;

-- 4.Show the Id, first name, and last name of the 10 first customers 
-- alphabetically ordered. Include the id, first name and last name 
-- of their support representative (employee)
 
SELECT
	a.CustomerId as Customer_ID,
    a.FirstName as Customer_FirstName,
    a.LastName as Customer_LastName,
    b.EmployeeId as SalesRep_ID,
    b.FirstName as SalesRep_FirstName,
    b.LastName as SalesRep_Lastname
    
FROM Customer a
	 LEFT JOIN Employee b
     ON a.SupportRepId = b.EmployeeId 
ORDER BY a.FirstName, a.LastName asc
LIMIT 10
;

-- 5.Show the Track name, duration, album title, artist name,
--  media name, and genre name for the five longest tracks

SELECT
	a.Name as Track_Name,
    a.Milliseconds as Duration,
    b.Title as Album_Title,
    c.Name as Artist_name,
    d.Name as Media_name,
    e.Name as Genre_name

FROM Track a
	 LEFT JOIN Album b
     ON a.AlbumId = b.AlbumId
		LEFT JOIN Artist c
        ON b.ArtistId = c.ArtistId
	 LEFT JOIN MediaType d
	 ON a.MediaTypeId = d.MediaTypeId
     LEFT JOIN Genre e
     ON a.GenreId = e.GenreId
ORDER BY Duration desc
LIMIT 5
;

-- 6.Show Employees' first name and last name
-- together with their supervisor's first name and last name
-- Sort the result by employee last name

SELECT
	a.FirstName as Employee_FirstName,
    a.LastName as Employee_LastName,
    b.FirstName as Supervisor_FirstName,
    b.LastName as Supervisor_LastName

FROM Employee a
	 LEFT JOIN Employee b
	 ON a.ReportsTo = b.EmployeeId

ORDER BY Employee_LastName asc    
;

-- 7.Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
--  together with the average price per track

SELECT
	a.Title as Album_Title,
	sum(b.UnitPrice) as Total_Album_Price,
	avg(b.UnitPrice) as Average_Track_Price

FROM Album a
		LEFT JOIN Track b
		ON a.AlbumId = b.AlbumId
GROUP BY Album_Title 
ORDER BY Total_Album_Price DESC
LIMIT 5
;

-- 8. Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
-- but only if the average price per track is above 1

SELECT 
	c.Album_title as Album_title,
    c.Total_Album_Price as Total_Album_Price,
    c.Average_Track_Price as Average_Track_Price

FROM
    (SELECT
		a.Title as Album_Title,
		sum(b.UnitPrice) as Total_Album_Price,
		avg(b.UnitPrice) as Average_Track_Price
	FROM Album a
		LEFT JOIN Track b
		ON a.AlbumId = b.AlbumId
	GROUP BY Album_Title) c

WHERE Average_Track_Price > 1
ORDER BY Total_Album_Price DESC
LIMIT 5
;

-- 9.Show the album Id and number of different genres
-- for those albums with more than one genre
-- (tracks contained in an album must be from at least two different genres)
-- Show the result sorted by the number of different genres from the most to the least eclectic 

SELECT

	a.AlbumId as AlbumId,
    a.Number_of_Genres as Number_of_Genres

FROM
	(SELECT
		b.AlbumId as AlbumId,
		count(distinct b.GenreID) as Number_of_Genres
	FROM 
		(SELECT

			c.AlbumId as AlbumId,
			d.Name as Track_Name,
			e.Name as Genre_Type,
			e.GenreId as GenreID
		
        FROM
			Album c
			LEFT JOIN Track d
			ON c.AlbumId = d.AlbumId
			LEFT JOIN Genre e
			ON d.GenreId = e.GenreId

		ORDER BY AlbumId) b

	GROUP BY AlbumId) a

WHERE Number_of_Genres >= 2
ORDER BY Number_of_Genres desc
;

-- 10.Show the total number of albums that you get from the previous result (hint: use a nested query)

SELECT count(f.AlbumId)

FROM
	
    (SELECT

	a.AlbumId as AlbumId,
    a.Number_of_Genres as Number_of_Genres

		FROM
		(SELECT
			b.AlbumId as AlbumId,
			count(distinct b.GenreID) as Number_of_Genres
		FROM 
			(SELECT

				c.AlbumId as AlbumId,
				d.Name as Track_Name,
				e.Name as Genre_Type,
				e.GenreId as GenreID
		
			FROM
				Album c
				LEFT JOIN Track d
				ON c.AlbumId = d.AlbumId
				LEFT JOIN Genre e
				ON d.GenreId = e.GenreId

			ORDER BY AlbumId) b

		GROUP BY AlbumId) a

	WHERE Number_of_Genres >= 2
	ORDER BY Number_of_Genres desc) f
;

-- 11.Show the number of tracks that were ever in some invoice

SELECT count(DISTINCT TrackId) FROM InvoiceLine;

-- 12.Show the Customer id and total amount of money billed to the five best customers 
-- (Those with the highest cumulated billed imports)

SELECT
 
	a.CustomerId as CustomerId,
    sum(a.Total) as Total_Paid

FROM Invoice a
GROUP BY 1
ORDER BY 2 desc
LIMIT 5;


-- 13.Add the customer's first name and last name to the previous result
-- (hint:use a nested query)

SELECT
 
	a.CustomerId as CustomerId,
    sum(a.Total) as Total_Paid,
	b.FirstName as Customer_FirstName,
    b.LastName as Customer_LastName

FROM Invoice a
	 left join Customer b
     on a.CustomerId = b.CustomerId

GROUP BY 1
ORDER BY 2 desc
LIMIT 5;

-- 14.Check that the total amount of money in each invoice
-- is equal to the sum of unit price x quantity
-- of its invoice lines.

SELECT

	sum(CASE WHEN c.Total_amount_invoiced!=c.Total_calculated_amount THEN 1 ELSE 0 END) AS Mismatched_Invoices

FROM

	(SELECT
		a.InvoiceId as InvoiceId,
		a.Total as Total_amount_invoiced,
		sum(b.UnitPrice * b.Quantity) as Total_calculated_amount

	FROM

		Invoice a
		LEFT JOIN InvoiceLine b
		ON a.InvoiceId = b.InvoiceId

	GROUP BY 1) c
;

-- 15.We are interested in those employees whose customers have generated 
-- the highest amount of invoices 
-- Show first_name, last_name, and total amount generated 

SELECT
 
	c.firstname as SupportRep_FirstName,
    c.lastname as SupportRep_LastName,
    sum(a.Total) as Total_Sold

FROM Invoice a
	 LEFT JOIN Customer b
     on a.CustomerId = b.CustomerId
		LEFT JOIN Employee C
			on b.SupportRepId = c.EmployeeId

GROUP BY 2
ORDER BY 3 desc
;

-- 16.Show the following values: Average expense per customer, average expense per invoice, 
-- and average invoices per customer.
-- Consider just active customers (customers that generated at least one invoice)

SELECT

	avg(b.Total_spent_by_customer) as Avg_spent_by_customer,
    avg(b.Average_invoice_by_customer) as Avg_invoice_amount,
    avg(b.Number_invoices) as Avg_invoices_per_customer

FROM

	(SELECT

		a.CustomerId as CustomerId,
		count(distinct a.InvoiceId) as Number_invoices,
		a.Total as Total_spent_by_customer,
		(a.Total / count(distinct a.InvoiceId)) as Average_invoice_by_customer

	FROM

		Invoice a
    
	GROUP BY 1) b
;

-- 17.We want to know the number of customers that are above the average expense level per customer. (how many?)

SELECT

	sum(CASE WHEN b.Total_spent_by_customer > 3.4 THEN 1 ELSE 0 END) as Avg_spent_by_customer

FROM

	(SELECT

		a.CustomerId as CustomerId,
		count(distinct a.InvoiceId) as Number_invoices,
		a.Total as Total_spent_by_customer,
		(a.Total / count(distinct a.InvoiceId)) as Average_invoice_by_customer

	FROM

		Invoice a
    
	GROUP BY 1) b
;



-- 18.We want to know who is the most purchased artist (considering the number of purchased tracks), 
-- who is the most profitable artist (considering the total amount of money generated).
-- and who is the most listened artist (considering purchased song minutes).
-- Show the results in 3 rows in the following format: 
-- ArtistName, Concept('Total Quantity','Total Amount','Total Time (in seconds)'), Value
-- (hint:use the UNION statement)

SELECT

	a.name as Artist_name,
    ('Total Quantity') as Concept,
	sum(d.Quantity) as Value
 
FROM

	Artist a
    LEFT JOIN Album b
	ON a.ArtistId = b.ArtistId
		LEFT JOIN Track c
        ON b.AlbumId = c.AlbumId
			LEFT JOIN InvoiceLine d
            on c.TrackId = d.TrackId

UNION

SELECT

	a.name as Artist_name,
    ('Total Amount') as Concept,
	sum(d.UnitPrice * d.Quantity) as Value

FROM

	Artist a
    LEFT JOIN Album b
	ON a.ArtistId = b.ArtistId
		LEFT JOIN Track c
        ON b.AlbumId = c.AlbumId
			LEFT JOIN InvoiceLine d
            on c.TrackId = d.TrackId 

UNION

SELECT

	a.name as Artist_name,
    ('Total Time (in seconds)') as Concept,
	sum(c.Milliseconds / 1000) as Value

FROM

	Artist a
    LEFT JOIN Album b
	ON a.ArtistId = b.ArtistId
		LEFT JOIN Track c
        ON b.AlbumId = c.AlbumId
;

-----------------------------------------------------------
-- end of code ------