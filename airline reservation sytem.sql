create database flight_and_booking;
use flight_and_booking;
CREATE TABLE Flights (
flight_id INT AUTO_INCREMENT PRIMARY KEY,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);
CREATE TABLE Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT,
    seat_number VARCHAR(5),
    class VARCHAR(20),
    is_booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    flight_id INT,
    seat_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);
INSERT INTO Flights (flight_id, origin, destination, departure_time, arrival_time, price)
VALUES ('2560', 'Mumbai', 'Delhi', '2025-07-20 09:00:00', '2025-07-20 11:30:00','25000');

INSERT INTO Customers (full_name, email, phone)
VALUES ('Rahul Sharma', 'rahul@example.com', '9876543210');

INSERT INTO Seats (flight_id, seat_number, class)    
VALUES (1, '12A', 'Economy'), (1, '12B', 'Economy'), (1, '1A', 'Business');

INSERT INTO Bookings (customer_id, flight_id, seat_id)
VALUES (1, 1, 1);
UPDATE Seats SET is_booked = TRUE WHERE seat_id = 1;






