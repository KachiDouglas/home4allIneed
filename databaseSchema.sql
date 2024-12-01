-- Create a database called "Home4AlliNeed"
CREATE DATABASE Home4AlliNeed;
GO

-- Use the newly created database
USE Home4AlliNeed;
GO

-- Create the MortgageOfficer table
CREATE TABLE MortgageOfficer (
    officerID INT PRIMARY KEY,
    firstName VARCHAR(255),
    middleName VARCHAR(255),
    lastName VARCHAR(255),
    authorityLevel INT,
    role VARCHAR(255),
    hireDate DATE,
    CHECK (authorityLevel IN (1, 2, 3, 4, 5)),
    CHECK (role IN ("admin", "officer"))
);
GO

-- Create the Client table
CREATE TABLE Client (
    clientID INT PRIMARY KEY,
    firstName VARCHAR(255),
    middleName VARCHAR(255),
    lastName VARCHAR(255),
    creditRating INT,
    employmentStatus VARCHAR(255),
    nationality VARCHAR(255),
    maritalStatus VARCHAR(255),
    gender VARCHAR(255),
    annualIncome FLOAT,
    dateOfBirth DATE
    CHECK (creditRating IN (1, 2, 3, 4, 5)),
    CHECK (employmentStatus IN ('employed', 'self-employed', 'unemployed', 'student')),
    CHECK (gender IN ('male', 'female', 'other'))
);
GO

-- Create the Address table
CREATE TABLE Address (
    addressID INT PRIMARY KEY,
    clientID INT,
    propertyID INT,
    MortgageOfficer INT,
    streetAddress VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postalCode VARCHAR(255),
    country VARCHAR(255),
    addressType VARCHAR(255),
    isPrimary BIT,
    FOREIGN KEY (clientID) REFERENCES Client(clientID),
    FOREIGN KEY (MortgageOfficer) REFERENCES MortgageOfficer(officerID),
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID),
    CHECK (addressType IN ('home', 'work', 'other'))
);
GO


-- Create the ContactDetails table
CREATE TABLE ContactDetails (
    contactID INT PRIMARY KEY,
    clientID INT,
    officerID INT,
    phoneNumber VARCHAR(255),
    email VARCHAR(255),
    contactType VARCHAR(255),
    isPrimary BIT,
    FOREIGN KEY (clientID) REFERENCES Client(clientID),
    FOREIGN KEY (officerID) REFERENCES MortgageOfficer(officerID),
    CHECK (contactType IN ('home', 'work', 'mobile', 'other'))
);
GO



-- Create the Property table
CREATE TABLE Property (
    propertyID INT PRIMARY KEY,
    propertyType VARCHAR(255),
    numberOfBedrooms INT,
    numberOfBathrooms INT,
    numberOfFloors INT,
    yearBuilt INT,
    condition VARCHAR(255),
    askingPrice FLOAT,
    listingDate DATE
);
GO

-- Create the Valuation table
CREATE TABLE Valuation (
    valuationID INT PRIMARY KEY,
    propertyID INT,
    officerID INT,
    valuationAmount FLOAT,
    valuationDate DATE,
    valuationType VARCHAR(255),
    comments VARCHAR(255),
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID),
    FOREIGN KEY (officerID) REFERENCES MortgageOfficer(officerID),
    CHECK (valuationType IN ('initial', 'revaluation'))
);
GO




-- Create the Insurance table
CREATE TABLE Insurance (
    insuranceID INT PRIMARY KEY,
    approvalID INT,
    propertyID INT,
    insuranceProvider VARCHAR(255),
    policyNumber VARCHAR(255),
    coverageAmount FLOAT,
    startDate DATE,
    endDate DATE,
    premiumAmount FLOAT,
    coverageType VARCHAR(255),
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID),
    FOREIGN KEY (approvalID) REFERENCES Approvals(approvalID),
    CHECK (coverageType IN ('basic', 'comprehensive', 'liability'))
);
GO



-- Create the ComplianceCheck table
CREATE TABLE ComplianceCheck (
    complianceID INT PRIMARY KEY,
    mortgageApplicationID INT,
    officerID INT,
    checkDate DATE,
    status VARCHAR(255),
    comments VARCHAR(255),
    checkType VARCHAR(255),
    result VARCHAR(255),
    nextCheckDate DATE,
    severityLevel INT,
    FOREIGN KEY (mortgageApplicationID) REFERENCES MortgageApplication(mortgageApplicationID),
    FOREIGN KEY (officerID) REFERENCES MortgageOfficer(officerID),
    CHECK (checkType IN ('regulatory check','credit check', 'affordability assessment')),
    CHECK (severityLevel IN (1, 2, 3, 4, 5))
);
GO





-- Create the MortgageApplication table
CREATE TABLE MortgageApplication (
    mortgageApplicationID INT PRIMARY KEY,
    clientID INT,
    propertyID INT,
    mortgageProductID INT,
    status VARCHAR(255),
    applicationDate DATE,
    loanAmount FLOAT,
    depositAmount FLOAT,
    note VARCHAR(255),
    preferredRate INT,
    FOREIGN KEY (clientID) REFERENCES Client(clientID),
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID),
    FOREIGN KEY (mortgageProductID) REFERENCES MortgageProduct(mortgageProductID),
);
GO

-- Create the RepaymentTerms table
CREATE TABLE RepaymentTerms (
    repaymentTermID INT PRIMARY KEY,
    mortgageProductID INT,
    termType VARCHAR(255),
    termLength INT,
    termDescription VARCHAR(255),
    maximumLoanAmount FLOAT,
    minimumLoanAmount FLOAT,
    FOREIGN KEY (mortgageProductID) REFERENCES MortgageProduct(mortgageProductID),
    CHECK (termType IN ('fixed', 'variable'))
);
GO


-- Create the MortgageProduct table
CREATE TABLE MortgageProduct (
    mortgageProductID INT PRIMARY KEY,
    productName VARCHAR(255),
    dateCreated DATE,
    interestRate FLOAT,
    productType VARCHAR(255)
);
GO

-- Create the InterestRateChange table
CREATE TABLE InterestRateChange (
    changeID INT PRIMARY KEY,
    mortgageProductID INT,
    oldInterestRate FLOAT,
    newInterestRate FLOAT,
    changeDate DATE,
    reasonForChange VARCHAR(255),
    approvedBy INT,
    FOREIGN KEY (mortgageProductID) REFERENCES MortgageProduct(mortgageProductID),
    FOREIGN KEY (approvedBy) REFERENCES MortgageOfficer(officerID)
);
GO





-- Create the Approvals table
CREATE TABLE Approvals (
    approvalID INT PRIMARY KEY,
    mortgageApplicationID INT,
    approvalDate DATE,
    approvedBy INT,
    comments VARCHAR(255),
    FOREIGN KEY (mortgageApplicationID) REFERENCES MortgageApplication(mortgageApplicationID),
    FOREIGN KEY (approvedBy) REFERENCES MortgageOfficer(officerID),
    FOREIGN KEY (repaymentTermID) REFERENCES RepaymentTerms(repaymentTermID)
);
GO

-- Create the LoanStatus table
CREATE TABLE LoanStatus (
    statusID INT PRIMARY KEY,
    approvalID INT,
    statusDate DATE,
    statusDescription VARCHAR(255),
    status VARCHAR(255),
    FOREIGN KEY (approvalID) REFERENCES Approvals(approvalID),
    CHECK (status IN ('active', 'defaulted', 'closed'))
);
GO


-- Create the paymentSchedule table
CREATE TABLE paymentSchedule (
    scheduleID INT PRIMARY KEY,
    approvalID INT,
    paymentDate DATE,
    paymentAmount FLOAT,
    dueDate DATE,
    paymentStatus VARCHAR(255),
    paymentMethod VARCHAR(255),
    FOREIGN KEY (approvalID) REFERENCES Approvals(approvalID),
    CHECK (paymentStatus IN ('pending', 'completed', 'overdue')),
    CHECK (paymentMethod IN ('bank transfer', 'credit card', 'debit card', 'cash'))
);
GO




-- Create the Payments table
CREATE TABLE Payments (
    paymentID INT PRIMARY KEY,
    scheduleID INT,
    clientID INT,
    paymentDate DATE,
    paymentAmount FLOAT,
    paymentStatus VARCHAR(255),
    paymentMethod VARCHAR(255),
    transactionID VARCHAR(255),
    FOREIGN KEY (scheduleID) REFERENCES paymentSchedule(scheduleID),
    FOREIGN KEY (clientID) REFERENCES Client(clientID),
    CHECK (paymentStatus IN ('pending', 'completed', 'failed')),
    CHECK (paymentMethod IN ('bank transfer', 'credit card', 'debit card', 'cash'))
);
GO


-- Create the extraPayment table
CREATE TABLE extraPayment (
    extraPaymentID INT PRIMARY KEY,
    paymentScheduleID INT,
    LoanStatusID INT,
    paymentDate DATE,
    paymentAmount FLOAT,
    reason VARCHAR(255),
    FOREIGN KEY (paymentScheduleID) REFERENCES paymentSchedule(scheduleID),
    FOREIGN KEY (LoanStatusID) REFERENCES LoanStatus(statusID)
);
GO

-- Create the ApplicationStatus table
CREATE TABLE ApplicationStatus (
    statusID INT PRIMARY KEY,
    mortgageApplicationID INT,
    statusDate DATE,
    status VARCHAR(255),
    statusDescription VARCHAR(255),
    updatedBy INT,
    lastUpdated DATETIME,
    FOREIGN KEY (mortgageApplicationID) REFERENCES MortgageApplication(mortgageApplicationID),
    FOREIGN KEY (updatedBy) REFERENCES MortgageOfficer(officerID),
    CHECK (status IN ('approved', 'rejected', 'pending', 'cancelled', 'in review', 'negotiate', 'escalated'))
);
GO


CREATE TABLE AuditLog (
    auditID INT PRIMARY KEY,
    tableName VARCHAR(255),
    operationType VARCHAR(255),
    operationDate timestamp,
    userID INT,
    details VARCHAR(255),
    ipAddress VARCHAR(255),
    FOREIGN KEY (userID) REFERENCES MortgageOfficer(officerID)
);
GO

