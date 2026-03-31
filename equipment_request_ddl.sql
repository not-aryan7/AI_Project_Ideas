-- ============================================================
-- Clinton County IT — Equipment Request System DDL
-- Supports: Loan Requests & Surplus Equipment Requests
-- ============================================================

-- --------------------
-- LOOKUP TABLES
-- --------------------

CREATE TABLE departments (
    department_id   INT PRIMARY KEY IDENTITY(1,1),
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE equipment_types (
    equipment_type_id INT PRIMARY KEY IDENTITY(1,1),
    type_name         VARCHAR(50) NOT NULL UNIQUE   -- Desktop, Laptop, Monitor, Other
);

CREATE TABLE term_lengths (
    term_length_id INT PRIMARY KEY IDENTITY(1,1),
    label          VARCHAR(50) NOT NULL UNIQUE       -- e.g. '1 Week', '1 Month', '6 Months', '1 Year'
);

-- --------------------
-- REQUESTERS
-- --------------------

CREATE TABLE requesters (
    requester_id  INT PRIMARY KEY IDENTITY(1,1),
    full_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(200) NOT NULL,
    phone         VARCHAR(20)  NULL,
    department_id INT          NULL,
    CONSTRAINT fk_requester_dept FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- --------------------
-- SECTION 1: LOAN REQUESTS  (existing web form)
-- --------------------
-- One row per loan request submitted via the "Loan Request" button.

CREATE TABLE loan_requests (
    loan_request_id   INT PRIMARY KEY IDENTITY(1,1),
    requester_id      INT          NOT NULL,
    equipment_type_id INT          NOT NULL,
    term_length_id    INT          NOT NULL,
    request_date      DATE         NOT NULL DEFAULT GETDATE(),
    notes             VARCHAR(500) NULL,
    status            VARCHAR(20)  NOT NULL DEFAULT 'Pending',
    created_at        DATETIME     NOT NULL DEFAULT GETDATE(),

    CONSTRAINT fk_loan_requester  FOREIGN KEY (requester_id)
        REFERENCES requesters(requester_id),
    CONSTRAINT fk_loan_equip_type FOREIGN KEY (equipment_type_id)
        REFERENCES equipment_types(equipment_type_id),
    CONSTRAINT fk_loan_term       FOREIGN KEY (term_length_id)
        REFERENCES term_lengths(term_length_id)
);

-- --------------------
-- SECTION 2: SURPLUS REQUESTS  (paper form → now digital)
-- --------------------
-- One row per surplus request submitted via the "Surplus Request" button.

CREATE TABLE surplus_requests (
    surplus_request_id INT PRIMARY KEY IDENTITY(1,1),
    requester_id       INT          NOT NULL,
    request_date       DATE         NOT NULL DEFAULT GETDATE(),
    notes              VARCHAR(500) NULL,
    status             VARCHAR(20)  NOT NULL DEFAULT 'Pending',
    created_at         DATETIME     NOT NULL DEFAULT GETDATE(),

    CONSTRAINT fk_surplus_requester FOREIGN KEY (requester_id)
        REFERENCES requesters(requester_id)
);

-- Equipment type + quantity per surplus request
-- (the checkboxes: Desktop ×2, Laptop ×1, etc.)

CREATE TABLE surplus_request_equipment (
    id                 INT PRIMARY KEY IDENTITY(1,1),
    surplus_request_id INT NOT NULL,
    equipment_type_id  INT NOT NULL,
    quantity           INT NOT NULL DEFAULT 1,

    CONSTRAINT fk_sre_request    FOREIGN KEY (surplus_request_id)
        REFERENCES surplus_requests(surplus_request_id),
    CONSTRAINT fk_sre_equip_type FOREIGN KEY (equipment_type_id)
        REFERENCES equipment_types(equipment_type_id)
);

-- Individual items listed in the surplus table
-- (the rows: Model / Serial Number / Asset Tag)

CREATE TABLE surplus_request_items (
    item_id            INT PRIMARY KEY IDENTITY(1,1),
    surplus_request_id INT          NOT NULL,
    model              VARCHAR(100) NULL,
    serial_number      VARCHAR(100) NULL,
    asset_tag          VARCHAR(50)  NULL,

    CONSTRAINT fk_sri_request FOREIGN KEY (surplus_request_id)
        REFERENCES surplus_requests(surplus_request_id)
);

-- --------------------
-- SEED LOOKUP DATA
-- --------------------

INSERT INTO equipment_types (type_name) VALUES
    ('Desktop'), ('Laptop'), ('Monitor'), ('Other');

INSERT INTO term_lengths (label) VALUES
    ('1 Week'), ('2 Weeks'), ('1 Month'), ('3 Months'), ('6 Months'), ('1 Year');

-- Add your departments here:
-- INSERT INTO departments (department_name) VALUES ('Information Technology'), ('Finance'), ...
