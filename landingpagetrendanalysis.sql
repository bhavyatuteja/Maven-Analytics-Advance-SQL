select 
created_at as first_created_at,
website_pageview_id as first_pageview_id
from website_pageviews
where pageview_url='/lander-1' and created_at='2012-06-19 00:35:54' ;

select *,week(created_at) from website_pageviews 
where created_at>='2012-06-01'
and pageview_url in ('/lander-1','/home');

select * from website_pageviews;

create temporary table FirstPageViewtable
select ws.website_session_id,
min(wp.website_pageview_id) as min_pageview_id,
count(wp.website_pageview_id) as count_pageviews
from website_sessions ws left join website_pageviews wp 
on ws.website_session_id=wp.website_session_id
where ws.created_at>'2012-06-01' 
and ws.created_at<'2012-08-31' 
and utm_source='gsearch'
and utm_campaign='nonbrand'
group by ws.website_session_id;

select * from FirstPageViewtable; 

create temporary table FstLndPgEchSsn
select 
fp.website_session_id,
fp.count_pageviews,
fp.min_pageview_id,
wp.pageview_url as landing_page,
wp.created_at as session_created_at
from FirstPageViewtable fp left join website_pageviews wp
on wp.website_pageview_id=fp.min_pageview_id
where wp.pageview_url in ( '/home','/lander-1');

select * from FstLndPgEchSsn;

-- create temporary table bounced_sessions
select 
fles.website_session_id,
fles.landing_page,
count(wp.website_pageview_id) as count_of_page_viewed
from FstLndPgEchSsn fles left join website_pageviews wp 
on fles.website_session_id=wp.website_session_id
group by 
fles.website_session_id,
fles.landing_page
having count(wp.website_pageview_id)=1;

select * from bounced_sessions;

select 
fles.landing_page,
count(distinct fles.website_session_id) as sessions,
count(distinct bs.website_session_id) as bcd_wbst_sesn_ID,
count(distinct bs.website_session_id)/count(distinct fles.website_session_id) as bounced_rate
from FstLndPgEchSsn fles left join bounced_sessions bs 
on fles.website_session_id=bs.website_session_id
group by fles.landing_page;
