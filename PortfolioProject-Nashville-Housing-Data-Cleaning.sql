--Project: Nashville Housing - Data Cleaning
--Source: Data Analysis Bootcamp FCC (AlexTheAnalyst)
--Modified/Edited by: EdyBlau
--Date: 05/27/2024

Select *
From PortfolioProject..NashvilleHousing

---------------------------------------
--Standardize Date Format

Select SaleDate, Convert(Date, SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date, SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = Convert(Date, SaleDate)

Select SaleDateConverted, Convert(Date, SaleDate)
From PortfolioProject..NashvilleHousing

---------------------------------------
--Populate Property Address data

Select *
From PortfolioProject..NashvilleHousing
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = Isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---------------------------------------
--Breaking out Address into Individual Columns (address, city, state)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select
Substring(PropertyAddress, 1, CharIndex(',', PropertyAddress) -1) as Address,
Substring(PropertyAddress, CharIndex(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CharIndex(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, CharIndex(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing

Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select
ParseName(Replace(OwnerAddress,',', '.'), 3),
ParseName(Replace(OwnerAddress,',', '.'), 2),
ParseName(Replace(OwnerAddress,',', '.'), 1)
From PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress = ParseName(Replace(OwnerAddress,',', '.'), 3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = ParseName(Replace(OwnerAddress,',', '.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState = ParseName(Replace(OwnerAddress,',', '.'), 1)

Select *
From PortfolioProject..NashvilleHousing

---------------------------------------
--Change Y and N to Yes and No in 'Sold as Vacant'

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant,
Case
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End

---------------------------------------
--Remove Duplicates

With RowNumCTE as(
Select *,
	Row_Number() Over (
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By UniqueID) row_num
From PortfolioProject..NashvilleHousing)

Select *
--Delete
From RowNumCTE
Where Row_num > 1
--Order By PropertyAddress

---------------------------------------
--Delete unused columns

Select *
From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDate