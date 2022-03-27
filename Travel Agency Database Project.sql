CREATE DATABASE TravelAgency15  --creates database

USE TravelAgency15

/*create table Person */  

CREATE TABLE PERSON(
	PersonID INT IDENTITY PRIMARY KEY, --
	PersonFN VARCHAR(30) NOT NULL, --
	PersonLN VARCHAR(40) NOT NULL,
	PersonEmail VARCHAR(100) NOT NULL, --
	
);

/*create table TRAVELER */   -- 

CREATE TABLE TRAVELER(
	TravelerID INT PRIMARY KEY, --
	TravelerDOB DATE NOT NULL,  --
	TravelerGender CHAR(1), --
	FOREIGN KEY(TravelerID) REFERENCES PERSON(PersonID) --
);

/*create table CLIENT */  --need foregin key person

CREATE TABLE CLIENT(
	ClientID INT PRIMARY KEY, --
	ClientDOB DATE NOT NULL,  --needs valid check
	ClientGender CHAR(1) NOT NULL CHECK(ClientGender in ('m','f','o')),-
	ClientMaritalStatus CHAR(1) NOT NULL,  --
	ClientStreet VARCHAR(95) NOT NULL,
	ClientCity VARCHAR(35) NOT NULL,
	ClientState VARCHAR(65) NOT NULL,
	ClientZip CHAR(6) NOT NULL,
	ClientPhone CHAR(15) NOT NULL,
	FOREIGN KEY(ClientID) REFERENCES PERSON(PersonID) 
);

/*create table TRAVEL_AGENT */  

CREATE TABLE TRAVEL_AGENT(
	AgentID INT PRIMARY KEY,
	HireDate DATE NOT NULL,
	FOREIGN KEY(AgentID) REFERENCES PERSON(PersonID) --
);

/*create table Passport */
CREATE TABLE PASSPORT(
	PassportID VARCHAR(12) PRIMARY KEY,
	IssueDate DATE NOT NULL,
	ExpiryDate DATE NOT NULL,
	CountryIssued VARCHAR(50) NOT NULL,  
	TravelerID INT,
	FOREIGN KEY(TravelerID) REFERENCES TRAVELER(TravelerID) 
);

/*create table Geographical Preference */ 

CREATE TABLE GEOGRAPHICAL_PREFERENCE(
	Geographical_PreferenceID INT IDENTITY PRIMARY KEY,
	Location_Name VARCHAR(25) NOT NULL
);

/*create table PERSON_GEOGRAPHICAL_PREFERENCE */

CREATE TABLE PERSON_GEOGRAPHICAL_PREFERENCE(
	Geographical_PreferenceID INT,
	PersonID INT,
	PRIMARY KEY (Geographical_PreferenceID, PersonID),
	FOREIGN KEY(Geographical_PreferenceID) REFERENCES GEOGRAPHICAL_PREFERENCE(Geographical_PreferenceID),
	FOREIGN KEY(PersonID) REFERENCES PERSON(PersonID)
);


--create VACATION PACKAGE 	
CREATE TABLE Vacation_Package(
	PackageID INT PRIMARY KEY,
	VacationPackageDescription VARCHAR(30) NOT NULL,
	VacationPackageItinerary VARCHAR(30) NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	DepartureCity VARCHAR(20) NOT NULL,
	Price MONEY NOT NULL,
	Destination VARCHAR(30) NOT NULL
	);

--create table BOOKING	
CREATE TABLE Booking(
	BookingID INT PRIMARY KEY,
	ClientID INT,
	AgentID INT,
	PackageID INT,
	FOREIGN KEY(ClientID) REFERENCES Client(ClientID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (AgentID) REFERENCES Travel_Agent(AgentID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (PackageID) REFERENCES Vacation_Package(PackageID) ON DELETE CASCADE ON UPDATE CASCADE
	);

--create table Meetings
CREATE TABLE MEETING(
	ConsultID INT PRIMARY KEY,
	ConsultNote VARCHAR (100),
	ConsultDate DATE,
	ConsultTime TIME,
	AgentID INT,
	ClientID INT,
	FOREIGN KEY(AgentID) References Travel_Agent(AgentID),
	FOREIGN KEY (ClientID) References Client(ClientID)
);

/*create table AIRLINE_TICKET */ 

CREATE TABLE AIRLINE_TICKET(
	TicketID INT IDENTITY PRIMARY KEY,
	TicketName VARCHAR(25) NOT NULL,
	TicketDate DATE NOT NULL,
	Ticket_Airline_Name VARCHAR(45) NOT NULL,
	TravelerID int,
	FOREIGN KEY(TravelerID) REFERENCES TRAVELER(TravelerID)
);
--Create table vacation interest
CREATE TABLE Vacation_Interest(
	InterestID INT PRIMARY KEY,
	InterestType VARCHAR(30) NOT NULL
	);

--create table person vacation interest
CREATE TABLE PERSON_VACATION_INTEREST(
	PersonID INT,
	InterestID INT,
	PRIMARY KEY(PersonID, InterestID),
	FOREIGN KEY(PersonID) REFERENCES PERSON(PersonID),
	FOREIGN KEY(InterestID) REFERENCES VACATION_INTEREST(InterestID)
	);
--Create table Country
CREATE TABLE COUNTRY(
	CountryID INT PRIMARY KEY,
	CountryName VARCHAR(20) NOT NULL
);

--Create table Attraction
CREATE TABLE ATTRACTION (
	AttractionID INT PRIMARY KEY,
	AttractionPrice MONEY NOT NULL,
	AttractionDetail VARCHAR(30) NOT NULL,
	AttractionName VARCHAR(15) NOT NULL
);
--create table custom bookings
CREATE TABLE Custom_Bookings(
	CustomBookingID INT PRIMARY KEY,
	ClientID INT,
	FOREIGN KEY(ClientID) REFERENCES Client(ClientID)
	ON DELETE CASCADE ON UPDATE CASCADE
	);
--Create table SERVICE	
CREATE TABLE Travel_Services(
	ServiceID INT PRIMARY KEY,
	ServiceFee MONEY NOT NULL,
	BookingID INT NOT NULL,
	FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
	);


/*create table GEO_VACATION_PACKAGE */ 
CREATE TABLE GEO_VACATION_PACKAGE(
	Geographical_PreferenceID INT,
	PackageID INT,
	FOREIGN KEY(Geographical_PreferenceID) REFERENCES GEOGRAPHICAL_PREFERENCE(Geographical_PreferenceID),
	FOREIGN KEY(PackageID) REFERENCES VACATION_PACKAGE(PackageID)
);
--create table hotel
CREATE TABLE HOTEL (
	HotelID INT PRIMARY KEY,
	HotelStreet VARCHAR(30) NOT NULL,
	HotelCity VARCHAR(30) NOT NULL,
	HotelZip VARCHAR(10) NOT NULL,
	HotelCountry VARCHAR(20) NOT NULL,
	HotelPhone CHAR(10) NOT NULL,
	CountryID INT NOT NULL,
	FOREIGN KEY (CountryID) REFERENCES COUNTRY(CountryID)
);
--create HOTEL PACKAGE 
CREATE TABLE Hotel_Package(
	HotelID INT NOT NULL,
	PackageID INT NOT NULL,
	CheckInDate DATE NOT NULL,
	CheckOutDate DATE NOT NULL,
	PRIMARY KEY (HotelID, PackageID),
	FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
	FOREIGN KEY (PackageID) REFERENCES Vacation_Package(PackageID) 
	);
--create AIR+LAND	
CREATE TABLE Air_and_Land(
	FlightNumber VARCHAR(8) PRIMARY KEY,
	Airline VARCHAR(20) NOT NULL,
	DepartureDate DATE NOT NULL,
	DepartureTime TIME NOT NULL,
	AirportOrigin VARCHAR(20) NOT NULL,
	Destination VARCHAR(20) NOT NULL,
	BookingID INT NOT NULL,
	PackageID INT NOT NULL,
	FOREIGN KEY(BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(PackageID) REFERENCES Vacation_Package(PackageID) 
	);

	CREATE TABLE Vacation_Package_Attraction (
	AttractionID INT NOT NULL,
	PackageID INT NOT NULL,
	VisitDate DATE,
	PRIMARY KEY (AttractionID, PackageID),
	FOREIGN KEY (AttractionID) REFERENCES ATTRACTION(AttractionID),
	FOREIGN KEY (PackageID) REFERENCES VACATION_PACKAGE(PackageID)
);


CREATE TABLE Vacation_Package_Country (
	CountryID INT NOT NULL,
	PackageID INT NOT NULL,
	PRIMARY KEY (CountryID, PackageID),
	FOREIGN KEY (CountryID) REFERENCES COUNTRY(CountryID),
	FOREIGN KEY (PackageID) REFERENCES VACATION_PACKAGE(PackageID)
);


CREATE TABLE CUSTOM_BOOKING_ATTRACTION (
	AttractionID INT NOT NULL,
	CustomBookingID INT NOT NULL,
	PRIMARY KEY (AttractionID, CustomBookingID),
	FOREIGN KEY (AttractionID) REFERENCES ATTRACTION(AttractionID),
	FOREIGN KEY (CustomBookingID) REFERENCES CUSTOM_BOOKINGS(CustomBookingID)
);

CREATE TABLE CUSTOM_BOOKINGS_HOTEL (
	HotelID INT NOT NULL,
	CustomBookingID INT NOT NULL,
	PRIMARY KEY (HotelID, CustomBookingID),
	FOREIGN KEY (HotelID) REFERENCES HOTEL(HotelID),
	FOREIGN KEY (CustomBookingID) REFERENCES CUSTOM_BOOKINGS(CustomBookingID)
);

CREATE TABLE CUSTOM_BOOKINGS_COUNTRY (
	CountryID INT NOT NULL,
	CustomBookingID INT NOT NULL,
	PRIMARY KEY (CountryID, CustomBookingID),
	FOREIGN KEY (CountryID) REFERENCES COUNTRY(CountryID),
	FOREIGN KEY (CustomBookingID) REFERENCES CUSTOM_BOOKINGS(CustomBookingID)
);


/*----------------------------- INSERTS----------------------------------------*/


USE TravelAgency15
/*Insert into PERSON TABLE*/


INSERT INTO PERSON
VALUES('Michael', 'Nash', 'mikenash@hotmail.com');

INSERT INTO PERSON
VALUES('Alex', 'Hesse', 'alexhesse@hotmail.com'); 

INSERT INTO PERSON
VALUES('Ian', 'Harster', 'ianharster@hotmail.com');

INSERT INTO PERSON
VALUES('Cesar', 'Vega', 'cesarvega@hotmail.com');

INSERT INTO PERSON
VALUES('Carlos', 'Melgarejo', 'carlosmel@hotmail.com'); 

INSERT INTO PERSON
VALUES('Gian', 'Carlo', 'giancarlo@hotmail.com');

INSERT INTO PERSON
VALUES('Rodrigo', 'Arteta', 'rodrigoarteta@hotmail.com');

INSERT INTO PERSON
VALUES('Fabrizio', 'Petrozzi', 'fabriziopetrozzi@hotmail.com'); 

INSERT INTO PERSON
VALUES('Cesar', 'Gonzales', 'cesargonzales@hotmail.com'); 

INSERT INTO PERSON
VALUES('Olivia', 'Smichtd', 'oliviasmichtd@hotmail.com');

INSERT INTO PERSON
VALUES('Alessia', 'Kerra', 'alessiakerra@hotmail.com');

INSERT INTO PERSON
VALUES('Natasha', 'Veltri', 'natashaveltri@hotmail.com'); 

INSERT INTO PERSON
VALUES('Amelia', 'Carranzas', 'ameliacarranzas@hotmail.com');

INSERT INTO PERSON
VALUES('Julia', 'Torpoco', 'juliatorpoco@hotmail.com'); 

INSERT INTO PERSON
VALUES('Hailey', 'Criado', 'haileycriado@hotmail.com'); 



/*insert into Traveler*/


INSERT INTO TRAVELER
VALUES(1, '2001-12-12', 'm')

INSERT INTO TRAVELER
VALUES(2, '2002-2-2', 'm')

INSERT INTO TRAVELER
VALUES(3, '2006-4-2', 'm')

INSERT INTO TRAVELER
VALUES(4, '2007-3-1', 'm')

INSERT INTO TRAVELER
VALUES(5, '2001-12-12', 'm')


/*insert into CLIENT*/

INSERT INTO CLIENT
VALUES(6,'1995-02-22', 'm', 's', ' Zeals Green Platz', 'Hollywood', 'Florida', 33606, '123456789123456')

INSERT INTO CLIENT
VALUES(7,'1997-03-21', 'm', 's', 'Norman Beeches', 'Tampa', 'Florida', 33606, '123456789123457')

INSERT INTO CLIENT
VALUES(8,'1998-07-08', 'm', 's', 'New Beacon Road', 'La Molina', 'Florida', 33606, '123456789123458')

INSERT INTO CLIENT
VALUES(9,'1995-04-25', 'm', 's', 'Netherfield Approach', 'Tampa', 'Florida', 33606,'123456789123459')

INSERT INTO CLIENT
VALUES(10,'1994-09-03', 'o', 's', 'Robin Hood Lane', 'Tampa', 'Florida', 33606, '123456789123411')



/*Insert into TRAVEL AGENT*/

INSERT INTO TRAVEL_AGENT
VALUES(11, '1992-02-24')

INSERT INTO TRAVEL_AGENT
VALUES(12, '1995-05-23')

INSERT INTO TRAVEL_AGENT
VALUES(13, '1996-08-28')

INSERT INTO TRAVEL_AGENT
VALUES(14, '1997-01-23')

INSERT INTO TRAVEL_AGENT
VALUES(15, '1996-08-28')


/*Insert into PASSPORT*/


INSERT INTO PASSPORT
VALUES('6912341', '2014-02-23', '2024-04-27', 'USA', 1)

INSERT INTO PASSPORT
VALUES('6912342', '2014-02-24', '2024-04-28', 'USA', 2)

INSERT INTO PASSPORT
VALUES('6912343', '2014-02-25', '2024-04-29', 'USA', 3)

INSERT INTO PASSPORT
VALUES('6912344', '2014-02-26', '2024-04-27', 'USA', 4)

INSERT INTO PASSPORT
VALUES('6912345', '2014-02-27', '2024-04-28', 'USA', 5)



/*INSERT into GEO PREFERENCE*/

INSERT INTO GEOGRAPHICAL_PREFERENCE
VALUES('Mountains')

INSERT INTO GEOGRAPHICAL_PREFERENCE
VALUES('Rainforest')

INSERT INTO GEOGRAPHICAL_PREFERENCE
VALUES('Coast')

INSERT INTO GEOGRAPHICAL_PREFERENCE
VALUES('Lake')

INSERT INTO GEOGRAPHICAL_PREFERENCE
VALUES('DESERT')



/*Insert into PERSON_GEOGRAPHICAL_PREFERENCE*/

/*INSERT INTO BOOKING*/


INSERT INTO BOOKING
VALUES(111,6,11,11111111)

INSERT INTO BOOKING
VALUES(112,7,12,11111112)

INSERT INTO BOOKING
VALUES(113,8,13,11111113)

INSERT INTO BOOKING
VALUES(114,9,14,11111114)

INSERT INTO BOOKING
VALUES(115,10,15,11111115)


/*INSERT INTO MEETING*/

INSERT INTO MEETING
VALUES(111, 'Find interesting places with Mountains', '2021-12-5', '12:00:00', 11, 6)

INSERT INTO MEETING
VALUES(121, 'Find interesting places with Mountains', '2021-12-5', '12:00:00', 12, 7)

INSERT INTO MEETING
VALUES(131, 'Find interesting places with Mountains', '2021-12-5', '12:00:00', 13, 8)

INSERT INTO MEETING
VALUES(141, 'Find interesting places with Mountains', '2021-12-5', '12:00:00', 14, 9)

INSERT INTO MEETING
VALUES(151, 'Find interesting places with Mountains', '2021-12-5', '12:00:00', 15, 10)

/*INSERT INTO AIRLINE TICKET*/


INSERT INTO AIRLINE_TICKET
VALUES('MILAN', '2021-11-2', 'SPIRIT AIRLINES', 1)

INSERT INTO AIRLINE_TICKET
VALUES('PARIS', '2021-10-22', 'SPIRIT AIRLINES', 2)

INSERT INTO AIRLINE_TICKET
VALUES('PARIS', '2021-10-23', 'SPIRIT AIRLINES', 3)

INSERT INTO AIRLINE_TICKET
VALUES('PARIS', '2021-8-11', 'SPIRIT AIRLINES', 4)

INSERT INTO AIRLINE_TICKET
VALUES('PARIS', '2021-8-13', 'SPIRIT AIRLINES', 5)

/*INSERT INTO VACATION INTEREST*/

INSERT INTO Vacation_Interest
VALUES(321,'City')

INSERT INTO Vacation_Interest
VALUES(322,'Mountains')

INSERT INTO Vacation_Interest
VALUES(323, 'Rural Towns')

INSERT INTO Vacation_Interest
VALUES(324, 'Warm Weather')

INSERT INTO Vacation_Interest
VALUES(325, 'Beach')

INSERT INTO Vacation_Interest
VALUES(326, 'Winter')

INSERT INTO Vacation_Interest
VALUES(327, 'Coastal Town')

INSERT INTO Vacation_Interest
VALUES(328,'Urban Areas')

INSERT INTO Vacation_Interest
VALUES(329,'Food Scenes')

INSERT INTO Vacation_Interest
VALUES(3210,'College Town')

/*INSERT INTO PERSON_VACATION_INTEREST*/

INSERT INTO PERSON_VACATION_INTEREST
VALUES(1,321)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(2, 322)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(3, 323)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(4, 324)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(5, 325)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(6, 326)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(7, 327)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(8, 328)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(9, 329)

INSERT INTO PERSON_VACATION_INTEREST
VALUES(10, 3210)

/*INSERT INTO COUNTRY*/

INSERT INTO COUNTRY
VALUES(1111, 'FRANCE')

INSERT INTO COUNTRY
VALUES(1112, 'KENYA')

INSERT INTO COUNTRY
VALUES(1113, 'BURMA')

INSERT INTO COUNTRY
VALUES(1114, 'THAILAND')

INSERT INTO COUNTRY
VALUES(1115, 'PERU')

/*INSERT INTO ATTRACTION*/

INSERT INTO ATTRACTION
VALUES(11111, 214.2, 'swimming', 'LAKE')

INSERT INTO ATTRACTION
VALUES(11112, 1000.4, 'going into safari', 'WILD')

INSERT INTO ATTRACTION
VALUES(11113, 400, 'using kayaks', 'KAYAKING')

INSERT INTO ATTRACTION
VALUES(11114, 600, 'going in boats', 'OCEAN')

INSERT INTO ATTRACTION
VALUES(11115, 214.2, 'hiking', 'MOUNTAINS')

/*INSERT INTO CUSTOM BOOKIGNS*/

INSERT INTO Custom_Bookings
VALUES(111111, 6)

INSERT INTO Custom_Bookings
VALUES(111112, 7)

INSERT INTO Custom_Bookings
VALUES(111113, 8)

INSERT INTO Custom_Bookings
VALUES(111114, 9)

INSERT INTO Custom_Bookings
VALUES(111115, 10)

/*INSERT INTO Service_s*/


INSERT INTO Travel_Services
VALUES(1,12.5, 111)

INSERT INTO Travel_Services
 
VALUES(2,12.5, 112)

INSERT INTO Travel_Services
VALUES(3,12.5, 113)

INSERT INTO Travel_Services
VALUES(4,12.5, 114)

INSERT INTO Travel_Services
VALUES(5,12.5, 115)

/*INSERT INTO Vacation_Package*/


INSERT Vacation_Package
VALUES(11111111, 'Fun boat ride', 'Day Trip Fun 1', '2021-08-12', '2021-08-26', 'Tampa',150,'Paris')

INSERT INTO Vacation_Package
VALUES(11111112, 'Romantic Adventure', 'Day Trip Fun 2', '2021-12-12', '2021-12-19', 'Paris',350,'Las Vegas')

INSERT INTO Vacation_Package
VALUES(11111113, 'Family funtime', 'Day Trip Fun 3', '2021-12-12', '2021-12-19', 'Tampa',750,'Madrid')

INSERT INTO Vacation_Package
VALUES(11111114, 'EatPrayLove', 'Day Trip Fun 4', '2021-12-12', '2021-12-19', 'Madrid',850,'New York')

INSERT INTO Vacation_Package
VALUES(11111115, 'Adrenaline Rush', 'Day Trip Fun 5', '2021-12-12', '2021-12-19', 'Tampa',950,'San Diego')

/*INSERT INTO GEO_VACATION_PACKAGE*/

INSERT INTO GEO_VACATION_PACKAGE
VALUES(1, 11111111)

INSERT INTO GEO_VACATION_PACKAGE
VALUES(2, 11111112)

INSERT INTO GEO_VACATION_PACKAGE
VALUES(3, 11111113)

INSERT INTO GEO_VACATION_PACKAGE
VALUES(4, 11111114)

INSERT INTO GEO_VACATION_PACKAGE
VALUES(5, 11111115)

/*INSERT INTO HOTEL*/


INSERT INTO HOTEL
VALUES(111, 'Hotel1Street', 'Tampa', '33615', 'USA', '8135642956', 1111)

INSERT INTO HOTEL
VALUES(112, 'Hotel2Street', 'Tampa', '33613', 'USA', '8135642957', 1112)

INSERT INTO HOTEL
VALUES(113, 'Hotel3Street', 'Paris', '33625', 'France', '8135642958', 1113)

INSERT INTO HOTEL
VALUES(114, 'Hotel4Street', 'Orlando', '33458', 'USA', '8135642955', 1114)

INSERT INTO HOTEL
VALUES(115, 'Hotel5Street', 'Miami', '33654', 'USA', '8135642952', 1115)

/*INSERT INTO HOTEL PACKAGE*/

INSERT INTO Hotel_Package
VALUES(111, 11111111, '2021-12-12', '2021-12-19')

INSERT INTO Hotel_Package
VALUES(112, 11111112, '2021-12-12', '2021-12-19')

INSERT INTO Hotel_Package
VALUES(113, 11111113, '2021-12-12', '2021-12-19')

INSERT INTO Hotel_Package
VALUES(114, 11111114, '2021-12-12', '2021-12-19')

INSERT INTO Hotel_Package
VALUES(115, 11111115, '2021-12-12', '2021-12-19')

/*INSERT INTO Air_and_Land*/

INSERT INTO Air_and_Land
VALUES(6911, 'SPIRIT', '2021-12-12', '12:00:00', 'TampaInternational', 'BangladeshI', 111, 11111111)

INSERT INTO Air_and_Land
VALUES(6912, 'Delta', '2021-12-12', '12:00:00', 'OHare', 'Singapore', 112, 11111112)

INSERT INTO Air_and_Land
VALUES(6913, 'SPIRIT', '2021-12-12', '12:00:00', 'TampaInternational', 'England', 113, 11111113)

INSERT INTO Air_and_Land
VALUES(6914, 'Delta', '2021-12-12', '12:00:00', 'TampaInternational', 'India', 114, 11111114)

INSERT INTO Air_and_Land
VALUES(6915, 'SPIRIT', '2021-12-12', '12:00:00', 'TampaInternational', 'Singapore', 115, 11111115)

/*INSERT INTO Vacation_Package_Attraction*/

INSERT INTO Vacation_Package_Attraction
VALUES(11111, 11111111, '2021-12-12')

INSERT INTO Vacation_Package_Attraction
VALUES(11112, 11111112, '2021-12-12')

INSERT INTO Vacation_Package_Attraction
VALUES(11113, 11111113, '2021-12-12')

INSERT INTO Vacation_Package_Attraction
VALUES(11114, 11111114, '2021-12-12')

INSERT INTO Vacation_Package_Attraction
VALUES(11115, 11111115, '2021-12-12')

/*INSERT INTO Vacation_Package_Country*/

INSERT INTO Vacation_Package_Country
VALUES(1111, 11111111)

INSERT INTO Vacation_Package_Country
VALUES(1112, 11111112)

INSERT INTO Vacation_Package_Country
VALUES(1113, 11111113)

INSERT INTO Vacation_Package_Country
VALUES(1114, 11111114)

INSERT INTO Vacation_Package_Country
VALUES(1115, 11111115)

/*INSERT INTO CUSTOM_BOOKING_ATTRACTION*/

INSERT INTO CUSTOM_BOOKING_ATTRACTION
VALUES(11111, 111111)

INSERT INTO CUSTOM_BOOKING_ATTRACTION
VALUES(11112, 111112)

INSERT INTO CUSTOM_BOOKING_ATTRACTION
VALUES(11113, 111113)

INSERT INTO CUSTOM_BOOKING_ATTRACTION
VALUES(11114, 111114)

INSERT INTO CUSTOM_BOOKING_ATTRACTION
VALUES(11115, 111115)

/*INSERT INTO CUSTOM_BOOKINGS_HOTEL*/

INSERT INTO CUSTOM_BOOKINGS_HOTEL
VALUES(111, 111111)

INSERT INTO CUSTOM_BOOKINGS_HOTEL
VALUES(112, 111112)

INSERT INTO CUSTOM_BOOKINGS_HOTEL
VALUES(113, 111113)

INSERT INTO CUSTOM_BOOKINGS_HOTEL
VALUES(114, 111114)

INSERT INTO CUSTOM_BOOKINGS_HOTEL
VALUES(115, 111115)

/*INSERT INTO CUSTOM_BOOKINGS_COUNTRY*/

INSERT INTO CUSTOM_BOOKINGS_COUNTRY
VALUES(1111, 111111)

INSERT INTO CUSTOM_BOOKINGS_COUNTRY
VALUES(1112, 111112)

INSERT INTO CUSTOM_BOOKINGS_COUNTRY
VALUES(1113, 111113)

INSERT INTO CUSTOM_BOOKINGS_COUNTRY
VALUES(1114, 111114)

INSERT INTO CUSTOM_BOOKINGS_COUNTRY
VALUES(1115, 111115)

/*---------------------------SELECTS------------------------------*/

USE TravelAgency15


--1. A list of clients who purchased a certain vacation package (for example, all clients who purchased a vacation to France)
SELECT C.ClientID,APC.PackageID,CT.CountryName
FROM CLIENT AS C
FULL JOIN Vacation_Package_Country AS APC
ON ClientID = ClientID
FULL JOIN COUNTRY AS CT
ON CT.CountryID = APC.CountryID
WHERE CountryName = 'France'


--2. A list of travelers who are going on a certain trip (for example, all travelers who are going on a 8 day Paris trip that leaves on March 8). 


SELECT VP.PackageID, C.ClientID AS 'TravelerID', VP.StartDate
FROM Vacation_Package AS VP
FULL JOIN Booking AS BK
ON VP.PackageID = BK.PackageID
FULL JOIN CLIENT AS C
ON BK.ClientID = C.ClientID
FULL JOIN PERSON AS P
ON C.ClientID = P.PersonID
FULL JOIN TRAVELER AS T
ON T.TravelerID = P.PersonID
WHERE DATEDIFF(DAY, VP.StartDate, VP.EndDate) = 7

--3. A list of all vacation packages of a certain type or to a certain geographic destination (for example, all vvacation packages to Africa, or all romantic vacation packages)

SELECT VP.PackageID, CT.CountryID, CT.CountryName, VP.VacationPackageDescription 
FROM Vacation_Package AS VP
FULL JOIN Vacation_Package_Country AS VPC
ON VP.PackageID = VPC.PackageID
FULL JOIN Country AS CT
ON CT.CountryID = VPC.CountryID
WHERE CountryName = 'PERU'



--4. An invoice listing all travel planning services and products purchased by a certain client for a certain custom trip. 

SELECT CBK.CustomBookingID, TS.ServiceID, TS.ServiceFee, CBH.HotelID, CBA.AttractionID,CBC.CountryID
FROM Travel_Services AS TS
FULL JOIN Booking AS BK
ON TS.BookingID = BK.BookingID 
FULL JOIN Custom_Bookings AS CBK
ON CBK.ClientID = BK.ClientID
FULL JOIN CUSTOM_BOOKINGS_HOTEL AS CBH
ON CBK.CustomBookingID = CBH.CustomBookingID
FULL JOIN CUSTOM_BOOKING_ATTRACTION AS CBA
ON CBK.CustomBookingID = CBA.CustomBookingID
FULL JOIN CUSTOM_BOOKINGS_COUNTRY AS CBC
ON CBK.CustomBookingID = CBC.CustomBookingID
WHERE CBK.CustomBookingID = 111113


--5. A list of bookings for a travel agent over a specified period of time (for example November 2021) and/or overall. 

SELECT BK.AgentID, MT.ConsultDate, PS.PersonFN AS 'Travel Agent Name'
FROM Booking AS BK
FULL JOIN MEETING AS MT
ON MT.AgentID = BK.AgentID
FULL JOIN TRAVEL_AGENT AS TA
ON TA.AgentID = MT.AgentID
FULL JOIN PERSON AS PS
ON TA.AgentID = PS.PersonID
WHERE MONTH(MT.ConsultDate) = 12


--6. A list in of available trips for certain dates displaying the name of the vacation package, brief description, departure and arrival dates, departure city and price.

SELECT *
FROM Vacation_Package
WHERE StartDate = '2021-08-12' OR StartDate = '2021-12-12'


--7. A list of all hotels used for a specific vacation package and their full addresses (including country). You should display the name of the package as well.


SELECT HT.HotelID,HotelStreet,HotelCity,HotelZip,HotelCountry,VP.PackageID,VacationPackageItinerary as'Vacation Package Name'
FROM HOTEL AS HT
FULL JOIN Hotel_Package AS HP
ON HP.HotelID = HT.HotelID
FULL JOIN Vacation_Package AS VP
ON HP.PackageID = VP.PackageID
WHERE VP.PackageID = 11111114
ORDER BY HT.HotelID

--8. A list of available additional tours or services that can be purchased for a certain vacation package or destination

SELECT AT.AttractionID, AttractionPrice, AttractionDetail, AttractionName, Destination, VP.PackageID
FROM Vacation_Package AS VP
FULL JOIN Vacation_Package_Attraction AS VPA
ON VP.PackageID = VPA.PackageID
FULL JOIN ATTRACTION AS AT
ON VPA.AttractionID = AT.AttractionID
ORDER BY VP.Destination

--9. A list of all subscribers with their names and email addresses who are interested in a certain type of vacation (for example, everyone who likes cities vacations, so they can be contacted about a new ‘cities’ package).

SELECT VI.InterestID, InterestType, PS.PersonID AS 'SubscriberID', PersonFN AS 'SubscriberFN', PersonLN AS 'SubscriberLN', PersonEmail AS 'Subscriber Email'
FROM Vacation_Interest AS VI
JOIN PERSON_VACATION_INTEREST AS PVI
ON PVI.InterestID = VI.InterestID
JOIN PERSON AS PS
ON PVI.PersonID = PS.PersonID

--10. A list of all travelers departing in a certain month (for example November 2021) showing the names of the travelers, vacation package purchase, and departure and return dates. 


SELECT VP.PackageID, C.ClientID AS 'TravelerID', P.PersonFN AS 'Traveler FN',P.PersonLN AS 'Traveler LN', Price 'Vacation Package Purchase', StartDate 'Departure Date', EndDate 'Return Date'
FROM Vacation_Package AS VP
FULL JOIN Booking AS BK
ON VP.PackageID = BK.PackageID
FULL JOIN CLIENT AS C
ON BK.ClientID = C.ClientID
FULL JOIN PERSON AS P
ON C.ClientID = P.PersonID
FULL JOIN TRAVELER AS T
ON T.TravelerID = P.PersonID
WHERE MONTH(StartDate) = 12
ORDER BY 'TravelerID' 


--11. List all passport information with AirlineTicket Date for specific month(eg.October). Include Traveler ID + other ticket info

SELECT PassportID, IssueDate, ExpiryDate, CountryIssued, AT.TravelerID, TicketID, TicketDate, Ticket_Airline_Name
FROM PASSPORT AS PP
FULL JOIN AIRLINE_TICKET AS AT
ON PP.TravelerID = AT.TravelerID
WHERE MONTH(TicketDate) = 10

--12. List all interest IDs and sort by personID in descending order

SELECT *
FROM Vacation_Interest AS VI
JOIN PERSON_VACATION_INTEREST AS PVI
ON VI.InterestID = PVI.InterestID
JOIN PERSON AS P
ON PVI.PersonID = P.PersonID
ORDER BY PVI.PersonID DESC 


--13. List every clients that each travel agents have meetings set up with and their respective client's name?

SELECT C.ClientID, PersonFN AS 'Client FN', PersonLN AS 'Client LN', TA.AgentID
FROM PERSON
JOIN CLIENT AS C
ON C.ClientID = PersonID
FULL JOIN MEETING AS MT
ON MT.ClientID = C.ClientID
FULL JOIN TRAVEL_AGENT AS TA
ON MT.AgentID = TA.AgentID


SELECT *
FROM COUNTRY
SELECT *
FROM HOTEL
SELECT *
FROM Hotel_Package

--List the Check In Dates of Hotel Packages in France

SELECT HP.HotelID, CT.CountryID, CountryName, CheckInDate, H.HotelPhone
FROM COUNTRY AS CT
FULL JOIN HOTEL AS H
ON H.CountryID=CT.CountryID
FULL JOIN Hotel_Package AS HP
ON H.HotelID = HP.HotelID
WHERE CountryName = 'France'