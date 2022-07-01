/*

 Cleaning Data in SQL query

*/

Select * 
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted
from PortfolioProject.dbo.NashvilleHousing

--Update NashvilleHousing
--Set SaleDate= CONVERT(date,SaleDate)

Alter TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted= CONVERT(date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID= b.ParcelID
 And a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null


 update a
 set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID= b.ParcelID
 And a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null


 --------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

Select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))as Address
from PortfolioProject.dbo.NashvilleHousing



Alter TABLE PortfolioProject.dbo.NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress= substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter TABLE PortfolioProject.dbo.NashvilleHousing
add PropertySplitCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity= substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


Select *
from PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)

from PortfolioProject.dbo.NashvilleHousing

Select PropertyAddress

from PortfolioProject.dbo.NashvilleHousing

/*Select 
PARSENAME(Replace(PropertyAddress,',','.'),2),
PARSENAME(Replace(PropertyAddress,',','.'),1)

from PortfolioProject.dbo.NashvilleHousing 
--easiest way to split the address
*/

Alter TABLE PortfolioProject.dbo.NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress= PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter TABLE PortfolioProject.dbo.NashvilleHousing
add OwnerSplitCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity= PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter TABLE PortfolioProject.dbo.NashvilleHousing
add OwnerSplitState nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState= PARSENAME(Replace(OwnerAddress,',','.'),1)


Select *
from PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
  case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
  else SoldAsVacant
  end
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant= case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
  else SoldAsVacant
  end

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
--Select *
--from PortfolioProject.dbo.NashvilleHousing

 With RowNumCTE AS(
  Select *,
     ROW_NUMBER () Over
         ( partition by 
               ParcelID,
               PropertyAddress,
               SaleDate,
               SalePrice,
               legalReference

        order by uniqueID
        )row_num

   from PortfolioProject.dbo.NashvilleHousing 
--order by ParcelID
)

 Select *
 from RowNumCTE
 where row_num >1
 order by PropertyAddress







---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
from PortfolioProject.dbo.NashvilleHousing

Alter TABLE PortfolioProject.dbo.NashvilleHousing
Drop COLUMN OwnerAddress, PropertyAddress,SaleDate,TaxDistrict