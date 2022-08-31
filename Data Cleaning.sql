-- NAME: Sebastian Forero
-- DATE: 08/25/2022

-- Practicing Cleaning Data through SQL
--Initial View of Data
Select * from Projects..[Nashville Housing]


-------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Standardize Date Format

ALTER TABLE [Nashville Housing]
add sale_date_converted DATE;

Update [Nashville Housing]
SET sale_date_converted = convert(date,saledate)

Select sale_date_converted, convert(date, saledate)
from Projects..[Nashville Housing] 
-------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Populating Property Address Data from ParcelID
-- PROBLEM: Property address data contains null or missing values.
-- SOLUTION: Join table ontop of itself and then fill in ParcelID's that match with the same property address. 
select * 
from projects..[Nashville Housing]
where PropertyAddress is null 

-- Initial View of table 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from projects..[Nashville Housing] a
join Projects..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

-- ISNULL allows you to check if a field contains null values and if it is null what do you want to populate. 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from projects..[Nashville Housing] a
join Projects..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

-- UPDATE 
-- NOTE: When doing joins in an update statement we must reference it by its alias
Update a
SET propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from projects..[Nashville Housing] a
join Projects..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

--Now if we run the following code, the query will no longer return data 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from projects..[Nashville Housing] a
join Projects..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 
-------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Breaking out Address into Indvidual Columns (Addrees, City, State)
-- PROBLEM: This field contains the street address and city sepertated by a comma delimeter 

-- Initial View
Select propertyaddress
from Projects..[Nashville Housing]

--The following substring query will take propertyaddress data up to and including the comma 
Select
Substring(propertyaddress, 1, CHARINDEX(',', PropertyAddress)) as Address 
from Projects..[Nashville Housing]

-- This query will not include the comma like above
Select
Substring(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address 
from Projects..[Nashville Housing]

-- Or instead of substracting substring length by 1 you can also shift the initial position 
Select
Substring(propertyaddress, 0, CHARINDEX(',', PropertyAddress)) as Address 
from Projects..[Nashville Housing]

-- Now lets create two seperate columns 
-- Here the second substring is starting where we left off + 1 position over to the right and ending at the position of the total length of the column 
Select
Substring(propertyaddress, 0, CHARINDEX(',', PropertyAddress)) as Address, 
Substring(propertyaddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyaddress))  as City
from Projects..[Nashville Housing]

-- Now lets make two new columns to the table 
ALTER TABLE [Nashville Housing]
add property_address_split nvarchar(255);

Update [Nashville Housing]
SET property_address_split = Substring(propertyaddress, 0, CHARINDEX(',', PropertyAddress))


ALTER TABLE [Nashville Housing]
add property_city_split nvarchar(255);

Update [Nashville Housing]
SET property_city_split = Substring(propertyaddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyaddress))

-- Checking end of table for new columns 
select * from Projects..[Nashville Housing]

-- Alternative method to splitting data within a column
-- Parsename naturally looks for periods. So here we are using replace to change the commas in owneradress column to periods. 
Select
parsename(replace(owneraddress, ',', '.'), 3), as street_address
parsename(replace(owneraddress, ',', '.'), 2), as city
parsename(replace(owneraddress, ',', '.'), 1) as state
from Projects..[Nashville Housing]

ALTER TABLE [Nashville Housing]
add owner_split_address nvarchar(255);
ALTER TABLE [Nashville Housing]
add owner_split_city nvarchar(255);
ALTER TABLE [Nashville Housing]
add owner_split_state nvarchar(255);

Update [Nashville Housing]
SET owner_split_address = parsename(replace(owneraddress, ',', '.'), 3)
Update [Nashville Housing]
SET owner_split_city = parsename(replace(owneraddress, ',', '.'), 2)
Update [Nashville Housing]
SET owner_split_state = parsename(replace(owneraddress, ',', '.'), 1)

-- Now lets check the table 
select * from Projects..[Nashville Housing]

--Deleting unused columns
Select * from projects..[Nashville Housing]

alter table projects..[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDAte
-------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Find and replace data 
-- PROBLEM: Column 'Soldasvacant' contains N, Yes, Y, and No 

-- View Table
select distinct(soldasvacant), count(soldasvacant)
from projects..[Nashville Housing]
group by SoldAsVacant
order by 2 DESC
-- Find and replace Data
Select Soldasvacant
, CASE WHEN Soldasvacant = 'Y' Then 'Yes'
	   When SoldasVacant = 'N' Then 'No'
	   Else SoldasVacant 
	   end
from projects..[Nashville Housing]

Update [Nashville Housing]
SET SoldAsVacant =  CASE WHEN Soldasvacant = 'Y' Then 'Yes'
	   When SoldasVacant = 'N' Then 'No'
	   Else SoldasVacant 
	   end
--Check Table Again
select distinct(soldasvacant), count(soldasvacant)
from projects..[Nashville Housing]
group by SoldAsVacant
order by 2 DESC
-------------------------------------------------------------------------------------------------------------------------------------------
--END