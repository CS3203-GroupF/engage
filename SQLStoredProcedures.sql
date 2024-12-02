-- Procedure to insert a new organization into the Organization table

CREATE PROCEDURE AddOrganization
    @OrganizationID INT,
    @OrganizationName VARCHAR(500),
    @OrganizationDescription TEXT,
    @OrganizationKeywords TEXT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Organization WHERE OrganizationID = @OrganizationID)
        BEGIN
            PRINT 'OrganizationID already exists.';
            RETURN;
        END

        INSERT INTO Organization (OrganizationID, OrganizationName, OrganizationDescription, OrganizationKeywords)
        VALUES (@OrganizationID, @OrganizationName, @OrganizationDescription, @OrganizationKeywords);
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO

-- Procedure to insert a new contact into the Contact table
CREATE PROCEDURE AddContact
    @ContactID INT,
    @OrganizationID INT,
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Email VARCHAR(254),
    @Phone CHAR(12),
    @Address TEXT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Contact WHERE ContactID = @ContactID)
        BEGIN
            PRINT 'ContactID already exists.';
            RETURN;
        END

        INSERT INTO Contact (ContactID, OrganizationID, FirstName, LastName, Email, Phone, Address)
        VALUES (@ContactID, @OrganizationID, @FirstName, @LastName, @Email, @Phone, @Address);
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO

-- Procedure to search organizations by keywords in the OrganizationKeywords column
CREATE PROCEDURE GetOrganizationsByKeyword
    @Keyword VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        SELECT OrganizationID, OrganizationName, OrganizationDescription, OrganizationKeywords
        FROM Organization
        WHERE OrganizationKeywords LIKE '%' + @Keyword + '%';
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO

-- Procedure to retrieve all contacts associated with a specific organization
CREATE PROCEDURE GetContactsByOrganization
    @OrganizationID INT
AS
BEGIN
    BEGIN TRY
        SELECT C.ContactID, 
               CONCAT(C.FirstName, ' ', C.LastName) AS FullName, 
               C.Email, 
               C.Phone, 
               C.Address
        FROM Contact C
        WHERE C.OrganizationID = @OrganizationID;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO

-- Procedure to update the details of an organization
CREATE PROCEDURE UpdateOrganization
    @OrganizationID INT,
    @OrganizationName VARCHAR(500),
    @OrganizationDescription TEXT,
    @OrganizationKeywords TEXT
AS
BEGIN
    BEGIN TRY
        UPDATE Organization
        SET OrganizationName = @OrganizationName,
            OrganizationDescription = @OrganizationDescription,
            OrganizationKeywords = @OrganizationKeywords
        WHERE OrganizationID = @OrganizationID;

        PRINT 'Organization updated successfully.';
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO

-- Procedure to delete an organization and its associated contacts
CREATE PROCEDURE DeleteOrganization
    @OrganizationID INT
AS
BEGIN
    BEGIN TRY
        -- Delete associated contacts first
        DELETE FROM Contact
        WHERE OrganizationID = @OrganizationID;

        -- Delete the organization
        DELETE FROM Organization
        WHERE OrganizationID = @OrganizationID;

        PRINT 'Organization and associated contacts deleted successfully.';
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO

-- Procedure to retrieve all organizations and their associated contacts
CREATE PROCEDURE GetAllOrganizationsWithContacts
    @Offset INT = 0,
    @Limit INT = 10
AS
BEGIN
    BEGIN TRY
        SELECT O.OrganizationID, 
               O.OrganizationName, 
               O.OrganizationDescription, 
               O.OrganizationKeywords, 
               CONCAT(C.FirstName, ' ', C.LastName) AS ContactName, 
               C.Email, 
               C.Phone, 
               C.Address
        FROM Organization O
        LEFT JOIN Contact C ON O.OrganizationID = C.OrganizationID
        ORDER BY O.OrganizationID
        OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO

-- Procedure to delete a specific contact by ContactID
CREATE PROCEDURE DeleteContact
    @ContactID INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Contact
        WHERE ContactID = @ContactID;

        PRINT 'Contact deleted successfully.';
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH;
END;
GO
