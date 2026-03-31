-- =============================================
-- Surplus Tables — MariaDB syntax
-- =============================================

CREATE TABLE SurplusRequest (
    SurplusRequestId  INT AUTO_INCREMENT PRIMARY KEY,
    RequestId         INT            NULL,
    DepartmentId      INT            NULL,
    Status            VARCHAR(20)    DEFAULT 'Pending',
    SubmittedDate     DATE           DEFAULT (CURDATE()),

    CONSTRAINT FK_SurplusRequest_Request FOREIGN KEY (RequestId)
        REFERENCES Request(RequestId),

    CONSTRAINT FK_SurplusRequest_Department FOREIGN KEY (DepartmentId)
        REFERENCES Department(DepartmentId)
) ENGINE=InnoDB;

CREATE TABLE SurplusRequestEquipment (
    SurplusEquipmentId  INT AUTO_INCREMENT PRIMARY KEY,
    SurplusRequestId    INT            NOT NULL,
    EquipmentType       VARCHAR(50)    NOT NULL,
    Quantity            INT            DEFAULT 1,

    CONSTRAINT FK_SurplusEquip_SurplusRequest FOREIGN KEY (SurplusRequestId)
        REFERENCES SurplusRequest(SurplusRequestId)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE SurplusRequestItem (
    SurplusItemId       INT AUTO_INCREMENT PRIMARY KEY,
    SurplusRequestId    INT            NOT NULL,
    Model               VARCHAR(100)   NULL,
    SerialNumber        VARCHAR(100)   NULL,
    AssetTag            VARCHAR(50)    NULL,

    CONSTRAINT FK_SurplusItem_SurplusRequest FOREIGN KEY (SurplusRequestId)
        REFERENCES SurplusRequest(SurplusRequestId)
        ON DELETE CASCADE
) ENGINE=InnoDB;
