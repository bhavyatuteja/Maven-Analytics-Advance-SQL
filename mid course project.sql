-- Question 1
select  month(ws.created_at) as month
,year(ws.created_at) as year,
 count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders
from website_sessions ws left join orders o 
on ws.website_session_id=o.website_session_id
where utm_source='gsearch' and 
ws.created_at<'2012-11-27'
group by  month(ws.created_at),
year(ws.created_at)
order by 
year(ws.created_at), month(ws.created_at);

-- Question 2
select month(ws.created_at) as month
,year(ws.created_at) as year,
 count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders,
count(distinct case when utm_campaign='brand' then ws.website_session_id else null end) as Brand_sessions,
count(distinct case when utm_campaign='brand' then o.order_id else null end) as Brand_orders,
count(distinct case when utm_campaign='nonbrand' then ws.website_session_id else null end) as NonBrand_sessions,
count(distinct case when utm_campaign='nonbrand' then o.order_id else null end) as NonBrand_orders
from website_sessions ws left join orders o 
on ws.website_session_id=o.website_session_id
where utm_source='gsearch' and 
ws.created_at<'2012-11-27'
group by 
month(ws.created_at),
year(ws.created_at)
order by 
year(ws.created_at), month(ws.created_at);

-- question 3
select month(ws.created_at) as month
,year(ws.created_at) as year,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders,
count(distinct case when device_type='mobile' then ws.website_session_id else null end) as Mobile_sessions,
count(distinct case when device_type='mobile' then o.order_id else null end) as Mobile_orders,
count(distinct case when device_type='desktop' then ws.website_session_id else null end) as Desktop_sessions,
count(distinct case when device_type='desktop' then o.order_id else null end) as Desktop_orders
from website_sessions ws left join orders o 
on ws.website_session_id=o.website_session_id
where utm_source='gsearch' and 
ws.created_at<'2012-11-27' and 
utm_campaign='nonbrand'
group by 
month(ws.created_at),
year(ws.created_at)
order by 
year(ws.created_at), month(ws.created_at);

-- Question 4

select utm_source,count(*) from website_sessions group by utm_source;

select month(ws.created_at) as month
,year(ws.created_at) as year,
count(distinct ws.website_session_id) as sessions,
count(distinct case when utm_source='gsearch' then ws.website_session_id else null end) as gsearch_sessions,
count(distinct case when utm_source='bsearch' then ws.website_session_id else null end) as bsearch_sessions,
count(distinct case when utm_source='socialbook' then ws.website_session_id else null end) as socialbook_sessions,
count(distinct case when utm_source is null then ws.website_session_id else null end) as null_Sessions
from website_sessions ws left join orders o 
on ws.website_session_id=o.website_session_id
where ws.created_at<'2012-11-27' 
group by 
month(ws.created_at),
year(ws.created_at)
order by 
year(ws.created_at), month(ws.created_at);

-- question 5

select 
month(ws.created_at) as month,
year(ws.created_at) as year,
count(distinct ws.website_session_id) as sessions, 
count(distinct o.order_id) as orders,
count(distinct o.order_id)/count(distinct ws.website_session_id) as rt
from website_sessions ws left join orders o 
on ws.website_session_id=o.website_session_id
where ws.created_at<'2012-11-27'
group by 1,2
order by 2,1
limit 8;

-- question 6

select * from website_sessions;

create temporary table First_pageview
select wp.website_session_id,
min(wp.website_pageview_id) as min_pageview_id
from website_pageviews wp left join website_sessions ws 
on wp.website_session_id=ws.website_session_id
where ws.created_at<'2012-07-28' and ws.created_at>'2012-06-19'
and wp.website_pageview_id>=23504 
and utm_source='gsearch'
and utm_campaign='nonbrand'
group by 1
order by ws.created_at;

select * from First_pageview;

create temporary table pageview_landing
select 
fp.website_session_id,
ws.pageview_url as landing_page
from First_pageview fp left join website_pageviews ws
on ws.website_session_id=fp.website_session_id
where pageview_url in('/home','/lander-1');

select * from pageview_landing;


select distinct pageview_url from website_pageviews;
