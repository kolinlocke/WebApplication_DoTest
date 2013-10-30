Select * From [Person]
Select * From [Customer]
Select * From [ContactPerson]
Select * From [ContactPerson_Details]


Select Top 10 * From [uvw_ContactPerson_Details] Where FullName Like 'CP%'

Select MAX(ContactPersonID) From [Customer]
Select COUNT(1) From [Person]
Select COUNT(1) From [ContactPerson_Details]

Select * From [uvw_Customer]
Select * From [uvw_Party]
Select * From [uvw_Customer] Where CustomerName Like '%111%'

Exec sp_spaceused 'Customer'
Exec sp_spaceused 'Person'
Exec sp_spaceused 'ContactPerson'
Exec sp_spaceused 'ContactPerson_Details'

/*
Delete From Person Where PersonID >= 100001
Delete From ContactPerson
Delete From ContactPerson_Details

Dbcc CheckIdent('Person',Reseed,0)
Dbcc CheckIdent('Person',Reseed)

Dbcc CheckIdent('ContactPerson',Reseed,0)
Dbcc CheckIdent('ContactPerson',Reseed)

Dbcc CheckIdent('ContactPerson_Details',Reseed,0)
Dbcc CheckIdent('ContactPerson_Details',Reseed)

Update Customer Set ContactPersonID = Null
*/

