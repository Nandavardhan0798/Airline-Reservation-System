-- Airline Reservation System Database

-- Step 1: Create Database
CREATE DATABASE AirlineReservation;
USE AirlineReservation;

-- Step 2: Create Tables

-- Airlines Table
CREATE TABLE Airlines (
    AirlineID INT PRIMARY KEY AUTO_INCREMENT,
    AirlineName VARCHAR(100) NOT NULL
);

-- Flights Table
CREATE TABLE Flights (
    FlightID INT PRIMARY KEY AUTO_INCREMENT,
    AirlineID INT,
    FlightNumber VARCHAR(10) UNIQUE NOT NULL,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    TotalSeats INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID) ON DELETE CASCADE
);

-- Passengers Table
CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    PassportNumber VARCHAR(20) UNIQUE NOT NULL
);

-- Bookings Table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    PassengerID INT,
    FlightID INT,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    SeatNumber VARCHAR(5),
    Status ENUM('Confirmed', 'Cancelled') DEFAULT 'Confirmed',
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID) ON DELETE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID) ON DELETE CASCADE
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer') NOT NULL,
    Status ENUM('Completed', 'Pending', 'Failed') DEFAULT 'Completed',
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

-- Step 3: Insert Sample Data

INSERT INTO Airlines (AirlineName) VALUES ('Air India'), ('Emirates'), ('Lufthansa');

INSERT INTO Flights (AirlineID, FlightNumber, Origin, Destination, DepartureTime, ArrivalTime, TotalSeats, Price) VALUES
(1, 'AI101', 'Delhi', 'New York', '2025-03-01 06:00:00', '2025-03-01 18:30:00', 300, 800.00),
(2, 'EK202', 'Dubai', 'London', '2025-03-02 08:00:00', '2025-03-02 12:00:00', 350, 600.00);

INSERT INTO Passengers (FirstName, LastName, Email, PhoneNumber, PassportNumber) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', 'A1234567'),
('Jane', 'Smith', 'jane.smith@example.com', '9876543210', 'B7654321');

INSERT INTO Bookings (PassengerID, FlightID, SeatNumber) VALUES
(1, 1, '12A'),
(2, 2, '7B');

INSERT INTO Payments (BookingID, Amount, PaymentMethod) VALUES
(1, 800.00, 'Credit Card'),
(2, 600.00, 'PayPal');

-- Step 4: Essential Queries

-- Get available flights between two cities
SELECT * FROM Flights WHERE Origin = 'Delhi' AND Destination = 'New York';

-- Get passenger booking details
SELECT p.FirstName, p.LastName, b.BookingID, f.FlightNumber, f.Origin, f.Destination, b.SeatNumber, b.Status
FROM Passengers p
JOIN Bookings b ON p.PassengerID = b.PassengerID
JOIN Flights f ON b.FlightID = f.FlightID
WHERE p.Email = 'john.doe@example.com';

-- Cancel a booking
UPDATE Bookings SET Status = 'Cancelled' WHERE BookingID = 1;

-- Check payment status for a booking
SELECT * FROM Payments WHERE BookingID = 1;
