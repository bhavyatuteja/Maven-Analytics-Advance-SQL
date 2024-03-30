create temporary table session_level_made_it_flags
select website_session_id,
max(products_page) as product_made_it,
max(to_mrfuzzy) as mrfuzzy_made_it,
max(to_cart) as cart_made_it,
max(to_shipping) as shipping_made_it,
max(to_billing) as billing_made_it,
max(thankyou_page) as thankyou_made_it
from(
select 
ws.website_session_id,wp.pageview_url,wp.created_at,
case when pageview_url='/products' then 1 else 0 end as products_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as to_mrfuzzy,
case when pageview_url='/cart' then 1 else 0 end as to_cart,
case when pageview_url='/shipping' then 1 else 0 end as to_shipping,
case when pageview_url='/billing' then 1 else 0 end as to_billing,
case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions ws left join website_pageviews wp
on ws.website_session_id=wp.website_session_id
where ws.created_at<'2012-09-05' and ws.created_at>'2012-08-05'
and utm_source='gsearch'
and utm_campaign='nonbrand'
order by website_session_id,
ws.created_at
) as preview
group by website_session_id;

select * from session_level_made_it_flags;

select count( distinct website_session_id) as sessions,
count(distinct case when product_made_it=1 then website_session_id else null end) as to_products,
count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end) as to_mrfuzzy,
count(distinct case when cart_made_it=1 then website_session_id else null end) as cart_made,
count(distinct case when shipping_made_it=1 then website_session_id else null end) as shipping_made,
count(distinct case when billing_made_it=1 then website_session_id else null end) as billing_made,
count(distinct case when thankyou_made_it=1 then website_session_id else null end) as thankyou_made
from session_level_made_it_flags;

select count( distinct website_session_id) as sessions,
count(distinct case when product_made_it=1 then website_session_id else null end)/count( distinct website_session_id) as to_products_rt,
count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end)/count(distinct case when product_made_it=1 then website_session_id else null end) as to_mrfuzzy_rt,
count(distinct case when cart_made_it=1 then website_session_id else null end)/count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end)as cart_made_rt,
count(distinct case when shipping_made_it=1 then website_session_id else null end)/count(distinct case when cart_made_it=1 then website_session_id else null end)as shipping_made_rt,
count(distinct case when billing_made_it=1 then website_session_id else null end)/count(distinct case when shipping_made_it=1 then website_session_id else null end) as billing_made_rt,
count(distinct case when thankyou_made_it=1 then website_session_id else null end)/count(distinct case when billing_made_it	=1 then website_session_id else null end)as thankyou_made_rt
from session_level_made_it_flags;