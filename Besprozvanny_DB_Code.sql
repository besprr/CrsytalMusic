CREATE DATABASE CrystalMusic

USE CrystalMusic

-- �������� ������� �����
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);

-- �������� ������� �������������
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    RoleID INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

-- ������� ��� �������� refresh �������
CREATE TABLE RefreshTokens (
    TokenID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Token NVARCHAR(512) NOT NULL UNIQUE,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    ExpiresAt DATETIME NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- ������� ��������� �����
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);

-- ������� ����� ������
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    CategoryID INT NOT NULL,
    ServiceName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    BaseColor NVARCHAR(7) NOT NULL DEFAULT '#FFFFFF', -- HEX-���� ��� ��������
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- ������� ���������
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomName NVARCHAR(100) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    IsAvailable BIT NOT NULL DEFAULT 1
);

-- ������� ������������
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    RoomID INT NOT NULL,
    ServiceID INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')) DEFAULT 'Pending',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    CHECK (EndTime > StartTime)
);

-- ������� ��� ����� ���������� ����������
CREATE TABLE UserActivity (
    ActivityID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ActivityType NVARCHAR(50) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    Details NVARCHAR(MAX),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ����� ����� � ��������� (������-��-������)
CREATE TABLE ServiceRooms (
    ServiceID INT NOT NULL,
    RoomID INT NOT NULL,
    PRIMARY KEY (ServiceID, RoomID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE
);

CREATE TABLE Visits (
    VisitID INT PRIMARY KEY IDENTITY(1,1),
    UserHash NVARCHAR(64) NOT NULL UNIQUE, -- ��� IP-������ ��� ���������� �������������
    FirstVisitDate DATETIME NOT NULL DEFAULT GETDATE() -- ���� ������� ���������
);

-- ��������� ������: ����
INSERT INTO Roles (RoleName) VALUES 
('Admin'), 
('User');

-- ������� ��� �����������
CREATE INDEX IX_Bookings_Time ON Bookings (StartTime, EndTime);
CREATE INDEX IX_Services_Color ON Services (BaseColor);