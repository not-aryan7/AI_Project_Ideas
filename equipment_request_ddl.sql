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


1. Create a fake surplus request:

INSERT INTO SurplusRequest (RequestId, DepartmentId, Status, SubmittedDate) VALUES (1, 1, 'Pending', CURDATE());

2. Add equipment to it:

INSERT INTO SurplusRequestEquipment (SurplusRequestId, EquipmentType, Quantity) VALUES (1, 'Desktop', 2), (1, 'Monitor', 1);

3. Add individual item details:

INSERT INTO SurplusRequestItem (SurplusRequestId, Model, SerialNumber, AssetTag) VALUES (1, 'Dell OptiPlex 7090', 'SN-12345', 'CC-ASSET-001'), (1, 'Dell OptiPlex 7090', 'SN-12346', 'CC-ASSET-002'), (1, 'Dell P2422H Monitor', 'SN-99999', 'CC-ASSET-003');

4. See your data:

SELECT * FROM SurplusRequest;

SELECT * FROM SurplusRequestEquipment;

SELECT * FROM SurplusRequestItem;

    public async Task<string> GetAvailableAssets(string search = "")
    {
        var url = $"https://assets.clintoncountyny.gov/api/v1/hardware?status=RTD&limit=50";
        if (!string.IsNullOrEmpty(search))
            url += $"&search={search}";
        Caller call = new Caller(url, "Get", snipeItToken);
        var result = await call.Call();
        return result;
    }
