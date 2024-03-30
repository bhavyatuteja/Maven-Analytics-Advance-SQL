select urls,
count(distinct sessions),
count(distinct orders),
(count(distinct orders)/count(distinct sessions)*100) as rtf
from(
select wp.website_session_id as sessions,
wp.pageview_url as urls,
o.order_id as orders
from website_pageviews wp left join  orders o
on o.website_session_id=wp.website_session_id
where pageview_url in ('/billing-2','/billing')
and website_pageview_id>=53550
and wp.created_at<'2012-11-10'
) as preview
group by urls;



select distinct pageview_url from  website_pageviews ;




53550