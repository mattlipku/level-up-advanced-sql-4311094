select firstName, lastName, title
from employee
limit 5;

select sql
from sqlite_schema
where name='employee';

select e1.firstName, e1.lastName, e2.firstName as mfirstname, e2.lastName as mlastname
from employee e1, employee e2
where e1.managerId=e2.employeeId;

select emp.firstName, emp.lastName, emp.employeeId, s.salesAmount
from employee emp
left join
sales s
on emp.employeeId = s.employeeId
where emp.title = 'Sales Person'
and s.salesamount is null;

select salesid, firstName, lastName, email, salesamount, soldDate
from sales
left JOIN
customer
on sales.customerId = customer.customerId
UNION
select salesid, firstName, lastName, email, salesamount, soldDate
from customer
left JOIN
sales 
on sales.customerId = customer.customerId
where salesid is null;

select firstname, lastName, count(*)
from sales s
left join employee emp
on s.employeeId = emp.employeeid
group by s.employeeid
order by count(*) desc;

SELECT firstName, lastName, max(salesamount), min(salesAmount)
from sales s
left JOIN
employee emp
on s.employeeId = emp.employeeId
where strftime('%Y',s.soldDate) = '2022'
group by s.employeeid;


select firstName, lastName, count(*)
from sales s
left JOIN
employee emp
on s.employeeId = emp.employeeId
where strftime('%Y',s.soldDate) = '2022'
group by s.employeeId
having count(*)>5
order by count(*) desc;


SELECT strftime('%Y',s.soldDate) as year, format('$%.2f',sum(salesAmount))
from sales s
group by strftime('%Y',s.soldDate);

with cte as ()

SELECT s.employeeId, firstName, lastName, strftime('%m',soldDate) as month, 
sum(salesAmount)
from sales s
left join 
employee emp
on s.employeeId = emp.employeeId
where strftime('%Y',s.solddate) = '2021'
group by s.employeeId, strftime('%m',soldDate);

select s.employeeId, firstName, lastName,
sum(case when strftime('%m',s.solddate) = '01' then salesAmount end) as Jansales,
sum(case when strftime('%m',s.solddate) = '02' then salesAmount end) as Febsales,
sum(case when strftime('%m',s.solddate) = '03' then salesAmount end) as Marsales,
sum(case when strftime('%m',s.solddate) = '04' then salesAmount end) as Aprsales,
sum(case when strftime('%m',s.solddate) = '05' then salesAmount end) as Maysales,
sum(case when strftime('%m',s.solddate) = '06' then salesAmount end) as Junsales,
sum(case when strftime('%m',s.solddate) = '07' then salesAmount end) as Julsales,
sum(case when strftime('%m',s.solddate) = '08' then salesAmount end) as Augsales,
sum(case when strftime('%m',s.solddate) = '09' then salesAmount end) as Sepsales,
sum(case when strftime('%m',s.solddate) = '10' then salesAmount end) as Octsales,
sum(case when strftime('%m',s.solddate) = '11' then salesAmount end) as Novsales,
sum(case when strftime('%m',s.solddate) = '12' then salesAmount end) as Decsales
from sales s
left join 
employee emp
on s.employeeId = emp.employeeId
where strftime('%Y',s.solddate) = '2021'
group by s.employeeId
order by s.employeeId;


select *
from sales s 
left join inventory inv 
on s.inventoryId = inv.inventoryId
left join model m 
on inv.modelid = m.modelid
where EngineType = 'Electric';

select firstName, lastName, m.model, count(model),
rank() over(partition by s.employeeId
            order by count(model) desc) as Rank
from sales s 
left join employee emp 
on s.employeeId = emp.employeeId
left join inventory inv 
on s.inventoryId = inv.inventoryId
left join model m 
on inv.modelid = m.modelid
group by s.employeeId,m.model


select strftime('%Y',s.soldDate) as soldyear,
  strftime('%m',s.soldDate) as soldmonth,
  sum(salesAmount) as monthTotal,
  sum(sum(salesAmount)) over
    (PARTITION by strftime('%Y',s.soldDate)
    order by strftime('%Y',s.soldDate), strftime('%m',s.soldDate)) as runningYearTotal
from sales s
group by strftime('%Y',s.soldDate), strftime('%m',s.soldDate)

with cte_sales as(
select strftime('%Y',s.soldDate) as year, strftime('%m',s.soldDate) as month,
count(*) as thisMonth
from sales s
group by strftime('%Y',s.soldDate), strftime('%m',s.soldDate)
order by strftime('%Y',s.soldDate), strftime('%m',s.soldDate)
)
select year, month, thisMonth,
lag(thisMonth,1,0) over (order by year, month) as lastMonth
from cte_sales
order by year, month;

