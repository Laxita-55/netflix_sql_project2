-----netflix project
drop table if exists netflix;
create table netflix
(show_id varchar(6),	
type varchar(10),
title varchar(150),
director varchar(208),
casts	varchar(1000),
country varchar(150), 
date_added	varchar(50),
release_year int,
rating	varchar(10),
duration varchar(15),
listed_in varchar (100),
description varchar(250)
);
select* from netflix;
commit

select count(*) as total_content
from netflix;

select
     distinct type
	 from netflix;


----business problems

---1 count the number of movies and tv shows we have

   select 
   type,
   count(*) as total_content
   from netflix
   group by type;
   
---2 find the most common ratings for movies and tv shows 
     
    select
	type,
	rating,
	count(*),
	rank() over(partition by type order by count(*))as ranking
	from netflix
	group by type,rating
	order by type, 3 desc;

----3 list all movies released in a specific year (eg.2020)
     ---- filter 2020
	 ---movies
     select* from netflix
	 where
	      type = 'Movie'
		  and
           release_year=2020

----4. find the top 5 countries wit the most content on netflix
   SELECT          
	     UNNEST(string_to_array(country,','))as new_country,
		    COUNT(show_id)as total_content
	 from netflix
GROUP by 1
ORDER BY 2 desc
limit 5

----5 identify the longest movie?
     select * from netflix
      where 
	    type='Movie'
		and 
		duration = (select max(duration) from netflix)

-------6 find the last five years
        select
		*
		from netflix
		where 
		to_Date(date_added,'Month dd, yyy')>= current_date-interval'5years'
		
-------7find all the movies/tv shows by director called Rajiv chilaka
        select* from netflix
		where director ilike'%Rajiv Chilaka%'
		
--------8 list all the tv shows which has more then 5 seasons
         
		-----  split_part (duration ,' ',1)aa seasions
		  
		SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND split_part(duration, ' ', 1)::INT > 5;

  ----9 count the number of content items in each genre
       select
	        unnest(string_to_array(listed_in,',')) as genre,
	        count(show_id)as total_content
			from netflix
			group by 1
			  
--------10. find each year and the average number of content release by india on netflix,
----------return top 5 year with higesht avg content relase:
		Select 
		     extract(year from to_date(date_added,'Month DD,YYYY'))as year,
			 count(*) as yearly_content,
			 round(
			 count(*)*100.0/
			 (select count(*) from netflix where country='India') ,2)as avg_content_per_year
			 from netflix
			 where country= 'India'
			 group by 1
	
 ------11 list all the movies that are documentry
            select * from netflix
			 where
			 listed_in ilike'%documentaries%'
--------12 find all the content without a director
           select *from netflix
		   where
		        director is null
------13 find how many movies actor'salmon khan'appeared in last 10 years
       SELECT *
FROM netflix
WHERE "casts" ILIKE '%Salman Khan%'
and 
release_year > extract(year from current_date)-10
-----14 find the to 10 actors who appeared in the highest number of movies produced in india.
      
     select
	 unnest(string_to_array(casts,','))as actors,
	 count(*) as total_content
	 from netflix
	 where country ilike'%india%'
	 group by 1
	 order by 2 desc
	 limit 10
	 
------15 categorise the content based on the presence of the keywords 'kill'and 'violence'
-----in the description field .label content containing these keywords as'bad'and all other,
------WITH new_table AS (
    WITH new_table AS (
    SELECT 
        *,
        CASE
            WHEN description ILIKE '%kill%' 
              OR description ILIKE '%violence%' 
            THEN 'bad_content'
            ELSE 'good_content'
        END AS category
    FROM netflix
)
SELECT 
     category,
    COUNT(*) AS total_content
FROM new_table
GROUP BY 1;


