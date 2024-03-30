select * from website_pageviews;

create temporary table FirstPageViewtable
select website_session_id,min(website_pageview_id) as FirstPageView
from website_pageviews
where created_at<'2012-06-14'
group by website_session_id;

select * from FirstPageViewtable; 

create temporary table FstLndPgEchSsn
select 
fp.website_session_id,wp.pageview_url
from FirstPageViewtable fp left join website_pageviews wp
on wp.website_pageview_id=fp.FirstPageview
where wp.pageview_url='/home';

select * from FstLndPgEchSsn;

create temporary table bounced_sessions
select 
fles.website_session_id,
fles.pageview_url,
count(wp.website_pageview_id) as count_of_page_viewed
from FstLndPgEchSsn fles left join website_pageviews wp 
on fles.website_session_id=wp.website_session_id
group by 
fles.website_session_id,
fles.pageview_url
having count(wp.website_pageview_id)=1;

select * from bounced_sessions;

select 
count(distinct fles.website_session_id) as sessions,
count(distinct bs.website_session_id) as bcd_wbst_sesn_ID,
count(distinct bs.website_session_id)/count(distinct fles.website_session_id) as bounced_rate
from FstLndPgEchSsn fles left join bounced_sessions bs 
on fles.website_session_id=bs.website_session_id
order by fles.website_session_id