--Select * 
--from NashvilleHousing


--STANDARDIZE DATA FORMAT

SELECT SaleDate, CONVERT(DATE, saleDate)
from NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, saleDate)

--OR

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = CONVERT( Date, SaleDate)


--Checking 

SELECT SaleDateConverted, CONVERT(DATE, saleDate)
from NashvilleHousing


-----------------

--POPULATE PROPERTY ADDRESS

 
--WHERE PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY,STATE)
--2Ways  SUBSTRING AND PARSE
SELECT PropertyAddress
FROM NashvilleHousing


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing


--DROP TABLE if exists #propertysplitAddress
--USING ALTER TO ADD COLOUM FIRST AND THEN UPDATE THE COLOUM
ALTER TABLE NashvilleHousing
add propertysplitAddress Nvarchar(255);

update NashvilleHousing
SET propertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress) -1)

ALTER TABLE NashvilleHousing
add propertysplicity Nvarchar(255);

update NashvilleHousing
SET propertysplicity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyAddress) +1, LEN(PropertyAddress))




--ANOTHER WAY TO SPLIT
--USING PARSE TO SPLIT ADDRESS. IT WORKS BACKWARDS SO 3,2,1

SELECT OwnerAddress
from NashvilleHousing


select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from NashvilleHousing

--MAKING CHANGE TO TABLE NOW

ALTER TABLE NashvilleHousing
add OwnersplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

Select * 
from NashvilleHousing



---CHANGE Y AND N TO YES AND NO IN SOLDASVACATN COLOUM

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant



SELECT SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'YES'
	when SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'YES'
	when SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END


	-------REMOVE DUPLICATES 


	SELECT * 
	from NashvilleHousing


	--CREATING CTE TO DELETE DUPLICATES

	WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY 
						UniqueID
					 ) row_num
	FROM NashvilleHousing
	)
	SELECT * 
	FROM RowNumCTE
	where row_num > 1
	ORDER BY propertyAddress


	---DELETE UNUSED COLUMS

	SELECT * 
	FROM NashvilleHousing

	ALTER TABLE NashvilleHousing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

	
	ALTER TABLE NashvilleHousing
	DROP COLUMN SaleDate
