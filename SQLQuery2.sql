--cleaning Data in SQL
select * from Portfolioproject.dbo.Neshvile

--Standardize date format
use Portfolioproject
Select SaleDate,CONVERT(Date,SaleDate) 
from Portfolioproject.dbo.Neshvile

update Neshvile Set SaleDate=CONVERT(Date,SaleDate)
alter table Neshvile add Converted_date date
update Neshvile Set Converted_date=CONVERT(Date,SaleDate)

select * from Portfolioproject.dbo.Neshvile

--Populate property address data
Select * from Neshvile 

Select * from Neshvile where PropertyAddress is null


Select a.ParcelID,a.[UniqueID ],a.PropertyAddress,b.ParcelID,b.[UniqueID ],b.PropertyAddress from Neshvile a join Neshvile b
on a.ParcelID= b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


Update a set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Neshvile a join Neshvile b
on a.ParcelID= b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

Select * from Neshvile where PropertyAddress is null



--Breaking out address into Individual --columns Address, City, State
Select PropertyAddress from Portfolioproject.dbo.Neshvile

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from Portfolioproject.dbo.Neshvile

Alter table Neshvile add PropertysplitAddress nvarchar (255)
Update Neshvile Set PropertysplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table Neshvile add PropertysplitCity nvarchar (255)
Update Neshvile Set PropertysplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select * from Portfolioproject.dbo.Neshvile

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3), 
PARSENAME(Replace(OwnerAddress,',','.'),2) ,
PARSENAME(Replace(OwnerAddress,',','.'),1) 
from Portfolioproject.dbo.Neshvile


Alter table Neshvile add PropertyspAddress nvarchar (255)
Update Neshvile Set PropertyspAddress = PARSENAME(Replace(OwnerAddress,',','.'),3) 

Alter table Neshvile add PropertyspCity nvarchar (255)
Update Neshvile Set PropertyspCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table Neshvile add PropertysplitState  nvarchar (255)
Update Neshvile Set PropertysplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)
--Change Y and N as YES and No from SoldAsVacant

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from Portfolioproject.dbo.Neshvile
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE 
when SoldAsVacant='Y' then 'YES'
when SoldAsVacant='N' then 'No'
Else SoldAsVacant
End
from Portfolioproject.dbo.Neshvile

Update Neshvile set SoldAsVacant = CASE 
when SoldAsVacant='Y' then 'YES'
when SoldAsVacant='N' then 'No'
Else SoldAsVacant
End
from Portfolioproject.dbo.Neshvile

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from Portfolioproject.dbo.Neshvile
Group by SoldAsVacant
Order by 2


--Remove Duplicates
Select * from Portfolioproject.dbo.Neshvile

WITH RowNumCTE AS ( 
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, 
                            PropertyAddress, 
                            SalePrice, 
                            SaleDate, 
                            LegalReference 
               ORDER BY UniqueID
           ) AS row_num
    FROM Portfolioproject.dbo.Neshvile
)

Select * from RowNumCTE
where row_num>1
--order by PropertyAddress



--Delete Unused coloumn--
Select * from Portfolioproject.dbo.Neshvile

Alter table Portfolioproject.dbo.Neshvile drop column  SaleDate,PropertyAddress,OwnerAddress, TaxDistrict