-- Create a database
CREATE DATABASE Home4AlliNeed;

-- Use the database
\c Home4AlliNeed;


-- Create the MortgageOfficer table
CREATE TABLE MortgageOfficer (
    officerID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY ,
    firstName VARCHAR(255),
    middleName VARCHAR(255),
    lastName VARCHAR(255),
    authorityLevel INT CHECK (authorityLevel IN (1, 2, 3, 4, 5)),
    role VARCHAR(255) CHECK (role IN ('admin', 'officer')),
    hireDate DATE
);

INSERT INTO MortgageOfficer (firstName, middleName, lastName, authorityLevel, role, hireDate)
VALUES 
('John', 'A.', 'Doe', 3, 'officer', '2022-06-15'),
('Jane', 'B.', 'Smith', 4, 'admin', '2021-09-20'),
('Alice', 'C.', 'Johnson', 2, 'officer', '2023-02-01');



-- Create the Client table
CREATE TABLE Client (
    clientID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    firstName VARCHAR(255),
    middleName VARCHAR(255),
    lastName VARCHAR(255),
    creditRating INT CHECK (creditRating IN (1, 2, 3, 4, 5)),
    employmentStatus VARCHAR(255) CHECK (employmentStatus IN ('employed', 'self-employed', 'unemployed', 'student')),
    nationality VARCHAR(255),
    maritalStatus VARCHAR(255),
    gender VARCHAR(255) CHECK (gender IN ('male', 'female', 'other')),
    annualIncome FLOAT,
    dateOfBirth DATE
);
INSERT INTO Client (firstName, middleName, lastName, creditRating, employmentStatus, nationality, maritalStatus, gender, annualIncome, dateOfBirth)
VALUES 
('Michael', 'T.', 'Brown', 5, 'employed', 'USA', 'married', 'male', 75000, '1980-01-15'),
('Sarah', 'L.', 'Davis', 4, 'self-employed', 'Canada', 'single', 'female', 65000, '1990-03-25'),
('Daniel', 'P.', 'Lee', 3, 'student', 'UK', 'single', 'male', 15000, '2001-07-10');



-- Create the Property table
CREATE TABLE Property (
    propertyID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    propertyType VARCHAR(255),
    numberOfBedrooms INT,
    numberOfBathrooms INT,
    numberOfFloors INT,
    yearBuilt INT,
    condition VARCHAR(255),
    askingPrice FLOAT,
    listingDate DATE
);
INSERT INTO Property (propertyType, numberOfBedrooms, numberOfBathrooms, numberOfFloors, yearBuilt, condition, askingPrice, listingDate)
VALUES 
('Apartment', 2, 1, 1, 2005, 'Good', 250000, '2024-01-01'),
('Villa', 4, 3, 2, 2015, 'Excellent', 500000, '2023-11-15'),
('Townhouse', 3, 2, 2, 1999, 'Fair', 300000, '2024-02-10');


-- Create the MortgageProduct table
CREATE TABLE MortgageProduct (
    mortgageProductID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    productName VARCHAR(255),
    dateCreated DATE,
    interestRate FLOAT,
    productType VARCHAR(255)
);
INSERT INTO MortgageProduct (productName, dateCreated, interestRate, productType)
VALUES 
('Fixed-Rate Mortgage', '2023-01-01', 3.5, 'fixed'),
('Adjustable-Rate Mortgage', '2022-08-01', 2.8, 'variable'),
('Interest-Only Mortgage', '2023-05-10', 3.0, 'interest-only');


-- Create the Address table
CREATE TABLE Address (
    addressID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    clientID INT REFERENCES Client(clientID),
    propertyID INT REFERENCES Property(propertyID),
    MortgageOfficer INT REFERENCES MortgageOfficer(officerID),
    streetAddress VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postalCode VARCHAR(255),
    country VARCHAR(255),
    addressType VARCHAR(255) CHECK (addressType IN ('home', 'work', 'other')),
    isPrimary BOOLEAN
);
INSERT INTO Address (clientID, propertyID, MortgageOfficer, streetAddress, city, state, postalCode, country, addressType, isPrimary)
VALUES 
(1, 1, 1, '123 Main St', 'New York', 'NY', '10001', 'USA', 'home', TRUE),
(2, 2, 2, '456 Maple Ave', 'Toronto', 'ON', 'M4B1B3', 'Canada', 'work', FALSE),
(3, 3, 3, '789 Oak Dr', 'London', '', 'E15 4QT', 'UK', 'home', TRUE);


-- Create the ContactDetails table
CREATE TABLE ContactDetails (
    contactID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    clientID INT REFERENCES Client(clientID),
    officerID INT REFERENCES MortgageOfficer(officerID),
    phoneNumber VARCHAR(255),
    email VARCHAR(255),
    contactType VARCHAR(255) CHECK (contactType IN ('home', 'work', 'mobile', 'other')),
    isPrimary BOOLEAN
);
INSERT INTO ContactDetails (clientID, officerID, phoneNumber, email, contactType, isPrimary)
VALUES 
(1, 1, '+1-555-1234', 'john.doe@example.com', 'home', TRUE),
(2, 2, '+1-416-5678', 'jane.smith@example.ca', 'mobile', TRUE),
(3, 3, '+44-20-9876', 'alice.johnson@example.co.uk', 'work', FALSE);


-- Create the Approvals table
CREATE TABLE Approvals (
    approvalID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    mortgageApplicationID INT REFERENCES MortgageApplication(mortgageApplicationID),
    approvalDate DATE,
    approvedBy INT REFERENCES MortgageOfficer(officerID),
    comments VARCHAR(255)
);
INSERT INTO Approvals (mortgageApplicationID, approvalDate, approvedBy, comments)
VALUES 
(1, '2023-11-30', 1, 'Approved for standard terms.'),
(2, '2024-01-15', 2, 'Requires additional documentation.'),
(3, '2023-12-10', 3, 'Pre-approved for lower loan amount.');


-- Create the Valuation table
CREATE TABLE Valuation (
    valuationID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    propertyID INT REFERENCES Property(propertyID),
    officerID INT REFERENCES MortgageOfficer(officerID),
    valuationAmount FLOAT,
    valuationDate DATE,
    valuationType VARCHAR(255) CHECK (valuationType IN ('initial', 'revaluation')),
    comments VARCHAR(255)
);
INSERT INTO Valuation (propertyID, officerID, valuationAmount, valuationDate, valuationType, comments)
VALUES 
(1, 1, 260000, '2023-12-01', 'initial', 'Valuation looks accurate.'),
(2, 2, 480000, '2023-11-25', 'revaluation', 'Market conditions updated.'),
(3, 3, 290000, '2024-01-10', 'initial', 'Minor repair costs included.');


-- Create the Insurance table
CREATE TABLE Insurance (
    insuranceID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    approvalID INT REFERENCES Approvals(approvalID),
    propertyID INT REFERENCES Property(propertyID),
    insuranceProvider VARCHAR(255),
    policyNumber VARCHAR(255),
    coverageAmount FLOAT,
    startDate DATE,
    endDate DATE,
    premiumAmount FLOAT,
    coverageType VARCHAR(255) CHECK (coverageType IN ('basic', 'comprehensive', 'liability'))
);
INSERT INTO Insurance (approvalID, propertyID, insuranceProvider, policyNumber, coverageAmount, startDate, endDate, premiumAmount, coverageType)
VALUES 
(1, 1, 'Allied Insurance', 'POL12345', 250000, '2024-01-01', '2025-01-01', 1200, 'basic'),
(2, 2, 'Guardian Insurance', 'POL67890', 500000, '2023-11-15', '2024-11-15', 2000, 'comprehensive'),
(3, 3, 'National Cover', 'POL54321', 300000, '2024-02-01', '2025-02-01', 1500, 'liability');


-- Create the ComplianceCheck table
CREATE TABLE ComplianceCheck (
    complianceID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    mortgageApplicationID INT REFERENCES MortgageApplication(mortgageApplicationID),
    officerID INT REFERENCES MortgageOfficer(officerID),
    checkDate DATE,
    status VARCHAR(255),
    comments VARCHAR(255),
    checkType VARCHAR(255) CHECK (checkType IN ('regulatory check', 'credit check', 'affordability assessment')),
    result VARCHAR(255),
    nextCheckDate DATE,
    severityLevel INT CHECK (severityLevel IN (1, 2, 3, 4, 5))
);
INSERT INTO ComplianceCheck (mortgageApplicationID, officerID, checkDate, status, comments, checkType, result, nextCheckDate, severityLevel)
VALUES 
(1, 1, '2023-11-29', 'completed', 'No issues found.', 'credit check', 'pass', '2024-02-28', 1),
(2, 2, '2023-12-05', 'pending', 'Additional info needed.', 'regulatory check', 'pending', '2024-03-05', 3),
(3, 3, '2024-01-01', 'completed', 'Minor discrepancies noted.', 'affordability assessment', 'pass', '2024-04-01', 2);


-- Create the MortgageApplication table
CREATE TABLE MortgageApplication (
    mortgageApplicationID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    clientID INT REFERENCES Client(clientID),
    propertyID INT REFERENCES Property(propertyID),
    mortgageProductID INT REFERENCES MortgageProduct(mortgageProductID),
    status VARCHAR(255),
    applicationDate DATE,
    loanAmount FLOAT,
    depositAmount FLOAT,
    note VARCHAR(255),
    preferredRate INT
);
INSERT INTO MortgageApplication (clientID, propertyID, mortgageProductID, status, applicationDate, loanAmount, depositAmount, note, preferredRate)
VALUES 
(1, 1, 1, 'approved', '2023-10-15', 200000, 50000, 'Standard application', 3),
(2, 2, 2, 'pending', '2023-11-01', 400000, 80000, 'Awaiting documents', 4),
(3, 3, 3, 'rejected', '2023-12-05', 150000, 30000, 'Credit score too low', 2);


-- Create the RepaymentTerms table
CREATE TABLE RepaymentTerms (
    repaymentTermID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    mortgageProductID INT REFERENCES MortgageProduct(mortgageProductID),
    termType VARCHAR(255) CHECK (termType IN ('fixed', 'variable')),
    termLength INT,
    termDescription VARCHAR(255),
    maximumLoanAmount FLOAT,
    minimumLoanAmount FLOAT
);
INSERT INTO RepaymentTerms (mortgageProductID, termType, termLength, termDescription, maximumLoanAmount, minimumLoanAmount)
VALUES 
(1, 'fixed', 30, 'Fixed term of 30 years', 500000, 50000),
(2, 'variable', 15, 'Variable rate term of 15 years', 400000, 75000),
(3, 'fixed', 20, 'Fixed term of 20 years', 300000, 100000);



-- Create the InterestRateChange table
CREATE TABLE InterestRateChange (
    changeID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    mortgageProductID INT REFERENCES MortgageProduct(mortgageProductID),
    oldInterestRate FLOAT,
    newInterestRate FLOAT,
    changeDate DATE,
    reasonForChange VARCHAR(255),
    approvedBy INT REFERENCES MortgageOfficer(officerID)
);
INSERT INTO InterestRateChange (mortgageProductID, oldInterestRate, newInterestRate, changeDate, reasonForChange, approvedBy)
VALUES 
(1, 3.5, 3.6, '2023-09-15', 'Market adjustment', 1),
(2, 2.8, 3.0, '2023-11-20', 'Bank policy update', 2),
(3, 3.0, 2.9, '2024-01-10', 'Economic conditions', 3);



-- Create the LoanStatus table
CREATE TABLE LoanStatus (
    statusID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    approvalID INT REFERENCES Approvals(approvalID),
    statusDate DATE,
    statusDescription VARCHAR(255),
    status VARCHAR(255) CHECK (status IN ('active', 'defaulted', 'closed'))
);
INSERT INTO LoanStatus (approvalID, statusDate, statusDescription, status)
VALUES 
(1, '2023-12-01', 'Loan is active and in good standing.', 'active'),
(2, '2024-01-05', 'Loan has been closed successfully.', 'closed'),
(3, '2023-11-20', 'Loan is overdue; follow-up needed.', 'defaulted');


-- Create the paymentSchedule table
CREATE TABLE paymentSchedule (
    scheduleID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    approvalID INT REFERENCES Approvals(approvalID),
    paymentDate DATE,
    paymentAmount FLOAT,
    dueDate DATE,
    paymentStatus VARCHAR(255) CHECK (paymentStatus IN ('pending', 'completed', 'overdue')),
    paymentMethod VARCHAR(255) CHECK (paymentMethod IN ('bank transfer', 'credit card', 'debit card', 'cash'))
);
INSERT INTO paymentSchedule (approvalID, paymentDate, paymentAmount, dueDate, paymentStatus, paymentMethod)
VALUES 
(1, '2023-12-05', 1500, '2023-12-10', 'completed', 'bank transfer'),
(2, '2024-01-15', 2000, '2024-01-20', 'pending', 'credit card'),
(3, '2024-02-01', 1000, '2024-02-05', 'overdue', 'cash');


-- Create the Payments table
CREATE TABLE Payments (
    paymentID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    scheduleID INT REFERENCES paymentSchedule(scheduleID),
    clientID INT REFERENCES Client(clientID),
    paymentDate DATE,
    paymentAmount FLOAT,
    paymentStatus VARCHAR(255) CHECK (paymentStatus IN ('pending', 'completed', 'failed')),
    paymentMethod VARCHAR(255) CHECK (paymentMethod IN ('bank transfer', 'credit card', 'debit card', 'cash')),
    transactionID VARCHAR(255)
);
INSERT INTO Payments (scheduleID, clientID, paymentDate, paymentAmount, paymentStatus, paymentMethod, transactionID)
VALUES 
(1, 1, '2023-12-06', 1500, 'completed', 'bank transfer', 'TRX12345'),
(2, 2, '2024-01-16', 2000, 'pending', 'credit card', 'TRX67890'),
(3, 3, '2024-02-02', 1000, 'failed', 'cash', 'TRX54321');


-- Create the extraPayment table
CREATE TABLE extraPayment (
    extraPaymentID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    paymentScheduleID INT REFERENCES paymentSchedule(scheduleID),
    LoanStatusID INT REFERENCES LoanStatus(statusID),
    paymentDate DATE,
    paymentAmount FLOAT,
    reason VARCHAR(255)
);
INSERT INTO extraPayment (paymentScheduleID, LoanStatusID, paymentDate, paymentAmount, reason)
VALUES 
(1, 1, '2023-12-10', 500, 'Additional principal payment'),
(2, 2, '2024-01-25', 1000, 'Prepayment to reduce interest'),
(3, 3, '2024-02-15', 750, 'Payment to cover overdue balance');


-- Create the ApplicationStatus table
CREATE TABLE ApplicationStatus (
    statusID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    mortgageApplicationID INT REFERENCES MortgageApplication(mortgageApplicationID),
    statusDate DATE,
    status VARCHAR(255) CHECK (status IN ('approved', 'rejected', 'pending', 'cancelled', 'in review', 'negotiate', 'escalated')),
    statusDescription VARCHAR(255),
    updatedBy INT REFERENCES MortgageOfficer(officerID),
    lastUpdated TIMESTAMP
);
INSERT INTO ApplicationStatus (mortgageApplicationID, statusDate, status, statusDescription, updatedBy, lastUpdated)
VALUES 
(1, '2023-10-20', 'approved', 'Application successfully approved.', 1, '2023-10-20 12:30:00'),
(2, '2023-11-05', 'pending', 'Waiting for client documents.', 2, '2023-11-05 14:00:00'),
(3, '2023-12-10', 'rejected', 'Rejected due to low credit rating.', 3, '2023-12-10 09:00:00');



-- Create the AuditLog table
CREATE TABLE AuditLog (
    auditID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    tableName VARCHAR(255),
    operationType VARCHAR(255),
    operationDate TIMESTAMP,
    userID INT REFERENCES MortgageOfficer(officerID),
    details VARCHAR(255),
    ipAddress VARCHAR(255)
);
INSERT INTO AuditLog (tableName, operationType, operationDate, userID, details, ipAddress)
VALUES 
('Client', 'INSERT', '2023-12-01 10:15:00', 1, 'Added new client record.', '192.168.1.1'),
('Property', 'UPDATE', '2023-12-10 15:45:00', 2, 'Updated property details.', '192.168.1.2'),
('MortgageProduct', 'DELETE', '2024-01-05 09:30:00', 3, 'Removed discontinued product.', '192.168.1.3');

 