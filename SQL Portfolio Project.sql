--set1

--senior most employee in job title
SELECT * FROM Employee
ORDER BY levels desc 
LIMIT 1

--Countries having most invoices
SELECT COUNT(*) AS total_billing_countries, billing_country FROM invoice
GROUP BY billing_country
ORDER BY total_billing_countries DESC

--What are top 3 values of total invoice
select total from invoice
ORDER BY total DESC
LIMIT 3

--write a query that returns on city that has the highest sum of invoice totals.
--Retuen both the city name and sum of all invoice totals
select sum(total) as invoice_total, billing_city from invoice
group by billing_city
order by invoice_total desc

--write a query that returns the person who has spent the most money
select a.customer_id, a.first_name, a.last_name, SUM(b.total) as total from customer as a
join invoice as b
on a.customer_id = b.customer_id
group by a.customer_id
order by total desc
limit 1

--set2

--write a query to return the email, first name, last name and genre of all ROCK music listeners.
--return your list a.email, a.first_name, a.last_name, b.name as name from customer as a
select distinct email, first_name, last_name from customer as a
join invoice as b 
on a.customer_id = b.customer_id
join invoice_line as c 
on b.invoice_id = c.invoice_id
where track_id in(
    select track_id from track
    join genre 
	on track.genre_id = genre.genre_id
    where genre.name like 'Rock')
order by email;

--write a query that returns the artist name and total track count of the top 10 ROCK bands
select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs from track
join album
on album.album_id = track.album_id
join artist
on artist.artist_id = album.artist_id
join genre 
on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;

--return all the track names that have song length longer than the average song length.
--return the name and milliseconds for each track. order by the song length with the longest songs listed first
select name, milliseconds from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc


--set 3

--find how much amount spent by each customer on artists
--write a query to return customer name, artist name and total spent
with best_selling_artist as (
    select d.artist_id as artist_id, d.name as artist_name, sum(a.unit_price*a.quantity) as total_sales from invoice_line as a
    join track as b on a.track_id = b.track_id
    join album as c on b.album_id = c.album_id
    join artist as d on c.artist_id = d.artist_id
    group by 1
    order by 3 desc
    limit 1
)
select cus.customer_id, cus.first_name, cus.last_name, bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spent from invoice as i
join customer as cus on cus.customer_id = i.customer_id
join invoice_line as il on il.invoice_id = i.invoice_id
join track as t on t.track_id = il.track_id
join album as alb on alb.album_id = t.album_id
join best_selling_artist as bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc;

--we want to find out the most popular music genre for each country
--we determine the most popular genre as the genre with the highest amount of purchases

with popular_genre as
(
     select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
     row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as RowNo from invoice_line
     join invoice on invoice.invoice_id = invoice_line.invoice_id
     join customer on customer.customer_id = invoice.customer_id
     join track on track.track_id = invoice_line.track_id
     join genre on genre.genre_id = track.genre_id
     group by 2,3,4
     order by 2 asc, 1 desc
)
select * from popular_genre where RowNo <= 1