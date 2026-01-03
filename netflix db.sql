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
	order by 3 desc;
	

