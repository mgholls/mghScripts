use [ALPVIC.CMS_DEV]
set nocount on

declare @petitionid int; set @petitionid = 2 -- select * from ce_petition
declare @userId int; set @userId = 1951 -- specify the user id of a registered user
declare @postcode nvarchar(32); set @postcode = 2100 -- any value you want
declare @emailaddress nvarchar(128); set @emailaddress = 'petitionsigner@example.com'
declare @entrycount int; set @entrycount = 0
declare @comment nvarchar(128)
declare @firstname nvarchar(100)
declare @lastname nvarchar(100)

while @entrycount < 50 -- set this value to be the number of signatures you want
begin
	set @comment = 'Petition comment ' + CAST(@entrycount as varchar(10))
	set @firstname = 'FirstName' + CAST(@entrycount as varchar(10))
	set @lastname = 'LastName' + CAST(@entrycount as varchar(10))
	insert into CE_Petition_Signature(ItemCreatedBy, ItemCreatedWhen, ItemGUID, UserID, PublishNametoPublic, Comments, PetitionID, Emailaddress, Postcode, FirstName, LastName)
	values(@userId, GETDATE(), NEWID(), @userId, 1, @comment, @petitionid, @emailaddress, @postcode, @firstname, @lastname)
	set @entrycount = @entrycount + 1
end

select * from CE_Petition_Signature -- 67

/*
delete from CE_Petition_Signature where ItemCreatedBy = 1951 and ItemID > 10
dbcc CHECKIDENT (CE_Petition_Signature, reseed, 10) --, noreseed)
dbcc CHECKIDENT (CE_Petition_Signature, noreseed)
dbcc CHECKIDENT (CE_Petition_Signature)
*/