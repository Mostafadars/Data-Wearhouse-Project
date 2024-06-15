-- Queries to get insights about the OrderStatus Fact Table

-- Number of orders over time dimension
SELECT TimeID,
       SUM(NumberOfOrders) AS No_Orders_Over_Time
FROM [DWH].F_OrderStatus
GROUP BY TimeID;

-- Number of orders over status dimension
SELECT StatusID,
       SUM(NumberOfOrders) AS No_Orders_Over_Status
FROM [DWH].F_OrderStatus
GROUP BY StatusID
ORDER BY StatusID;

-- Total number of orders all time
SELECT SUM(NumberOfOrders) AS Total_No_Orders
FROM [DWH].F_OrderStatus;

-- Number of orders in each year
SELECT LEFT(TimeID, 4) AS Time_Year,
       SUM(NumberOfOrders) AS No_Orders_In_Year
FROM [DWH].F_OrderStatus
GROUP BY LEFT(TimeID, 4);


-- Queries to get insights about the OrderDates Fact Table

-- Total orders orders, shipped and due
SELECT SalesOrderID,
       OrderDate,
       ShipDate,
       DueDate
FROM [DWH].F_OrderDates;


-- Queries to get insights about the OrderRevenue Fact Table

-- Sum of measures over all dimensions
SELECT TimeID,
       ProductID,
       SpecialOfferID,
       SUM(ProductSold) AS Sum_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Sum_Revenue_Without_Discount,
       SUM(Revenue) AS Sum_Revenue
FROM [DWH].F_OrderRevenue
GROUP BY TimeID,
         ProductID,
         SpecialOfferID;

-- Sum of measures over Time and Product dimensions
SELECT TimeID,
       ProductID,
       SUM(ProductSold) AS Sum_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Sum_Revenue_Without_Discount,
       SUM(Revenue) AS Sum_Revenue
FROM [DWH].F_OrderRevenue
GROUP BY TimeID,
         ProductID;

-- Sum of measures over Time and SpecialOffer dimensions
SELECT TimeID,
       SpecialOfferID,
       SUM(ProductSold) AS Sum_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Sum_Revenue_Without_Discount,
       SUM(Revenue) AS Sum_Revenue
FROM [DWH].F_OrderRevenue
GROUP BY TimeID,
         SpecialOfferID;

-- Sum of measures over Product and SpecialOffer dimensions
SELECT ProductID,
       SpecialOfferID,
       SUM(ProductSold) AS Sum_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Sum_Revenue_Without_Discount,
       SUM(Revenue) AS Sum_Revenue
FROM [DWH].F_OrderRevenue
GROUP BY ProductID,
         SpecialOfferID;

-- Sum of measures over Time dimension
SELECT TimeID,
       SUM(ProductSold) AS Sum_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Sum_Revenue_Without_Discount,
       SUM(Revenue) AS Sum_Revenue
FROM [DWH].F_OrderRevenue
GROUP BY TimeID;

-- Sum of measures over Product dimension
SELECT ProductID,
       SUM(ProductSold) AS Sum_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Sum_Revenue_Without_Discount,
       SUM(Revenue) AS Sum_Revenue
FROM [DWH].F_OrderRevenue
GROUP BY ProductID;

-- Sum of measures over SpecialOffer dimension
SELECT SpecialOfferID,
       SUM(ProductSold) AS Sum_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Sum_Revenue_Without_Discount,
       SUM(Revenue) AS Sum_Revenue
FROM [DWH].F_OrderRevenue
GROUP BY SpecialOfferID;

-- Total measures without any aggregation
SELECT SUM(ProductSold) AS Total_Product_Sales,
       SUM(RevenueWithoutDiscount) AS Total_Revenue_Without_Discount,
       SUM(Revenue) AS Total_Revenue
FROM [DWH].F_OrderRevenue;

