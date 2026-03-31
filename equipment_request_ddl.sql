-- =============================================
-- Clinton County IT Loaner & Surplus System
-- DDL for SQL Server (matches existing EF Core models)
-- =============================================

-- =============================================
-- EXISTING TABLES (already in your database)
-- Only run these if starting from scratch
-- =============================================

-- Departments (matches your Department.cs)
CREATE TABLE Department (
    DepartmentId    INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName  NVARCHAR(50)  NOT NULL,
    LocationName    NVARCHAR(50)  NOT NULL
);

-- Requests / Requesters (matches your Request.cs)
CREATE TABLE Request (
    RequestId       INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(50)  NOT NULL,
    Email           NVARCHAR(50)  NOT NULL,
    Phone           NVARCHAR(20)  NULL,
    Needs           NVARCHAR(100) NULL
);

-- Loan Tickets (matches your LoanTicket.cs)
CREATE TABLE LoanTicket (
    LoanTicketId    INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentId    INT NULL,
    RequestId       INT NULL,
    TermLength      NVARCHAR(50)  NULL,
    Status          NVARCHAR(20)  DEFAULT 'Pending',
    SubmittedDate   DATETIME2     DEFAULT GETDATE(),

    CONSTRAINT FK_LoanTicket_Department FOREIGN KEY (DepartmentId)
        REFERENCES Department(DepartmentId)
        ON DELETE SET NULL,

    CONSTRAINT FK_LoanTicket_Request FOREIGN KEY (RequestId)
        REFERENCES Request(RequestId)
);

-- =============================================
-- NEW TABLES (for Surplus Request feature)
-- =============================================

-- Surplus Request (main record - who submitted it & when)
CREATE TABLE SurplusRequest (
    SurplusRequestId  INT IDENTITY(1,1) PRIMARY KEY,
    RequestId         INT NULL,
    DepartmentId      INT NULL,
    Status            NVARCHAR(20)  DEFAULT 'Pending',
    SubmittedDate     DATETIME2     DEFAULT GETDATE(),

    CONSTRAINT FK_SurplusRequest_Request FOREIGN KEY (RequestId)
        REFERENCES Request(RequestId),

    CONSTRAINT FK_SurplusRequest_Department FOREIGN KEY (DepartmentId)
        REFERENCES Department(DepartmentId)
        ON DELETE SET NULL
);

-- Equipment checkboxes + quantities (Desktop x2, Laptop x1, etc.)
CREATE TABLE SurplusRequestEquipment (
    SurplusEquipmentId  INT IDENTITY(1,1) PRIMARY KEY,
    SurplusRequestId    INT NOT NULL,
    EquipmentType       NVARCHAR(50)  NOT NULL,   -- 'Desktop', 'Laptop', 'Monitor', 'Other'
    Quantity            INT           DEFAULT 1,

    CONSTRAINT FK_SurplusEquip_SurplusRequest FOREIGN KEY (SurplusRequestId)
        REFERENCES SurplusRequest(SurplusRequestId)
        ON DELETE CASCADE
);

-- Individual item details (Model, Serial #, Asset Tag per item)
CREATE TABLE SurplusRequestItem (
    SurplusItemId       INT IDENTITY(1,1) PRIMARY KEY,
    SurplusRequestId    INT NOT NULL,
    Model               NVARCHAR(100) NULL,
    SerialNumber        NVARCHAR(100) NULL,
    AssetTag            NVARCHAR(50)  NULL,

    CONSTRAINT FK_SurplusItem_SurplusRequest FOREIGN KEY (SurplusRequestId)
        REFERENCES SurplusRequest(SurplusRequestId)
        ON DELETE CASCADE
);
