/* Create and Use New Database for GoTravel */
CREATE DATABASE GoTravelDS7502;

USE GoTravelDS7502;

/* Script for Creating Date Table */
CREATE TABLE DimDate(
  PK_Date datetime NOT NULL
  CONSTRAINT PK_DimDate
	PRIMARY KEY,
  Year_Name nvarchar(50) NOT NULL,
  Quarter_Name nvarchar(50) NOT NULL,
  Month_Name nvarchar(50) NOT NULL);

/* Script for Creating Country Table */
CREATE TABLE DimCountry(
  CountryID int NOT NULL
  CONSTRAINT PK_DimCountry
	PRIMARY KEY,
  CountryName nvarchar(255) NOT NULL);

/* Script for Creating City Table */
CREATE TABLE DimCity(
  CityID int NOT NULL
  CONSTRAINT PK_DimCity
	PRIMARY KEY,
  CityName nvarchar(50) NOT NULL,
  CountryID int NOT NULL
  CONSTRAINT FK_DimCity_DimCountry
   FOREIGN KEY (CountryID)
   REFERENCES DimCountry(CountryID));

/* Script for Creating Customer Table */
CREATE TABLE DimCustomer(
  CustomerID int NOT NULL
  CONSTRAINT PK_DimCustomer
	PRIMARY KEY,
  CustomerLastName nvarchar(30) NOT NULL,
  CustomerFirstName nvarchar(30) NOT NULL,
  Address nvarchar(120) NOT NULL,
  RegionName nvarchar(30) NOT NULL,
  CustomerBirthDate date NOT NULL,
  CityID int NOT NULL
  CONSTRAINT FK_DimCustomer_DimCity
   FOREIGN KEY (CityID)
   REFERENCES DimCity(CityID));

/*Script for Creating Airport Table */
CREATE TABLE DimAirport(
  AirportID int NOT NULL
  CONSTRAINT PK_DimAirport
	PRIMARY KEY,
  AirportName nvarchar(255) NOT NULL,
  Length float NOT NULL,
  Elevation float NOT NULL,
  GeoLocation nvarchar(255) NOT NULL,
  CityID int NOT NULL
  CONSTRAINT FK_DimAirport_DimCity
   FOREIGN KEY (CityID)
   REFERENCES DimCity(CityID));

/*Script for Creating Branch Table */
CREATE TABLE DimBranch(
 BranchID int NOT NULL
  CONSTRAINT PK_DimBranch
	PRIMARY KEY,
  BranchName nvarchar(30) NOT NULL,
  CityID int NOT NULL
  CONSTRAINT FK_DimBranch_DimCity
   FOREIGN KEY (CityID)
   REFERENCES DimCity(CityID));

/* Script for Creating Airline Table */
CREATE TABLE DimAirline(
 AirlineID int NOT NULL
  CONSTRAINT PK_DimAirline
	PRIMARY KEY,
  AirlineCode int NOT NULL,
  AirlineName nvarchar(255) NOT NULL,
  CarrierCode nvarchar(255) NOT NULL);

/* Script for Creating Agent Table */
CREATE TABLE DimAgent(
 AgentID int NOT NULL
  CONSTRAINT PK_DimAgent
	PRIMARY KEY,
  AgentLastName nvarchar(30) NOT NULL,
  AgentFirstName nvarchar(30) NOT NULL,
  AgentGender nchar(1) NOT NULL,
  AgentBirthDate date NOT NULL,
  AgentHireDate date NOT NULL,
 BranchID int NOT NULL
  CONSTRAINT FK_DimAgent_DimBranch
   FOREIGN KEY (BranchID)
   REFERENCES DimBranch(BranchID));

/* Script for Fact Table */
CREATE TABLE DimFact(
  CustomerID int NOT NULL
  CONSTRAINT FK1_DimFact_DimCustomer
   FOREIGN KEY (CustomerID)
   REFERENCES DimCustomer(CustomerID),
 AgentID int NOT NULL
  CONSTRAINT FK2_DimFact_DimAgent
   FOREIGN KEY (AgentID)
   REFERENCES DimAgent(AgentID),
 AirlineID int NOT NULL
  CONSTRAINT FK3_DimFact_DimAirline
   FOREIGN KEY (AirlineID)
   REFERENCES DimAirline(AirlineID),
 OutwardDate datetime NOT NULL
  CONSTRAINT FK4_DimFact_DimDate
   FOREIGN KEY (OutwardDate)
   REFERENCES DimDate(PK_Date),
 ReturnDate datetime NOT NULL
  CONSTRAINT FK5_DimFact_DimDate
   FOREIGN KEY (ReturnDate)
   REFERENCES DimDate(PK_Date),
  StartingAirport int NOT NULL
  CONSTRAINT FK6_DimFact_DimAirport
   FOREIGN KEY (StartingAirport)
   REFERENCES DimAirport(AirportID),
  DestinationAirport int NOT NULL
  CONSTRAINT FK7_DimFact_DimAirport
   FOREIGN KEY (DestinationAirport)
   REFERENCES DimAirport(AirportID),
  SalesAmount money NOT NULL,
  Discount money NOT NULL,
  GST money NOT NULL,
  CONSTRAINT PK_DimFact
	PRIMARY KEY (CustomerID, AgentID, AirlineID, OutwardDate, ReturnDate, StartingAirport, DestinationAirport));

/* Script for Creating 'Customer Table with RegionName' View */
USE [DS7502Ass2-2023Staging]
GO

CREATE VIEW vCustomerByRegion

AS

SELECT dbo.Customer.*, dbo.City.RegionName
FROM   dbo.Customer
INNER JOIN dbo.City ON
dbo.Customer.CityID = dbo.City.CityID
GO



/* Add CountryID in dbo.City table; Set CountryID for all NZ cities as 11;
	Done for merging task in building new data mart */

use [DS7502Ass2-2023Staging];

ALTER TABLE dbo.City
ADD CountryID int;

UPDATE dbo.City
SET CountryID = 11;

ALTER TABLE dbo.City
ALTER COLUMN CountryID int NOT NULL;


use GoTravelDS7502;
delete 
  FROM DimCountry;

delete 
  FROM DimCity;

delete 
  FROM DimAirline;

delete 
  FROM DimDate;

delete 
  FROM DimAirport;

delete 
  FROM DimCustomer;

delete 
  FROM DimBranch;

delete 
  FROM DimAgent;

delete 
  FROM DimFact;