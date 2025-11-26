select * from supply_chain sc;

with 
timeliness_analysis as(
-- Calculating key time metrics for all shipments to assess punctuality.
	select
		logistics_partner,
		order_placed_date,
		expected_delivery_date,
		actual_delivery_date,
		shipment_status,
		-- Calculating the actual transit time in days.
		datediff(actual_delivery_date, order_placed_date) as real_delivery_time,
		-- Calculating the planned transit time in days.
		datediff(expected_delivery_date, order_placed_date ) as expected_delivety_time
	from supply_chain sc),
delivery_reliability as(
	select
		-- Calculating the overall On-Time Delivery (OTD) Rate for the entire dataset.
		(select count(*) from timeliness_analysis where actual_delivery_date <= expected_delivery_date)
		/(select count(*) from timeliness_analysis) as delivery_reliability
	from timeliness_analysis
limit 1),
delayed_delivery as(
	select
		-- Calculating the overall Delayed Delivery Rate.
		(select count(*) from timeliness_analysis where actual_delivery_date > expected_delivery_date) 
		/(select count(*) from timeliness_analysis) as delayed_delivery
	from timeliness_analysis
	limit 1),
	-- The following CTEs (all_delivery_by_operator, delivered_by_operator, delayed_by_operator)
	-- are used to prepare granular counts for OTD calculation per logistics partner.
chart_data as(
	-- Comparing dalivered to delayed ratio
	select * from delivery_reliability 
	union 
	select * from delayed_delivery),
all_delivery_by_operator  as(
	-- Total number of shipments handled by each logistics partner.
	select 
		logistics_partner,
		count(*) as number_of_all_delivery 
	from timeliness_analysis
	group by 1),
delivered_by_operator as(
	-- Counting of on-time shipments per partner (actual delivery date <= expected delivery date).
	select 
		logistics_partner,
		count(*) as number_of_in_time_delivery 
	from timeliness_analysis
	where actual_delivery_date <= expected_delivery_date
	group by 1),
delayed_by_operator as(
	-- Counting of delayed shipments per partner (actual delivery date > expected delivery date).
	select 
		logistics_partner,
		count(*) as number_of_delyed_delivery
	from timeliness_analysis
	where actual_delivery_date > expected_delivery_date
	group by 1),
logistic_partner_delivery_stats as(
	-- Final preparation of partner performance metrics (aggregating counts and calculating OTD %).
	select 
		a1.logistics_partner,
		a1.number_of_all_delivery,
		d1.number_of_in_time_delivery,
		d2.number_of_delyed_delivery,
		round((d1.number_of_in_time_delivery/a1.number_of_all_delivery),2) as percent_of_in_time_delivery
	from all_delivery_by_operator a1
	left join delivered_by_operator d1 on a1.logistics_partner = d1.logistics_partner
	left join delayed_by_operator d2 on a1.logistics_partner  = d2.logistics_partner)
select
	-- Main Query: Comprehensive performance comparison of logistics partners.
	lp.logistics_partner,
	lp.percent_of_in_time_delivery,
	-- Calculating the average supplier rating associated with this partner's shipments.
	round(avg(sc.supplier_rating),2) as average_rating,
	-- Calculating the average delay time in days (positive value means delay, negative means early).
	round(avg(ta.real_delivery_time - ta.expected_delivety_time),2) as average_delay_prc_of_day
	from logistic_partner_delivery_stats lp
left join supply_chain sc on sc.logistics_partner = lp.logistics_partner
left join timeliness_analysis ta on ta.logistics_partner  = lp.logistics_partner 
group by 1,2;


select
	-- Analysis of shipment status and volume grouped by logistics partner and weather condition.
	sc.logistics_partner,
	sc.shipment_status, 
	sc.weather_condition, 
	count(*) as shipment_count
from supply_chain sc 
group by 1,2,3;

select
	-- Time series analysis: Counting the volume of orders/shipments over time.
    -- Casting the timestamp to date for daily aggregation.
	cast(sc.timestamp as date) as order_date,
	sc.logistics_partner,
	sc.shipment_status,
	count(*) as daily_order_volume
from supply_chain sc
group by 1,2,3;




