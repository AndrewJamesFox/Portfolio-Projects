/*

Housing Data Cleaning in SQL

*/

-- Basic look at everything
Select *
From HouseCleaning.dbo.HouseCleaning.dbo.HouseData



--------------------------------------------------------------------------------------------------------
/*
The SaleDate column format is far too complicated.
It's cleaner to standardize the object type of this column to something simpler.
*/

-- Look at all dates
Select SaleDate
From HouseCleaning.dbo.HouseCleaning.dbo.HouseData


-- See column's data type
Select data_type
From INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'HouseCleaning.dbo.HouseData'
And COLUMN_NAME = 'SaleDate'


-- Alter SaleDate to type: Date
Alter Table HouseCleaning.dbo.HouseData
Alter Column SaleDate Date


-- Confirm change has occured
Select data_type
From INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'HouseCleaning.dbo.HouseData'
And COLUMN_NAME = 'SaleDate'



--------------------------------------------------------------------------------------------------------
/*
The ParcelID values correspond to a certain address under the PropertyAddress column.
But some of the observations in PropertyAddress are NULL.
We can populate NULL values in PropertyAddress with the PropertyAddress with a corresponding ParcelID.
*/

-- Show NULL PropertyAddress values with corresponding ParcelID values
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From HouseCleaning.dbo.HouseData a
Join HouseCleaning.dbo.HouseData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


-- Update PropertyAddress to be populated with correct addresses
UPDATE a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From HouseCleaning.dbo.HouseData a
Join HouseCleaning.dbo.HouseData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


-- Confirm Update has taken place
Select PropertyAddress
From HouseCleaning.dbo.HouseData
Where PropertyAddress is null



--------------------------------------------------------------------------------------------------------
/*
The address under PropertyAddress are written as: HOUSE, CITY.
It can be more useful to have separate columns for the HOUSE and CITY portions of the address.
*/

-- Show PropertyAddress along with a column for the house and city substrings parsed out
Select PropertyAddress,
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
, substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as City
From HouseCleaning.dbo.HouseData


--- Alter HouseCleaning.dbo.HouseData to include parsed out House and City columns from PropertyAddress
-- House
Alter Table HouseCleaning.dbo.HouseData
Add PropertyAddressHouse Nvarchar(255)

UPDATE HouseCleaning.dbo.HouseData
Set PropertyAddressHouse = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)


-- City
Alter Table HouseCleaning.dbo.HouseData
Add PropertyAddressCity Nvarchar(255)

UPDATE HouseCleaning.dbo.HouseData
Set PropertyAddressCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))


-- Confirm columns have been added
Select *
From HouseCleaning.dbo.HouseData



--------------------------------------------------------------------------------------------------------
/*
Like with PropertyAddress, the OwnerAddress column should be parsed out into HOUSE, CITY, and STATE columns.
Using parsename() is another method to do so.
*/

-- Show OwnerAddress along with parsed out house, city, and state columns
Select
parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
From HouseCleaning.dbo.HouseData


--- Alter HouseCleaning.dbo.HouseData to include parsed out House, City, and State columns from OwnerAddress
-- House
Alter Table HouseCleaning.dbo.HouseData
Add OwnerAddressHouse Nvarchar(255)

UPDATE HouseCleaning.dbo.HouseData
Set OwnerAddressHouse = parsename(replace(OwnerAddress, ',', '.'), 3)


-- City
Alter Table HouseCleaning.dbo.HouseData
Add OwnerAddressCity Nvarchar(255)

UPDATE HouseCleaning.dbo.HouseData
Set OwnerAddressCity = parsename(replace(OwnerAddress, ',', '.'), 2)



-- State
Alter Table HouseCleaning.dbo.HouseData
Add OwnerAddressState Nvarchar(255)

UPDATE HouseCleaning.dbo.HouseData
Set OwnerAddressState = parsename(replace(OwnerAddress, ',', '.'), 1)


-- Confirm columns have been added
Select *
From HouseCleaning.dbo.HouseData



--------------------------------------------------------------------------------------------------------
/*
The SoldAsVacant column entries are either Yes or No, but some of these values are abbreviated to Y and N.
These should be standardized.
*/

-- Show that SoldAsVacant column has unstandardized entries
Select distinct(SoldAsVacant)
From HouseCleaning.dbo.HouseData

UPDATE HouseCleaning.dbo.HouseData
Set SoldAsVacant =
	CASE
		When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		END


-- Confirm change has taken place
Select distinct(SoldAsVacant)
From HouseCleaning.dbo.HouseData



--------------------------------------------------------------------------------------------------------
/*
There are occasional properties that are listed more than once in the dataset.
It is useful to delete these.
*/

-- Remove duplicates
WITH RowNumCTE as
(
	Select *, 
		row_number() over(
			Partition By ParcelID,
						 PropertyAddress,
						 SalePrice,
						 SaleDate,
						 LegalReference
						 Order By UniqueID
						 ) row_num
	From HouseCleaning.dbo.HouseData
)
Delete
From RowNumCTE
Where row_num > 1


-- Confirm there are no duplicates left
WITH RowNumCTE as
(
	Select *, 
		row_number() over(
			Partition By ParcelID,
						 PropertyAddress,
						 SalePrice,
						 SaleDate,
						 LegalReference
						 Order By UniqueID
						 ) row_num
	From HouseCleaning.dbo.HouseData
)
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress



--------------------------------------------------------------------------------------------------------
/*
Some columns may not be needed for further use.
These columns can be dropped.
*/

-- Delete Unused Columns
Alter Table HouseCleaning.dbo.HouseData
Drop Column PropertyAddress, OwnerAddress, TaxDistrict

-- Confirm columns have been dropped
Select *
From HouseCleaning.dbo.HouseData

--------------------------------------------------------------------------------------------------------