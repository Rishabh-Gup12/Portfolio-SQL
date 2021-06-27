--Cleaning Data in SQL Queries

Select * 
from [Portfolio Project]..NashVilleHousing

-----------------------------------------------------------------------

--Standardize Date Format
Select SaleDate ,CONVERT(Date, SaleDate) as ConvertedDate
from [Portfolio Project]..NashVilleHousing

Update NashVilleHousing
Set SaleDate=CONVERT(Date, SaleDate)

Select * 
from [Portfolio Project]..NashVilleHousing

------------------------------------------------------------------------

--Populate Property Address date

Select a.ParcelID, a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashVilleHousing a
join [Portfolio Project]..NashVilleHousing b
on  a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
Set propertyAddress =ISNULL(a.propertyaddress,b.propertyaddress)
from [Portfolio Project]..NashVilleHousing a
join [Portfolio Project]..NashVilleHousing b
on  a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------------------------------------------------------

--Breaking out address into Individual Columns (Address, City, State)

Select PropertyAddress
from [Portfolio Project]..NashVilleHousing 

Select 
SUBSTRING ( PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING ( PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as Address
from [Portfolio Project]..NashVilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

update NashvilleHousing
Set PropertySplitAddress =SUBSTRING ( PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) 

Alter Table NashvilleHousing
Add PropertySplitAddressCity nvarchar(255)

update NashvilleHousing
Set PropertySplitAddressCity =SUBSTRING ( PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))

Select *
from [Portfolio Project]..NashVilleHousing

----------------------------------------------------------------------------------------------

--Owner Address Parsing ---using parsing instead of substrings

select OwnerAddress
from [Portfolio Project]..NashVilleHousing
where OwnerAddress is not null

Select 
PARSENAME(owneraddress,1)
from [Portfolio Project]..NashVilleHousing
where OwnerAddress is not null
----This above does not shaoe any change beacuse parsename only applicable with '.'

Select 
PARSENAME(Replace(owneraddress,',','.'),1)
from [Portfolio Project]..NashVilleHousing
where OwnerAddress is not null

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(owneraddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(owneraddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255)

update NashvilleHousing
Set OwnerSplitState =PARSENAME(Replace(owneraddress,',','.'),1)

Alter Table NashvilleHousing
Drop column OwnerSplitAddressCity

Select *
from [Portfolio Project]..NashVilleHousing

-----------------------------------------------------------------------------

--Changing Y and N to Yes and No in "sold as vaccant" field

Select Distinct (SoldAsVacant), count( Soldasvacant)
from [Portfolio Project]..NashVilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant ,
Case when SoldAsVacant ='Y' Then 'Yes'
	 When SoldAsVacant ='N' Then 'No'
	 Else SoldAsVacant
	 End
from [Portfolio Project]..NashVilleHousing

Update NashVilleHousing
Set SoldAsVAcant = Case when SoldAsVacant ='Y' Then 'Yes'
	 When SoldAsVacant ='N' Then 'No'
	 Else SoldAsVacant
	 End


-----------------------------------------------------------------------

---Removing Duplicates

Select *
From [Portfolio Project]..NashVilleHousing


-- Creating CTE to remove duplicate


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio Project]..NashVilleHousing
--order by ParcelID
)

--Delete
--From RowNumCTE
--Where row_num >1

Select *
From RowNumCTE
Where row_num >1

---------------------------------------------------------------------------

--Removing the unused columns

 
Alter table [Portfolio Project]..NashVilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress
