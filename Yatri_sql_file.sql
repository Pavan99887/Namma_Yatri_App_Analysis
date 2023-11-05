1 total number of trips 

select count(tripid) as total_trips from trip_details$
where end_ride=1

2 total number of drivers  

select count(distinct driverid) as total_drivers from trips$

3 total earnings
 
elect sum(fare) total_earnings from trips$

4 total Completed trips

 select count(*) completed_trips from trips$

5 total searches

 select sum(searches) searches from trip_details$

6 total searches which got estimate
 
  select sum(searches_got_estimate) got_fare_estimate from trip_details$

7 total searches for quotes

  select sum(searches_for_quotes) search_for_drivers from trip_details$

8 total searches which got quotes

  select sum(searches_got_quotes) got_drivers from trip_details$

9 total driver cancelled

  select (count(*)- sum(driver_not_cancelled)) as total_driver_cancelled from trip_details$

10 total otp entered

   select sum(otp_entered) as total_otp_entered from trip_details$

11 total end ride

  select sum(end_ride) total_end_ride from trip_details$

12 cancelled bookings by driver

  select count(*)-sum(driver_not_cancelled) cancelled_bookings_by_driver
  from trip_details$

13 cancelled bookings by customer
   
   select count(*)-sum(customer_not_cancelled) cancelled_bookingsbycustomer
   from trip_details$

14  average distance per trip
    select avg(distance) as average_distane_per_trip from trips$

15 average fare per trip

   select avg(fare) as average_distane_per_trip from trips$

16 distance travelled

   select sum(distance) total_dist_travelled from trips$

17 which is the most used payment method 


select top 1 method from payment$ p
inner join 
(
select faremethod  , count(faremethod) cnt from trips$
group by faremethod
)a
on
p.id=a.faremethod
order by cnt desc 

18 the highest payment was made through which instrument

select top 1* from trips$
order by fare desc 

19 which two locations had the most trips 

select top 2 loc_from,loc_to,count(tripid) total_trips,a.Assembly,b.Assembly from trips$ t
inner join assembly$ a
on a.ID=t.loc_from 
join assembly$ b 
on b.ID=t.loc_to
group by loc_from,loc_to,a.Assembly,b.Assembly
order by total_trips desc 

20 top 5 earning drivers

select * from 
(select *,DENSE_RANK() over(order by earning desc)  rnk from
(select driverid,sum(fare) earning from trips$
group by driverid
)a
)b
where rnk<6

21 which duration had more trips

select * from (
select *,DENSE_RANK() over(order by c desc) rnk from
(select duration,count(*) c from trips$
group by duration
)a
)b
where rnk=1

22 which driver , customer pair had more orders

select * from
 (select * , DENSE_RANK() over(order by bookings desc) rnk from
     (select driverid,custid,count(tripid) bookings from trips$
      group by driverid,custid 
     )a
 )b 
where rnk=1

23 search to estimate rate

select sum(searches) s,sum(searches_got_estimate) e , (sum(searches_got_estimate)/sum(searches))*100 from trip_details$

24 estimate to search for quote rates

select sum(searches_for_quotes)/sum(searches_got_estimate)*100 from trip_details$

25  quote acceptance rate
select sum(searches_got_quotes)/sum(searches_for_quotes)*100 from trip_details$

26  quote to booking rate

select sum(customer_not_cancelled)/sum(searches_got_quotes)*100 from trip_details$


27  booking cancellation rate

select (count(end_ride)-sum(end_ride))/count(end_ride) * 100 from trip_details$


28 coversion rate 

select sum(end_ride)/sum(searches)*100 as conversion_rate from trip_details$


29 which area got highest trips in which duration

select * from 
(select *,rank() over(partition by duration order by total_trips desc) rnk from
(select duration,loc_from,count(tripid) total_trips from trips$
group by loc_from,duration
)a
)b
where rnk=1
