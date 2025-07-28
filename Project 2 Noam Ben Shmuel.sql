--EX. 1

select vvv.year, vvv.IncomePerYear, vvv.NumberOfDistinctMonths, vvv.YearlyLinearIncome,
FORMAT((((cast(vvv.YearlyLinearIncome as FLOAT)*100)/
LAG(cast(vvv.YearlyLinearIncome as FLOAT))over (order by vvv.year))-100),'#0.00') as GrowthRate
from (
select year(o.orderdate) year, sum(sil.ExtendedPrice-sil.TaxAmount) IncomePerYear,
count(distinct month(o.OrderDate)) NumberOfDistinctMonths, 
format((sum(sil.ExtendedPrice-sil.TaxAmount)/count(distinct month(o.OrderDate))*12),'#.#0') as YearlyLinearIncome
from Sales.InvoiceLines sil join Sales.Invoices si
on sil.InvoiceID = si.InvoiceID
join Sales.Orders o
on o.OrderID = si.orderid
group by year(o.OrderDate)) vvv
order by vvv.year;

--EX. 2

select*
from (select year(o.orderdate) as TheYear, DATEPART(quarter,o.orderdate) as TheQuarter, c.CustomerName,
sum(sil.extendedprice-sil.taxamount) as IncomePerYear, DENSE_RANK()over(partition by datepart(quarter, o.orderdate),
year(o.orderdate) order by sum(sil.extendedprice-sil.taxamount)desc) as DNR
from Sales.Customers c join Sales.Orders o
on c.CustomerID=o.CustomerID
join Sales.Invoices si
on o.OrderID=si.OrderID
join Sales.InvoiceLines sil
on sil.InvoiceID=si.InvoiceID
group by year(o.orderdate), DATEPART(quarter,o.orderdate),c.CustomerName
having sum(sil.extendedprice-sil.taxamount)>0
) ggg
where DNR<=5
order by TheYear, TheQuarter;

--EX. 3

select top 10 ws.StockItemID, ws.StockItemName, sum(sil.extendedprice-sil.taxamount) TotalProfit
from Warehouse.StockItems ws join Sales.InvoiceLines sil
on ws.StockItemID=sil.StockItemID
group by ws.StockItemID, ws.StockItemName
order by TotalProfit desc;

--EX. 4

select*
from(
select ROW_NUMBER()over(order by (select null)) RN, StockItemID, StockItemName,UnitPrice,RecommendedRetailPrice, 
sum(recommendedretailprice-unitprice) NominalProductProfit, 
DENSE_RANK()over (order by sum(recommendedretailprice-unitprice)desc) DNR
from Warehouse.StockItems
where ValidTo>getdate()
group by StockItemID, StockItemName,UnitPrice,RecommendedRetailPrice
) k
order by RN;

--EX. 5

select cast(ps.SupplierID as nvarchar) + ' - ' + ps.SupplierName as SupplierDetails,
STRING_AGG(cast (ws.stockitemid as nvarchar)+' '+ ws.stockitemname,'/' ) as ProductDetails 
from Warehouse.StockItems ws join Purchasing.Suppliers ps
on ws.SupplierID=ps.SupplierID 
group by ps.SupplierID ,ps.SupplierName;

--EX. 6

select top(5) sc.CustomerID, aci.CityName, aco.CountryName, aco.Continent, aco.Region,
FORMAT(CAST(SUM(sil.extendedprice) as float), '#,#000,000.00') as TotalExtendedPrice 
from Sales.Customers sc join Application.Cities aci 
on sc.PostalCityID = aci.CityID  
join Application.StateProvinces asp 
on asp.StateProvinceID = aci.StateProvinceID 
join Application.Countries aco 
on aco.CountryID = asp.CountryID   
join Sales.Invoices si  
on si.CustomerID = sc.CustomerID   
join Sales.InvoiceLines sil  
on sil.InvoiceID = si.InvoiceID   
GROUP BY sc.CustomerID, aci.CityName, aco.CountryName, aco.Continent, aco.Region 
ORDER BY TotalExtendedPrice desc;

--EX. 7

select v.*, 
SUM(MonthlyTotal) OVER (partition by OrderYear ORDER BY OrderMonth) as CumulativeTotal
from (
select year(so.OrderDate) as OrderYear, STR(MONTH(so.orderdate)) as OrderMonth, 
SUM(sil.Quantity*sil.UnitPrice) MonthlyTotal
from Sales.Invoices si join Sales.InvoiceLines sil
on si.InvoiceID=sil.InvoiceID
join Sales.Orders so on so.OrderID=si.OrderID
group by year(so.OrderDate), MONTH(so.orderdate)
) v
UNION
select year(so.OrderDate) as OrderYear, 'Grand Total' as OrderMonth, 
sum(sil.Quantity * sil.UnitPrice) as MonthlyTotal,
sum(sil.Quantity * sil.UnitPrice) as CumulativeTotal
from Sales.Invoices si join Sales.InvoiceLines sil
on si.InvoiceID=sil.InvoiceID
join Sales.Orders so on so.OrderID=si.OrderID
group by year(so.OrderDate)
order by OrderYear, OrderMonth;

--EX. 8

select OrderMonth, [2013],[2014],[2015],[2016]
from(select YEAR(orderdate) y, MONTH (orderdate) OrderMonth, OrderID
from Sales.Orders) m
pivot (count(orderid) for y in ([2013],[2014],[2015],[2016])) pvt
order by OrderMonth;

--EX. 9

with cte1 as(
select*, 
DATEDIFF(dd,max(OrderDate)over(partition by CustomerID),max(PreviousOrderDate)over(order by customerID)) as DaysSinceLastOrder, 
avg(DATEDIFF(dd,previousorderdate,orderdate)) over (partition by customerid) as AvgDaysBetweenOrders
from(
select sc.CustomerID,sc.CustomerName,so.OrderDate,
lag(so.orderdate) over (partition by sc.customerid order by so.orderdate) as PreviousOrderDate
from  Sales.Orders so join sales.Customers sc on so.CustomerID=sc.CustomerID
) as t
)
select*, case
when DaysSinceLastOrder>=(2*AvgDaysBetweenOrders)
then 'Potential Churn'
else 'Active'
end as CustomerStatus
from cte1;

--EX. 10

with CustomerCounting as 
(select u.CustomerCategoryName, COUNT(distinct NewCompanyName) as CustomerCount
from (select scc.CustomerCategoryName, case 
when sc.CustomerName like '%Tailspin%' then 'Tailspin Toys (Head Office)'
when sc.CustomerName like '%Wingtip%' then 'Wingtip Toys (Head Office)'
else sc.CustomerName  
end as NewCompanyName
from Sales.CustomerCategories scc
join Sales.Customers sc on scc.CustomerCategoryID = sc.CustomerCategoryID
) as u
group by u.CustomerCategoryName
),
TotalCustomers as 
(select SUM(CustomerCount) as TotalCustCount from CustomerCounting)
select counting.CustomerCategoryName, counting.CustomerCount, total.TotalCustCount,
CONCAT(FORMAT((counting.CustomerCount * 100.00)/total.TotalCustCount, '##.##'), '%'
) as DistributionFactor
from CustomerCounting as counting
cross join TotalCustomers as total
order by CustomerCategoryName;