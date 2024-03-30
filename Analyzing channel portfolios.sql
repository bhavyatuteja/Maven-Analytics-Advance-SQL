select 
min(date(created_at)),
count(distinct website_session_id) as total_sessions,
count(case when utm_source='gsearch'then website_session_id else null end) as gsearch_sessions,
count(case when utm_source='bsearch'then website_session_id else null end) as bsearch_sessions
from website_sessions 
where created_at<'2012-11-30'
and created_at>'2012-08-22'
and utm_campaign='nonbrand'
group by yearweek(created_at);

select 
ws.device_type,
ws.utm_source,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders,
count(distinct o.order_id)/count(distinct ws.website_session_id) as conv_rate
from website_sessions ws left join orders o on ws.website_session_id=o.website_session_id
where ws.created_at<'2012-09-19'
and ws.created_at>'2012-08-22'
and ws.utm_campaign='nonbrand'
group by 1,2;

select 
min(date(created_at)) as week_start_date,
count(distinct website_session_id) as total_sessions,
count(case when utm_source='gsearch' and device_type='desktop'then website_session_id else null end) as g_dtop_sessions,
count(case when utm_source='bsearch'and device_type='desktop'then website_session_id else null end) as b_dtop_sessions,
count(case when utm_source='bsearch'and device_type='desktop'then website_session_id else null end)/count(case when utm_source='gsearch'and device_type='desktop'then website_session_id else null end) as b_pct_of_g_dtop,
count(case when utm_source='gsearch' and device_type='mobile' then website_session_id else null end) as g_mob_session,
count(case when utm_source='bsearch' and device_type='mobile' then website_session_id else null end) as b_mob_session,
count(case when utm_source='bsearch' and device_type='mobile' then website_session_id else null end)/count(case when utm_source='gsearch' and device_type='mobile' then website_session_id else null end) as b_pct_of_g_mob
from website_sessions 
where created_at>'2012-11-04'
and created_at<'2012-12-22'
and utm_campaign='nonbrand'
group by yearweek(created_at);

select * from website_sessions;