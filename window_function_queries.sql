/* Add row numbers to the placings table */
select
	"year"
	,host_country
	,winner
	,total_goals
	,row_number() over() as row_num
from world_cup_placings;

/* Using SUM() within our window function */
select
	"year"
	,host_country
	,winner
	,total_goals
	,sum(total_goals) over() as all_goals
from world_cup_placings;

/* Computing the average number of goals */
select
	"year"
	,host_country
	,winner
	,total_goals
	,round(avg(total_goals) over(), 0) as mean_goals
from world_cup_placings;

/* Compute z-score for total goals scored */
select
	"year"
	,host_country
	,winner
	,total_goals
	,round(avg(total_goals) over(), 0) as mean_goals
	,round((total_goals - avg(total_goals) over()) / stddev(total_goals) over(), 2) as z_score
from world_cup_placings;

/* Add row numbers to each partition */
select
	"year"
	,host_country
	,winner
	,total_goals
	,row_number() over( partition by winner ) as row_num
from world_cup_placings;

/* Adding more window functions to the SELECT list */
select
	"year"
	,host_country
	,winner
	,row_number() over( partition by winner ) as row_num
	,total_goals
	,sum(total_goals) over( partition by winner ) as all_goals
	,total_attendance
	,max(total_attendance) over( partition by winner ) as max_attednance
from world_cup_placings;

/* Same as above, but now using the WINDOW clause */
select
	"year"
	,host_country
	,winner
	,row_number() over w as row_num
	,total_goals
	,sum(total_goals) over w as all_goals
	,total_attendance
	,max(total_attendance) over w as max_attednance
from world_cup_placings
window w as ( partition by winner )
;

/* Comparing ROW_NUMBER and RANK using ORDER BY clause */
select
	"year"
	,host_country
	,winner
	,total_goals
	,row_number() over( order by total_goals desc ) as row_num
	,rank() over( order by total_goals desc ) as row_rank
from world_cup_placings;

/* Rank winning teams by competition year to find most recent win */
select
	"year"
	,host_country
	,winner
	,rank() over( partition by winner order by "year" desc) as row_rank
from world_cup_placings
;

/* Filter only rows that have a rank of 1 */
select
	"year"
	,winner
from (
	select
		"year"
		,host_country
		,winner
		,rank() over( partition by winner order by "year" desc) as row_rank
	from world_cup_placings
) as subq
where row_rank = 1
;
