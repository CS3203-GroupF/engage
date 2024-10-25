
--Validate if the Organization Table exists and all attributes appear as expected--
SELECT *
FROM Organization

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Validate if the Conctact Table exists and all attributes appear as expected--
SELECT *
FROM Contact

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Test Case 1: Exact Keyword Match with 1st Character Capitilized--
SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE '%Professional%' OR OrganizationKeywords LIKE '%Academic Advisor%' OR OrganizationKeywords LIKE '%Development%' 

SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE '%Research%' OR OrganizationKeywords LIKE '%Student Affairs%' OR OrganizationKeywords LIKE '%Advocating%'

SELECT OrganizationName 
FROM Organization
WHERE OrganizationKeywords LIKE '%Trivia%' OR OrganizationKeywords LIKE '%Competition%' OR OrganizationKeywords LIKE '%Tournament%' 

SELECT OrganizationName 
FROM Organization
WHERE OrganizationKeywords LIKE '%Aghan%' OR OrganizationKeywords LIKE '%Culture%' OR OrganizationKeywords LIKE '%History%' OR OrganizationName LIKE '%Diversity'

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Test Case 2: Exact Keyword Match with 1st Character lowercase--
SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE '%professional%' OR OrganizationKeywords LIKE '%academic Advisor%' OR OrganizationKeywords LIKE '%development%' 

SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE '%research%' OR OrganizationKeywords LIKE '%student Affairs%' OR OrganizationKeywords LIKE '%advocating%'

SELECT OrganizationName 
FROM Organization
WHERE OrganizationKeywords LIKE '%trivia%' OR OrganizationKeywords LIKE '%competition%' OR OrganizationKeywords LIKE '%tournament%' 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Test Case 3: Starting Partial Keyword Match--
SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE 'Profess%' OR OrganizationKeywords LIKE 'Academic Advis%' OR OrganizationKeywords LIKE 'Develop%' 

SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE 'Resea%' OR OrganizationKeywords LIKE 'Student Affa%' OR OrganizationKeywords LIKE 'Advocat%'

SELECT OrganizationName 
FROM Organization
WHERE OrganizationKeywords LIKE 'Triv%' OR OrganizationKeywords LIKE 'Compe%' OR OrganizationKeywords LIKE 'Tourna%' 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Test Case 4: Ending Partial Keyword Match--
SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE '%essional' OR OrganizationKeywords LIKE '%emic Advisor' OR OrganizationKeywords LIKE '%lopment' 

SELECT OrganizationName
FROM Organization
WHERE OrganizationKeywords LIKE '%earch' OR OrganizationKeywords LIKE '%udent Affairs' OR OrganizationKeywords LIKE '%ocating'

SELECT OrganizationName 
FROM Organization
WHERE OrganizationKeywords LIKE '%ivia' OR OrganizationKeywords LIKE '%petition' OR OrganizationKeywords LIKE '%rnament' 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Test Case 5: Specific filters applied to get Contact information about an Organization by joining different tables on the OrganizationID
SELECT OrganizationName, (FirstName + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE O.OrganizationID = '1'

SELECT OrganizationName, (FirstName + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE O.OrganizationID = '2'

SELECT OrganizationName, (FirstName + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE O.OrganizationID = '3'

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Test Case 6: Specific filters applied to get all information about an Organization by joining different tables on the OrganizationID
SELECT O.*, (FirstName + ' ' + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE O.OrganizationID = '1'

SELECT O.*, (FirstName + ' ' + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE O.OrganizationID = '2'

SELECT O.*, (FirstName + ' ' + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE O.OrganizationID = '3'

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Test Case 7: Specific filters applied to get all information about an Organization by joining different tables filtering by the OrganizationName
SELECT O.*, (FirstName + ' ' + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE OrganizationName = 'Academic Advisor Training'

SELECT O.*, (FirstName + ' ' + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE OrganizationName = 'Advanced Radar Research Center Student Affairs Committee'

SELECT O.*, (FirstName + ' ' + LastName) AS 'Contact Name', Email, Phone
FROM Organization O JOIN Contact C ON O.OrganizationID = C.OrganizationID
WHERE OrganizationName = 'Academic Team'