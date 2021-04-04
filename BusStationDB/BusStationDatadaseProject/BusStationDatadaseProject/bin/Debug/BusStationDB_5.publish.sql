﻿/*
Deployment script for bus_station

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "bus_station"
:setvar DefaultFilePrefix "bus_station"
:setvar DefaultDataPath "C:\Users\lenovo\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB"
:setvar DefaultLogPath "C:\Users\lenovo\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column id_bus on table [dbo].[Trip] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Trip])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Rename refactoring operation with key a746f532-cf3a-4646-9f6a-074f9a0673ab is skipped, element [dbo].[Bus].[Id] (SqlSimpleColumn) will not be renamed to id';


GO
PRINT N'Rename refactoring operation with key ac5b9d71-c618-4ec5-a68b-895f9b528f94, dbe45056-dc5c-4e6d-8ac3-28aab109ce9a is skipped, element [dbo].[Bus].[id_seat] (SqlSimpleColumn) will not be renamed to count_seat';


GO
PRINT N'Altering [dbo].[Station]...';


GO
ALTER TABLE [dbo].[Station] ALTER COLUMN [name] NCHAR (80) NOT NULL;


GO
PRINT N'Altering [dbo].[Trip]...';


GO
ALTER TABLE [dbo].[Trip] ALTER COLUMN [id_bus] INT NOT NULL;


GO
PRINT N'Creating [dbo].[Bus]...';


GO
CREATE TABLE [dbo].[Bus] (
    [id]         INT NOT NULL,
    [count_seat] INT NOT NULL,
    [id_type]    INT NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a746f532-cf3a-4646-9f6a-074f9a0673ab')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a746f532-cf3a-4646-9f6a-074f9a0673ab')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ac5b9d71-c618-4ec5-a68b-895f9b528f94')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ac5b9d71-c618-4ec5-a68b-895f9b528f94')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dbe45056-dc5c-4e6d-8ac3-28aab109ce9a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dbe45056-dc5c-4e6d-8ac3-28aab109ce9a')

GO

GO
PRINT N'Update complete.';


GO
