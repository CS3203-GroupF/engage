--Delete Contact Table from the the database if it does not exist as specified--
DROP TABLE IF EXISTS Contact;
--Delete Organization Table from the the database if it does not exist as specified--
DROP TABLE IF EXISTS Organization;

--Create the Organization Table and Attributes--
CREATE TABLE Organization 
(
    OrganizationID INT,
    OrganizationName VARCHAR(500),
    OrganizationDescription VARCHAR(1000),
    OrganizationKeywords VARCHAR(500),

    PRIMARY KEY(OrganizationID)
);

--Create the Contact Table and Attributes--
CREATE TABLE Contact
(
    ContactID INT,
    OrganizationID INT,
    FirstName VARCHAR(1000),
    LastName VARCHAR(1000),
    Email VARCHAR(1000),
    Phone VARCHAR(1000),
    Address VARCHAR(1000),

    PRIMARY KEY(ContactID),
    FOREIGN KEY (OrganizationID) REFERENCES Organization(OrganizationID)
);

--Insert Data Values into Organization Table)--
INSERT INTO Organization(OrganizationID, OrganizationName, OrganizationDescription, OrganizationKeywords)
VALUES
(1, 'Academic Advisor Training', 'OU Academic Advisor professional development training and enrichment seminars.', 'Academic Advisor, Professional, Development'),

(2, 'Academic Team', 'We represent OU at quiz bowl tournaments across the U.S. Quiz bowl is a trivia event catered to academic subjects including literature, chemistry, physics, biology, fine arts, history, classical music, anthropology, economics, and many others.', 'Trivia, Competiton, tournament, Academic'),

(3, 'Advanced Radar Research Center Student Affairs Committee', 
    'We focus on connecting and advocating for all the students in OU''s Advanced Radar Research Center in several ways: ' +
    'by connecting the students with the ARRC faculty and ensuring their voice is heard, by informing graduate student''s of their responsibilities ' +
    'and the expectations they should have in their advisor, by equipping students, both graduate and undergraduate, with the resources to navigate ' +
    'college, by promoting a welcoming environment to those less represented in the ARRC and to make sure international students have an enriching experience, ' +
    'by promoting the ARRC, and by hosting student social events!', 
    'Research, Student Affairs, Advocating'),

(4, 'Afghan Student Association', 
    'ASA-OU, a vibrant student organization at the University of Oklahoma, is dedicated to fostering cultural awareness and appreciation for ' + 
    'Afghanistan''s rich history. We organize engaging events celebrating Afghan culture, including national events and days. ' +
    'Beyond enrichment, we warmly welcome new Afghan students, emphasizing that OU is their new home. Our community values diverse cultures, showing respect and solidarity.' + 
    'Together, we form a family with a shared language and culture, ensuring newcomers never feel alone at OU. Join us in building connections, celebrating diversity, and creating a supportive home away from home.',
    'Aghan, Culture, History, Language, Connections, Diversity'),

(5, 'African Student Association', 
    'The African Student Association at the University of Oklahoma was founded to promote unity amongst African students in the Diaspora, ' +
    'create a network that supports African students, educate the community on the African continent, and ultimately celebrate African culture on campus.', 
    'African, Culture, History, Language, Connections, Diversity'),

(6, 'African Women''s League', 
    'The overall mission of A.W.L is: ' +
    '- To be the voice of the female students that hold an International African student status at the University of Oklahoma. ' +
    '- To equip its members with adequate relevant resources to establish themselves as individuals on campus and integrate into tze community ' +
    ' - To empower its members through rigorous various training sessions to better themselves, encouraging self-care, raising awareness, learning, and embracing their identity. ' +
    ' - To promote leadership skills through mentorship of its members through various associations and events To promote social status and etiquette through improved networking, connections, friendships/ sisterhood ' +
    ' - To share the diverse African culture of its members with the OU student body and the local community, through different interactive activities ' +
    ' - To raise awareness, educate the OU and local community of the African tradition and heritage especially through the eyes of the African woman', 
    'African, Culture, History, Language, Connections, Diversity'),

(7, 'Afrobeatz Dance Club at the University of Oklahoma', 
    'We are a group of OU students that are looking to promote a part of African culture through dance. ' +
    'We welcome everyone to have fun while dancing to Afrobeats dance style. We hope that we can unite people of different cultures through dance. ' + 
    'We encourage individuals of all backgrounds (with or without dance experience) to join us in exploring cultures and meet beautiful people. '+ 
    'We refer to each other as "friends and family" and can''t wait for you to join us!',
    'Dance, Afrobeats, Unity, Culture'),

(8, 'Agricultural Law Association', 'N/A', 'Agriculture, Law'),

(9, 'Air Force ROTC Detachment 675',
    'Since 1952, Air Force ROTC Detachment 675 has been training high-quality future Air Force leaders. ' + 
    'Some of the best and brightest University of Oklahoma (OU) students have completed the Air Force ROTC program while earning their undergraduate degree, allowing them to commission as officers in the United States Air Force after graduation. ' +
    'These graduates have served their country well as pilots, Combat Systems Officers (CSOs), Air Battle Managers (ABMs), engineers, doctors, nurses, weather officers, communications officers, acquisition managers, language specialists, etc. ' +
    'Today, this tradition continues on at the University of Oklahoma. If you enroll in AFROTC at Det 675, you will become a part of this long-standing tradition of excellence!',
    'ROTC, Air Force, Leader, Combat Systems Officers, Air Battle Managers, Engineers, Doctors, Nurses, Weather Officer, Communication Officer, Acquitsition Manager, Language Specialist'),

(10, 'Air Force ROTC Student Association', 
    'Since 1952, Air Force ROTC Detachment 675 has been training high-quality future Air Force leaders. ' +
    'Some of the best and brightest University of Oklahoma (OU) students have completed the Air Force ROTC program while earning their undergraduate degree, allowing them to commission as officers in the United States Air Force after graduation. ' +
    'These graduates have served their country well as pilots, Combat Systems Officers (CSOs), Air Battle Managers (ABMs), engineers, doctors, nurses, weather officers, communications officers, acquisition managers, language specialists, etc. ' +
    'Today, this tradition continues on at the University of Oklahoma. If you enroll in AFROTC at Det 675, you will become a part of this long-standing tradition of excellence!', 
    'ROTC, Air Force, Leader, Combat Systems Officers, Air Battle Managers, Engineers, Doctors, Nurses, Weather Officer, Communication Officer, Acquitsition Manager, Language Specialist'),

(11, 'Alpha Chi Omega', 
    'Psi chapter of Alpha Chi Omega is located at the University of Oklahoma in Norman, Oklahoma. ' + 
    'Our chapter is over 325 members strong, making our sisterhood one of the largest chapters of Alpha Chi Omega nationwide.', 
    'Sorority, sisterhood, Greek life'),

(12, 'Alpha Eta Rho - Beta Chi Chapter', 
    'This is the Alpha Eta Rho - Beta Chi chapter at OU. Alpha Eta Rho is a professional collegiate aviation fraternity founded in 1929, dedicated to fostering, and mentoring students that have a common interest in the field of aviation. ' + 
    'It is a coed fraternity that emphasizes mentorship, professional development, and leadership potential amongst students within the aviation industry. ' +
    'Alpha Eta Rho welcomes and encourages a diverse background of individuals to participate in their organization!', 
    'Greek Life, Aviation, Fraternity, mentorship, professional development, leadership'),

(13, 'Alpha Gamma Delta',
    'Alpha Gamma Delta is a womens fraternity meant to build sisterhood, encourage better scholarship, promote volunteering, and build lasting friendships. ' +
    'Guided by our Purpose Alpha Gamma Deltas strive to attain a higher standard, thereby improving their lives, the lives of those around them, and the communities in which they live.',
    'Greek Life, Sorority, Sisterhood, Volunteering, Community'),

(14, 'Alpha Kappa Delta Phi',
    'We are the first, largest, and only international asian-interest sorority in the state of Oklahomma.',
    'Greek Life, Sorority, International, Asian'),

(15, 'Alpha Phi Alpha Fraternity, Inc.',
    'Alpha Phi Alpha Fraternity, Inc., develops leaders, promotes brotherhood and academic excellence, while providiing service and advocacy for our communities.',
    'Greek Life, Fraternity, leadership, mentorship'),

(16, 'American Association of Petroleum Geologists',
    'This chapterr is a student organization for the American Association of Petroleum Geologist. ' +
    'We focus on networking and professional development opportunities for members, as well as offering a variety of technical talks and social activities',
    'Professional development, petroleum, geology, petroleum geologist, networking'),

(17, 'American Constitution Society',
    'The American Constitution Society believes that law should be a force to improve the lives of all people. ' +
    'ACS works for positive change by shaping debate on vitally important legal and constitutional issues through development and promotion of high-impact ideas to opinion leaders and the media.',
    'Constituion, debates, legal, networking, activism, law, policy');

    


--Insert Data Values into Contact Table)--
INSERT INTO Contact(ContactID, OrganizationID, FirstName, LastName, Email, Phone, Address)
VALUES
(1,1, 'N/A', 'N/A', 'N/A', 'N/A', 'N/A'),

(2,2, 'Cassidy', 'Minihan', 'cassidy.h.minihan-1@ou.edu', 'N/A', 'N/A'),

(3,3, 'N/A', 'N/A', 'arrc-sac@ou.edu', '(405)-325-2871', '3190 Monitor Avenue Norman, OK 73019'),

(4,4, 'Maryam', 'Popal', 'maryam.popal-1@ou.edu', '(405)-937-9772', '2721 NW 160th St Terrace Edmond, OK 73013 United States'),

(5,5, 'Oghenekaro', 'Imieye', 'oghenekaro.o.imieye-1@ou.edu', '(405)-888-9637', '900 Asp Avenue, OMU Room 181 #147 Norman, OK 73019 USA'),

(6,6, 'N/A', 'N/A', 'africanwomensleague@gmail.com', 'N/A', '2500 Asp Ave Norman, OK 73019 USA'),

(7,7, 'N/A', 'N/A', 'ouafrobeatz@ou.edu', '2500 Asp Ave Norman, OK 73019 USA','(505)-504-0752'),

(8,8, 'N/A', 'N/A', 'mgjoyce@ou.edu', '(479)-366-6634', '14005 Canterbury Dr Edmond, Ok 73103 United States'),

(9,9, 'N/A', 'N/A', 'N/A', 'N/A', 'N/A'),

(10,10, 'N/A', 'N/A', 'afrotc@ou.edu', '(405)-325-3211', '334 Cate Center Cate 4 Rm 405 Norman OK 73019 USA'),

(11,11, 'N/A', 'N/A', 'ouaxopres@gmail.com', '(832) 600-2465', '1115 College Ave Norman, OK 73072 United States'),

(12,12, 'N/A', 'N/A', 'N/A', 'N/A', '1700 Lexington Ave Norman, Ok 73069 United States'),

(13,13, 'Madison', 'Newberry', 'madison.newberry@ou.edu', '(405)-443-5098', '930 Chautauqua Ave Norman OK 73069'),

(14,14, 'N/A', 'N/A', 'oukdphi.president@gmail.com', '(405)-837-1898', '900 Asp Avenue, Suite #311 Norman OK 73019'),

(15,15, 'N/A', 'N/A', 'mkelly@ou.edu', '(405)-325-0850', '660 Parrington Oval Apt. 5089 Norman OK 73019'),

(16,16, 'N/A', 'N/A', 'N/A', '(405)-325-3253', '100 E. Boyd St. Room 710 Norman, OK 73019'),

(17,17, 'N/A', 'N/A', 'thai@ou.edu', '(123)-132-1234', '300 Timberdell Road Norman OK 73019');




