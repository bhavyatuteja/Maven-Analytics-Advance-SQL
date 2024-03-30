select 
year(ws.created_at) as yr,
month(ws.created_at) as mo,
count(ws.website_session_id) as sessions,
count(o.order_id) as orders
from website_sessions ws left join orders o 
on ws.website_session_id=o.website_session_id
group by 1,2;

select 
year(ws.created_at) as yr,
week(ws.created_at) as wk,
min(date(ws.created_at)) as wk_start,
count(ws.website_session_id) as sessions,
count(o.order_id) as orders
from website_sessions ws left join orders o 
on ws.website_session_id=o.website_session_id
where ws.created_at<'2013-01-01'
group by 1;


select 
hr,
round(avg(website_sessions),1) as avg_sessions,
round(avg(case when wkday=0 then website_sessions else null end ),1) as mon,
count(distinct case when wkday=1 then website_sessions else null end ) as tue,
count(distinct case when wkday=2 then website_sessions else null end ) as wed,
count(distinct case when wkday=3 then website_sessions else null end ) as thu,
count(distinct case when wkday=4 then website_sessions else null end ) as fri,
count(distinct case when wkday=5 then website_sessions else null end ) as sat,
count(distinct case when wkday=6 then website_sessions else null end ) as sun
from(
select hour(created_at) as hr,
weekday(created_at) as wkday,
count(distinct website_session_id) as website_sessions 
from website_sessions
where created_at between'2012-09-15' and '2012-11-15' 
group by 1,2
) as A
group by 1

