--Cleaning and separating Data

select Data, SUBSTRING(Data, CHARINDEX('Name', Data)+5, CHARINDEX('Address',Data)-7) as "Name",
SUBSTRING(Data, CHARINDEX('Address',Data)+8, (CHARINDEX('Age',Data))-(CHARINDEX('Address',Data)+8)) as "Address",
SUBSTRING(Data, CHARINDEX('Age',Data)+4, (CHARINDEX('Gender',Data))-(CHARINDEX('Age',Data)+4)) as "Age",
SUBSTRING(Data, CHARINDEX('Gender',Data)+7, (Len(Data)+1)-(CHARINDEX('Gender',Data)+7)) as "Gender"
from PortfolioProject.dbo.DirtyCustomers



--updating table
Alter table DirtyCustomers
Add
	Name nvarchar(255),
	Address nvarchar(255),
	Age numeric,
	Gender nvarchar(50);

--inserting cleanup Data into Columns
update DirtyCustomers
set
	Name = SUBSTRING(Data, CHARINDEX('Name', Data)+5, CHARINDEX('Address',Data)-7),
	Address = SUBSTRING(Data, CHARINDEX('Address',Data)+8, (CHARINDEX('Age',Data))-(CHARINDEX('Address',Data)+8)),
	Age = SUBSTRING(Data, CHARINDEX('Age',Data)+4, (CHARINDEX('Gender',Data))-(CHARINDEX('Age',Data)+4)),
	Gender = SUBSTRING(Data, CHARINDEX('Gender',Data)+7, (Len(Data)+1)-(CHARINDEX('Gender',Data)+7))
	
--Deleting Original Column
alter table DirtyCustomers
drop column Data;

select *
from PortfolioProject..DirtyCustomers