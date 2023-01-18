-- server = connect to master db
﻿use master;
-- go  

IF EXISTS(select * from sys.databases where name='ClothingShopDB')
alter database ClothingShopDB set single_user with rollback immediate
-- if single_user= drop then create
-- go

drop database if exists ClothingShopDB;
-- go

create database ClothingShopDB;
go

USE master;  
GO

alter database ClothingShopDB set multi_user with rollback immediate


ALTER DATABASE ClothingShopDB  
    COLLATE Persian_100_CI_AI_SC_UTF8;  
GO  
  
SELECT name, collation_name  
FROM sys.databases  
WHERE name = N'ClothingShopDB';  
GO

use ClothingShopDB;
go

CREATE TABLE [dbo].[Person] (
    [PersonID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [PersonFirstName] NVARCHAR (70)  NOT NULL,
    [PersonLastName]  NVARCHAR (70)  NOT NULL,
    [PersonGender]    BIT            NULL,
    [PersonBirthdate] DATE           NULL,
    [PersonPhone]     NVARCHAR (13)  NOT NULL,
    [PersonAddress]   NVARCHAR (300) NOT NULL,
    [PersonLocation]  NVARCHAR (50)  NULL,
    [PersonEmail]     NVARCHAR (256) NULL,
    [CreateDate]      DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreateUser]      BIGINT         NOT NULL,
    [UpdateDate]      DATETIME       DEFAULT (getdate()) NULL,
    [UpdateUser]      BIGINT         NULL,
    [IsEnable]        BIT            DEFAULT ((1)) NOT NULL,
    [IsDeleted]       BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonID] ASC)
);

CREATE TABLE [dbo].[Company] (
    [CompanyID]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyName]           NVARCHAR (70)   NOT NULL,
    [CompanyAddress]        NVARCHAR (300)  NOT NULL,
    [CompanyLocation]       NVARCHAR (50)   NULL,
    [CompanyPhone]          NVARCHAR (13)   NULL,
    [CompanyLogo]           VARBINARY (MAX) NULL,
    [CompanyFounderID]      BIGINT          NULL,
    [CompanyManagerID]      BIGINT          NULL,
    [CompanyFoundationDate] DATETIME        NULL,
    [CreateDate]            DATETIME        DEFAULT (getdate()) NOT NULL,
    [CreateUser]            BIGINT          NOT NULL,
    [UpdateDate]            DATETIME        DEFAULT (getdate()) NULL,
    [UpdateUser]            BIGINT          NULL,
    [IsEnable]              BIT             DEFAULT ((1)) NOT NULL,
    [IsDeleted]             BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED ([CompanyID] ASC)
);

CREATE TABLE [dbo].[Department] (
    [DepartmentID]        BIGINT        NOT NULL,
    [DepartmentName]      NVARCHAR (70) NOT NULL,
    [CompanyID]           BIGINT        NOT NULL,
    [DepartmentManagerID] BIGINT        NULL,
    [CreateDate]          DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreateUser]          BIGINT        NOT NULL,
    [UpdateDate]          DATETIME      DEFAULT (getdate()) NULL,
    [UpdateUser]          BIGINT        NULL,
    [IsEnable]            BIT           DEFAULT ((1)) NOT NULL,
    [IsDeleted]           BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED ([DepartmentID] ASC),
    CONSTRAINT [FK_Department_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([CompanyID]) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE [dbo].[Category] (
    [CategoryID]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [CategoryParentID] BIGINT        NULL,
    [CategoryName]     NVARCHAR (50) NOT NULL,
    [CreateDate]       DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreateUser]       BIGINT        NOT NULL,
    [UpdateDate]       DATETIME      DEFAULT (getdate()) NULL,
    [UpdateUser]       BIGINT        NULL,
    [IsEnable]         BIT           DEFAULT ((1)) NOT NULL,
    [IsDeleted]        BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([CategoryID] ASC),
    CONSTRAINT [FK_Category_Category] FOREIGN KEY ([CategoryParentID]) REFERENCES [dbo].[Category] ([CategoryID])
);

CREATE TABLE [dbo].[EmployeeAccess] (
    [AccessID]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [AccessLevel] NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_EmployeeAccess] PRIMARY KEY CLUSTERED ([AccessID] ASC)
);

CREATE TABLE [dbo].[Employee] (
    [PersonID]            BIGINT   NOT NULL,
    [EmployeeID]          BIGINT   IDENTITY (1, 1) NOT NULL,
    [DepartmentID]        BIGINT   NOT NULL,
    [ManagerID]           BIGINT   CONSTRAINT [DF_Employee_ManagerID] DEFAULT (NULL) NULL,
    [EmployeeAccessLevel] BIGINT   NULL,
    [CreateDate]          DATETIME CONSTRAINT [DF__Employee__Create__7A672E12] DEFAULT (getdate()) NOT NULL,
    [CreateUser]          BIGINT   NOT NULL,
    [UpdateDate]          DATETIME CONSTRAINT [DF__Employee__Update__7B5B524B] DEFAULT (getdate()) NULL,
    [UpdateUser]          BIGINT   NULL,
    [IsEnable]            BIT      CONSTRAINT [DF__Employee__IsEnab__7C4F7684] DEFAULT ((1)) NOT NULL,
    [IsDeleted]           BIT      CONSTRAINT [DF__Employee__IsDele__7D439ABD] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED ([EmployeeID] ASC),
    CONSTRAINT [FK_Employee_Person] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Person] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Employee_Employee] FOREIGN KEY ([ManagerID]) REFERENCES [dbo].[Employee] ([EmployeeID]),
    CONSTRAINT [FK_Employee_EmployeeAccess] FOREIGN KEY ([EmployeeAccessLevel]) REFERENCES [dbo].[EmployeeAccess] ([AccessID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Employee_Department] FOREIGN KEY ([DepartmentID]) REFERENCES [dbo].[Department] ([DepartmentID]) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE [dbo].[Customer] (
    [PersonID]             BIGINT   NOT NULL,
    [CustomerID]           BIGINT   IDENTITY (1, 1) NOT NULL,
    [CustomerRegisterDate] DATETIME NOT NULL,
    [CreateDate]           DATETIME DEFAULT (getdate()) NOT NULL,
    [CreateUser]           BIGINT   NOT NULL,
    [UpdateDate]           DATETIME DEFAULT (getdate()) NULL,
    [UpdateUser]           BIGINT   NULL,
    [IsEnable]             BIT      DEFAULT ((1)) NOT NULL,
    [IsDeleted]            BIT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [FK_Customer_Person] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Person] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE [dbo].[User] (
    [PersonID]    BIGINT        NOT NULL,
    [Username]    NVARCHAR (50) NOT NULL,
    [Password]    NVARCHAR (30) NOT NULL,
    [PersonType]  BIT           CONSTRAINT [DF_User_PersonType] DEFAULT ((0)) NOT NULL,
    [IsSuspended] BIT           CONSTRAINT [DF_User_IsSuspended] DEFAULT ((0)) NOT NULL,
    [CreateDate]  DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreateUser]  BIGINT        NOT NULL,
    [UpdateDate]  DATETIME      DEFAULT (getdate()) NULL,
    [UpdateUser]  BIGINT        NULL,
    [IsEnable]    BIT           DEFAULT ((1)) NOT NULL,
    [IsDeleted]   BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([Username] ASC),
    CONSTRAINT [FK_User_Person] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Person] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE [dbo].[Supplier] (
    [SupplierID]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [SupplierName]    NVARCHAR (70)  NOT NULL,
    [SupplierAddress] NVARCHAR (300) NULL,
    [CreateDate]      DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreateUser]      BIGINT         NOT NULL,
    [UpdateDate]      DATETIME       DEFAULT (getdate()) NULL,
    [UpdateUser]      BIGINT         NULL,
    [IsEnable]        BIT            DEFAULT ((1)) NOT NULL,
    [IsDeleted]       BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED ([SupplierID] ASC)
);

CREATE TABLE [dbo].[ProductSize] (
    [SizeID]     BIGINT        IDENTITY (1, 1) NOT NULL,
    [SizeValue]  NVARCHAR (50) NOT NULL,
    [CreateDate] DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreateUser] BIGINT        NOT NULL,
    [UpdateDate] DATETIME      DEFAULT (getdate()) NULL,
    [UpdateUser] BIGINT        NULL,
    [IsEnable]   BIT           DEFAULT ((1)) NOT NULL,
    [IsDeleted]  BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProductSize] PRIMARY KEY CLUSTERED ([SizeID] ASC)
);

CREATE TABLE [dbo].[Product] (
    [ProductID]    BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProductName]  NVARCHAR (70) NOT NULL,
    [ProductBrand] NVARCHAR (50) NULL,
    [CategoryID]   BIGINT        NOT NULL,
    [CreateDate]   DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreateUser]   BIGINT        NOT NULL,
    [UpdateDate]   DATETIME      DEFAULT (getdate()) NULL,
    [UpdateUser]   BIGINT        NULL,
    [IsEnable]     BIT           DEFAULT ((1)) NOT NULL,
    [IsDeleted]    BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_Product_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Category] ([CategoryID]) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE [dbo].[ProductItem] (
    [ProductItemID]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProductID]                BIGINT         NOT NULL,
    [SupplierID]               BIGINT         NOT NULL,
    [ProductItemQuantity]      INT            NOT NULL,
    [ProductItemSizeID]        BIGINT         NOT NULL,
    [ProductItemColor]         NVARCHAR (20)  CONSTRAINT [DF_ProductItem_ProductItemColor] DEFAULT ('#ffffff') NOT NULL,
    [ProductItemSellUnitPrice] INT            CONSTRAINT [DF_ProductItem_ProductItemSellUnitPrice] DEFAULT ((0)) NOT NULL,
    [ProductItemDiscount]      DECIMAL (5, 3) CONSTRAINT [DF_ProductItem_ProductItemDiscount] DEFAULT ((0)) NULL,
    [ProductItemBuyUnitPrice]  INT            CONSTRAINT [DF_ProductItem_ProductItemBuyUnitPrice] DEFAULT ((0)) NOT NULL,
    [CreateDate]               DATETIME       CONSTRAINT [DF__ProductIt__Creat__09A971A2] DEFAULT (getdate()) NOT NULL,
    [CreateUser]               BIGINT         NOT NULL,
    [UpdateDate]               DATETIME       CONSTRAINT [DF__ProductIt__Updat__0A9D95DB] DEFAULT (getdate()) NULL,
    [UpdateUser]               BIGINT         NULL,
    [IsEnable]                 BIT            CONSTRAINT [DF__ProductIt__IsEna__0B91BA14] DEFAULT ((1)) NOT NULL,
    [IsDeleted]                BIT            CONSTRAINT [DF__ProductIt__IsDel__0C85DE4D] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProductItem] PRIMARY KEY CLUSTERED ([ProductItemID] ASC),
    CONSTRAINT [FK_ProductItem_Product] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_ProductItem_Supplier] FOREIGN KEY ([SupplierID]) REFERENCES [dbo].[Supplier] ([SupplierID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_ProductItem_ProductSize] FOREIGN KEY ([ProductItemSizeID]) REFERENCES [dbo].[ProductSize] ([SizeID]) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE [dbo].[ProductLogPrice] (
    [ProductLogID]  BIGINT   IDENTITY (1, 1) NOT NULL,
    [ProductItemID] BIGINT   NOT NULL,
    [Price]         INT      NOT NULL,
    [LogDate]       DATETIME NOT NULL,
    CONSTRAINT [PK_ProductLogPrice] PRIMARY KEY CLUSTERED ([ProductLogID] ASC),
    CONSTRAINT [FK_ProductLogPrice_ProductItem] FOREIGN KEY ([ProductItemID]) REFERENCES [dbo].[ProductItem] ([ProductItemID]) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE [dbo].[Order] (
    [OrderID]          BIGINT   IDENTITY (1, 1) NOT NULL,
    [OrderDate]        DATETIME CONSTRAINT [DF_Order_OrderDate] DEFAULT (getdate()) NOT NULL,
    [OrderPaymentDate] DATETIME CONSTRAINT [DF_Order_OrderPaymentDate] DEFAULT (NULL) NULL,
    [CreateDate]       DATETIME DEFAULT (getdate()) NOT NULL,
    [CreateUser]       BIGINT   NOT NULL,
    [UpdateDate]       DATETIME DEFAULT (getdate()) NULL,
    [UpdateUser]       BIGINT   NULL,
    [IsEnable]         BIT      DEFAULT ((1)) NOT NULL,
    [IsDeleted]        BIT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED ([OrderID] ASC)
);

CREATE TABLE [dbo].[OrderItem] (
    [OrderItemID]   BIGINT   IDENTITY (1, 1) NOT NULL,
    [OrderID]       BIGINT   NOT NULL,
    [ProductItemID] BIGINT   NOT NULL,
    [OrderQuantity] INT      CONSTRAINT [DF_OrderItem_OrderQuantity] DEFAULT ((1)) NOT NULL,
    [CreateDate]    DATETIME DEFAULT (getdate()) NOT NULL,
    [CreateUser]    BIGINT   NOT NULL,
    [UpdateDate]    DATETIME DEFAULT (getdate()) NULL,
    [UpdateUser]    BIGINT   NULL,
    [IsEnable]      BIT      DEFAULT ((1)) NOT NULL,
    [IsDeleted]     BIT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED ([OrderItemID] ASC),
    CONSTRAINT [FK_OrderItem_Order] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Order] ([OrderID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_OrderItem_ProductItem] FOREIGN KEY ([ProductItemID]) REFERENCES [dbo].[ProductItem] ([ProductItemID]) ON DELETE CASCADE ON UPDATE CASCADE
);

