create schema STG;

create table [STG].[Product](
	[ProductID] [int]  NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[MakeFlag] bit NOT NULL,
	[FinishedGoodsFlag] bit NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Weight] [decimal](8, 2) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
    src_update_date  datetime NOT NULL,
    create_timestamp datetime NOT NULL
);
-- drop table [STG].[Product]


CREATE TABLE [STG].[SpecialOffer](
	[SpecialOfferID] [int]  NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[DiscountPct] [smallmoney] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[MinQty] [int] NOT NULL,
	[MaxQty] [int] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	src_update_date  datetime NOT NULL,
    create_timestamp datetime NOT NULL
);
-- drop table [STG].[SpecialOffer]

CREATE TABLE [STG].[SalesOrderDetail](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int]  NOT NULL,
	[OrderQty] [smallint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL,
	[LineTotal]  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	src_update_date  datetime NOT NULL,
    create_timestamp datetime NOT NULL
);

-- drop table [STG].[SalesOrderDetail]

CREATE TABLE [STG].[SalesOrderHeader](
	[SalesOrderID] [int]  NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] nvarchar(25) NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	src_update_date  datetime NOT NULL,
    create_timestamp datetime NOT NULL
);

-- drop table [STG].[SalesOrderHeader]

CREATE TABLE [STG].[SalesTerritory](
	[TerritoryID] [int]  NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Group] [nvarchar](50) NOT NULL,
	[SalesYTD] [money] NOT NULL,
	[SalesLastYear] [money] NOT NULL,
	[CostYTD] [money] NOT NULL,
	[CostLastYear] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	src_update_date  datetime NOT NULL,
    create_timestamp datetime NOT NULL
);

-- drop table [STG].[SalesTerritory]



-- WareHouse Schema

create schema DWH;


create table [DWH].[StatusDim] (
	[StatusID] [int] IDENTITY(1,1) primary key NOT NULL,
	[Name] nvarchar(50) NOT NULL,
);

insert into [DWH].[StatusDim] (Name) values ('InProcess'), ('Approved'), ('BackOrdered'), ('Rejected'), ('Shipped'), ('Cancelled');


create table [DWH].[ProductDim]( -- Type 1
	[ProductSK] [int] IDENTITY(1,1) primary key NOT NULL,
	ProductSrcID int NOT NULL,
	[Name] nvarchar(50) NOT NULL, -- changed
	[MakeFlag] bit NOT NULL,
	[FinishedGoodsFlag] bit NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Weight] [decimal](8, 2) NULL, -- changed
	create_timestamp   datetime,
	update_timestamp     datetime
);

CREATE TABLE [DWH].[SpecialOfferMainDim]( -- Type 4
	[SpecialOfferSK] [int] IDENTITY(1,1) primary key NOT NULL,
	SpecialOfferSrcID int NOT NULL,
	[DiscountPct] [smallmoney] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	update_timestamp datetime
);

CREATE TABLE [DWH].[SpecialOfferHistoryDim](
	[SpecialOfferHistorySK] [int] IDENTITY(1,1) primary key NOT NULL,
	SpecialOfferSrcID int NOT NULL,
	[DiscountPct] [smallmoney] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	start_timestamp datetime,
	end_timestamp datetime
);

CREATE TABLE [DWH].[SalesOrderDetailDim]( -- Type 2
	[SalesOrderDetailSK] [int] IDENTITY(1,1) primary key NOT NULL,
	[SalesOrderSrcID] [int] NOT NULL, 
	[SalesOrderDetailSrcID] [int]  NOT NULL,
	[OrderQty] [smallint] NOT NULL, -- chnaged
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL, -- changed
	[LineTotal]  float,
	is_last bit,
	create_timestamp   datetime,
	update_timestamp     datetime
);

-- drop table [dwh].[SalesOrderDetailDim];


CREATE TABLE [DWH].[SalesOrderHeaderDim]( -- Type 1
	[SalesOrderHeaderSK] [int] IDENTITY(1,1) primary key NOT NULL,
	[SalesOrderSrcID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL, -- changed
	[ShipDate] [datetime] NULL, -- changed
	[SalesOrderNumber]  nvarchar(25),
	[PurchaseOrderNumber] nvarchar(25) NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryName] nvarchar(50) NULL,
	create_timestamp   datetime,
	update_timestamp     datetime
);

-- drop table [DWH].[SalesOrderHeaderDim];


CREATE TABLE [DWH].[TimeDim]
(
    DateTimeKey BIGINT PRIMARY KEY,
    Date DATE,
    Year INT,
    Month INT,
    Day INT,
    Hour INT	
);

DECLARE @StartDate DATE = '2001-01-01';
DECLARE @EndDate DATE = GETDATE();
DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    DECLARE @Hour INT = 0;

    WHILE @Hour < 24
    BEGIN
        DECLARE @DateTimeKey BIGINT;
        SET @DateTimeKey = CAST(FORMAT(@CurrentDate, 'yyyyMMdd') AS BIGINT) * 10000 + @Hour;

        INSERT INTO [DWH].[TimeDim]
            (DateTimeKey, Date, Year, Month, Day, Hour)
        VALUES
            (@DateTimeKey, @CurrentDate, YEAR(@CurrentDate), MONTH(@CurrentDate), DAY(@CurrentDate), @Hour);

        SET @Hour = @Hour + 1;
    END

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END


-- Fact Tables

CREATE TABLE DWH.F_OrderStatus
(
    OrderStatusSK int IDENTITY(1,1) PRIMARY KEY,
	TimeID BIGINT REFERENCES DWH.TimeDim(DateTimeKey),
    StatusID int REFERENCES DWH.StatusDim(StatusID),
    NumberOfOrders int,
);


CREATE TABLE DWH.F_OrderDates
(
    OrderDatesSK int IDENTITY(1,1) PRIMARY KEY,
	TimeID BIGINT REFERENCES DWH.TimeDim(DateTimeKey),
    SalesOrderID int REFERENCES DWH.SalesOrderHeaderDim(SalesOrderHeaderSK),
	[OrderDate] date,
	[DueDate] date,
	[ShipDate] date,
);


CREATE TABLE DWH.F_OrderRevenue
(
    OrderRevenueSK int IDENTITY(1,1) PRIMARY KEY,
	TimeID BIGINT REFERENCES DWH.TimeDim(DateTimeKey),
    ProductID int REFERENCES DWH.ProductDim(ProductSK),
    SalesOrderID int REFERENCES DWH.SalesOrderDetailDim(SalesOrderDetailSK),
    SpecialOfferID int REFERENCES DWH.SpecialOfferMainDim(SpecialOfferSK),
	TerritoryName nvarchar(50),
	ProductSold smallint,
	UnitPrice [money],
	DiscountPrice [money],
	RevenueWithoutDiscount numeric(38,6),
	Revenue numeric(38,6),
);

-- drop table DWH.F_OrderStatus, DWH.F_OrderDates, DWH.F_OrderRevenue;




-- Some tests
select * from [STG].Product;
select * from [DWH].ProductDim;
update [STG].Product set weight = 5 where ProductID = 1;

select * from [STG].SalesOrderHeader;
select * from [DWH].SalesOrderHeaderDim;

update [STG].SalesOrderHeader set ShipDate = '2024-11-10'
where SalesOrderID = 43659;

select * from [STG].SalesOrderDetail;
select * from [DWH].SalesOrderDetailDim;

truncate table [DWH].SalesOrderDetailDim;


select * from [STG].SpecialOffer;
select * from [DWH].SpecialOfferMainDim;
select * from [DWH].SpecialOfferHistoryDim;

update [STG].SpecialOffer set DiscountPct = 0.7, src_update_date = GETDATE() where SpecialOfferID = 1;


select * from [DWH].TimeDim;
select * from [DWH].F_OrderStatus;
select CAST(FORMAT(src_update_date, 'yyyyMMdd') AS BIGINT) as fulldate, SalesOrderID, Status from [STG].SalesOrderHeader;

select * from [STG].SalesOrderHeader where Status = 5 and CAST(src_update_date as date) = '2011-06-07';


-- Get TimeID with any Lookup
select Status, CAST(FORMAT(src_update_date, 'yyyyMMdd') AS BIGINT) * 10000 + DATEPART(HOUR, src_update_date) as fulldate from [STG].SalesOrderHeader;










update [DWH].F_OrderStatus set StatusID = 4 where OrderStatusSK = 1;

select * from [DWH].F_OrderStatus
select * from [DWH].F_OrderStatus where StatusID = 5 and TimeID = 201111020000; -- 6

truncate table  [DWH].F_OrderStatus;

select * from [STG].SalesOrderHeader;
select * from [STG].SalesOrderHeader where SalesOrderID = 44713;
update [STG].SalesOrderHeader set Status = 4 where SalesOrderID = 44713;


select SalesOrderID, 
CAST(FORMAT(src_update_date, 'yyyyMMdd') AS BIGINT) * 10000 + DATEPART(HOUR, src_update_date) as fulldate, 
CAST(OrderDate as date), 
CAST(DueDate as date), 
CAST(ShipDate as date),
BINARY_CHECKSUM(OrderDate, DueDate, ShipDate) as BSM
from [STG].SalesOrderHeader;

select * , BINARY_CHECKSUM(OrderDate, DueDate, ShipDate) as BSM
from [DWH].F_OrderDates


update [DWH].F_OrderDates set OrderDate = ?, DueDate = ?, ShipDate = ? where OrderDatesSK = ?;

select * from [DWH].F_OrderDates;


select SalesOrderHeaderSK,
	SalesOrderSrcID,
	CAST(FORMAT(update_timestamp, 'yyyyMMdd') AS BIGINT) * 10000 + DATEPART(HOUR, update_timestamp) as fulldate, 
	CAST(OrderDate as date) as OrderDate , 
	CAST(DueDate as date) as DueDate, 
	CAST(ShipDate as date) as ShipDate,
	BINARY_CHECKSUM(OrderDate, DueDate, ShipDate) as BSM
from [DWH].SalesOrderHeaderDim;


select * from [DWH].SalesOrderHeaderDim;
select * from [DWH].F_OrderDates;
-- truncate table [DWH].F_OrderDates

update [DWH].SalesOrderHeaderDim set DueDate = GETDATE() where SalesOrderHeaderSK = 1





-- last fact table
select * from [DWH].SalesOrderDetailDim
select * from [DWH].ProductDim
select * from [DWH].SpecialOfferMainDim




select SalesOrderDetailSrcID, SalesOrderDetailSrcID, OrderQty, UnitPrice, UnitPriceDiscount, LineTotal, SpecialOfferID

from [DWH].SalesOrderDetailDim;

select Status, CAST(FORMAT(src_update_date, 'yyyyMMdd') AS BIGINT) * 10000 + DATEPART(HOUR, src_update_date) as fulldate from [STG].SalesOrderHeader;

select SpecialOfferSrcID, CAST(FORMAT(update_timestamp, 'yyyyMMdd') AS BIGINT) * 10000 + DATEPART(HOUR, update_timestamp) as fulldate from DWH.SpecialOfferMainDim 

select SpecialOfferSrcID, CAST(FORMAT(update_timestamp, 'yyyyMMdd') AS BIGINT) * 10000 + DATEPART(HOUR, update_timestamp) as fulldate from DWH.SpecialOfferMainDim

select SpecialOfferSK from DWH.SpecialOfferMainDim


update DWH.F_OrderRevenue 
set ProductSold = ? , UnitPrice=?
where OrderRevenueSK = ?

select * from DWH.F_OrderRevenue
truncate table DWH.F_OrderRevenue

select * from DWH.SalesOrderDetailDim

update dwh.SalesOrderDetailDim set OrderQty = 10 where SalesOrderDetailSK= 1

