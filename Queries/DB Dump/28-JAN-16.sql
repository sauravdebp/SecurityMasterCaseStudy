USE [master]
GO
/****** Object:  Database [SecurityMaster]    Script Date: 28-01-2016 20:13:57 ******/
CREATE DATABASE [SecurityMaster]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SecurityMaster', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SecurityMaster.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SecurityMaster_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SecurityMaster_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SecurityMaster] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SecurityMaster].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SecurityMaster] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SecurityMaster] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SecurityMaster] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SecurityMaster] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SecurityMaster] SET ARITHABORT OFF 
GO
ALTER DATABASE [SecurityMaster] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [SecurityMaster] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SecurityMaster] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SecurityMaster] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SecurityMaster] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SecurityMaster] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SecurityMaster] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SecurityMaster] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SecurityMaster] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SecurityMaster] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SecurityMaster] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SecurityMaster] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SecurityMaster] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SecurityMaster] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SecurityMaster] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SecurityMaster] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SecurityMaster] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SecurityMaster] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SecurityMaster] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SecurityMaster] SET  MULTI_USER 
GO
ALTER DATABASE [SecurityMaster] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SecurityMaster] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SecurityMaster] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SecurityMaster] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SecurityMaster]
GO
/****** Object:  User [NT AUTHORITY\SYSTEM]    Script Date: 28-01-2016 20:13:57 ******/
CREATE USER [NT AUTHORITY\SYSTEM] FOR LOGIN [NT AUTHORITY\SYSTEM] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [NT AUTHORITY\SYSTEM]
GO
/****** Object:  StoredProcedure [dbo].[CreateSecurity]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateSecurity]
(
	@securityTypeName VARCHAR(MAX),
	@xml XML
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(200)
	DECLARE @query VARCHAR(MAX)
	
	SELECT @entity_name = TableName
	FROM SecurityType
	WHERE SecurityClassName = @securityTypeName

	SET @query = 'DECLARE @securityId INT' + CHAR(13)
	SET @query = @query + 'SELECT @securityId = CASE WHEN MAX(SecurityId) IS NULL THEN 0 ELSE MAX(SecurityId) END FROM ' + @entity_name + CHAR(13)

	--DROP TABLE #tmpTable

	SET @query = @query + 'DECLARE @security_data XML' + CHAR(13)
	SET @query = @query + 'SELECT @security_data = ''' + CONVERT(VARCHAR(MAX), @xml) + ''';' + CHAR(13)	--Assigning the xml data to security data var
	
	--SET @query = @query + 'INSERT INTO ' + @entity_name + ' (SecurityId, Name, Description)'	--THIS STATEMENT IS FOR TESTING ONLY
	SET @query = @query + 'INSERT INTO ' + @entity_name	--This is the final statement to be used. NOT THE ABOVE ONE
	SET @query = @query + ' SELECT '
	
	--The below part will generate a table which will have all the @entity_name attributes using the sys.columns table
	SELECT
		@query = 
			CASE
				WHEN name = 'SecurityId'-- AND @generateSecurityId = 1
				THEN @query + ' CASE WHEN doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') = '''' THEN @securityId + ROW_NUMBER() OVER(ORDER BY (SELECT 0)) ELSE doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') END [' + name + '], ' + CHAR(13) 
				ELSE @query + ' CASE WHEN doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') = '''' THEN NULL ELSE doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') END [' + name + '], ' + CHAR(13) 
			END
	FROM sys.columns 
	WHERE object_id = OBJECT_ID(@entity_name,'TABLE') 
	--AND name IN ('SecurityId', 'Name', 'Description')	--THIS STATEMENT IS FOR TESTING ONLY
	ORDER BY sys.columns.column_id
	
	--The below part is specifying in the generated query to use the XML
	SET @query = LEFT(@query, LEN(@query) - 3) +  ' FROM @security_data.nodes(''/ArrayOfSecurity/Security'') doc(col); ' + CHAR(13) 
	--PRINT CAST(@query as NTEXT)
	EXECUTE (@query)
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteSecurity]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteSecurity]
(
	@securityTypeName VARCHAR(MAX),
	@securityId INT
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(100)
	DECLARE @query VARCHAR(500)

	SELECT @entity_name = TableName
	FROM SecurityType
	WHERE SecurityClassName = @securityTypeName
	
	SET @query = 'DELETE FROM ' + @entity_name + ' WHERE SecurityId = ' + CONVERT(VARCHAR(MAX), @securityId)

	EXECUTE(@query)
END

--EXEC DeleteSecurity 25, 1
GO
/****** Object:  StoredProcedure [dbo].[GetSecurityAttributes]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetSecurityAttributes]
(
	@securityTypeName VARCHAR(MAX)
)
AS
BEGIN

	SELECT 
		AttributeDisplayName, 
		AttributeRealName
	FROM
		SecurityAttributes
		JOIN
		SecurityType ON SecurityAttributes.SecurityTypeId = SecurityType.SecurityTypeId
	WHERE
		SecurityClassName = @securityTypeName
END
GO
/****** Object:  StoredProcedure [dbo].[GetTabAttributes]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetTabAttributes]
(
	@securityTypeName VARCHAR(MAX)
)
AS
BEGIN
	SELECT AttributeDisplayName, AttributeRealName, TabName, AttributeDataType
	FROM SecurityAttributes sa
	JOIN SecurityType st ON sa.SecurityTypeId = st.SecurityTypeId
	WHERE SecurityClassName = @securityTypeName
END

--EXEC SelectSecurity 1, 25
GO
/****** Object:  StoredProcedure [dbo].[SelectSecurity]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectSecurity]
(
	@securityTypeName VARCHAR(MAX),
	@securityId INT
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(100)
	DECLARE @query VARCHAR(500)

	SELECT @entity_name = TableName
	FROM SecurityType
	WHERE SecurityClassName = @securityTypeName
	
	SET @query = 'SELECT * FROM ' + @entity_name + ' WHERE SecurityId = ' + CONVERT(VARCHAR(MAX), @securityId)

	EXECUTE(@query)
END

--EXEC SelectSecurity 1, 25
GO
/****** Object:  StoredProcedure [dbo].[UpdateSecurity]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateSecurity]
(
	@securityTypeName VARCHAR(MAX),
	@xml XML
)
AS
BEGIN
	--DECLARE @securityId INT
	--retrieve securityId from XML
	DECLARE @deleteQuery VARCHAR(500)

	SET @deleteQuery = ' '

	SELECT
		@deleteQuery = @deleteQuery + 'EXEC DeleteSecurity ' + CONVERT(VARCHAR(MAX), @securityTypeName) + ', ' + doc.col.value('SecurityId[1]', 'VARCHAR(MAX)') + ';'
	FROM @xml.nodes('ArrayOfSecurity/Security') doc(col)
	
	EXECUTE(@deleteQuery)
	EXEC CreateSecurity @securityTypeName, @xml
END

--DECLARE @xml XML = '
--<Securities>
--	<Security>
--		<SecurityId>25</SecurityId>
--		<Name>MICROSOFT</Name>
--		<Description>Microsoft Stock</Description>
--	</Security>
--	<Security>
--		<SecurityId>26</SecurityId>
--		<Name>crAPPLE</Name>
--		<Description>Apple Equity</Description>
--	</Security>
--</Securities>
--'
--EXEC UpdateSecurity 1, @xml
GO
/****** Object:  Table [dbo].[CorporateBond]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CorporateBond](
	[SecurityId] [int] NOT NULL,
	[Name] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[AssetType] [varchar](max) NULL,
	[InvestmentType] [varchar](max) NULL,
	[TradingFactor] [varchar](max) NULL,
	[PricingFactor] [varchar](max) NULL,
	[ISIN] [varchar](max) NULL,
	[BBG_Ticker] [varchar](max) NULL,
	[BBG_UniqueID] [varchar](max) NULL,
	[CUSIP] [varchar](max) NULL,
	[SEDOL] [varchar](max) NULL,
	[FirstCouponDate] [datetime] NULL,
	[Cap] [varchar](max) NULL,
	[BondFloor] [varchar](max) NULL,
	[CouponFrequency] [varchar](max) NULL,
	[Coupon] [varchar](max) NULL,
	[CouponType] [varchar](max) NULL,
	[Spread] [varchar](max) NULL,
	[CallableFlag] [bit] NULL,
	[FixToFloatFlag] [bit] NULL,
	[PutableFlag] [bit] NULL,
	[IssueDate] [datetime] NULL,
	[LastResetDate] [datetime] NULL,
	[Maturity] [datetime] NULL,
	[CallNotificationMaxDays] [varchar](max) NULL,
	[PutNotificationMaxDays] [varchar](max) NULL,
	[PenultimateCouponDate] [datetime] NULL,
	[ResetFrequency] [varchar](max) NULL,
	[HasPosition] [bit] NULL,
	[MacaulayDuration] [varchar](max) NULL,
	[Volatility_30D] [varchar](max) NULL,
	[Volatility_90D] [varchar](max) NULL,
	[Convexity] [varchar](max) NULL,
	[AverageVolume_30D] [varchar](max) NULL,
	[PF_AssetClass] [varchar](max) NULL,
	[PF_Country] [varchar](max) NULL,
	[PF_CreditRating] [varchar](max) NULL,
	[PF_Currency] [varchar](max) NULL,
	[PF_Instrument] [varchar](max) NULL,
	[PF_LiquidityProfile] [varchar](max) NULL,
	[PF_Maturity] [varchar](max) NULL,
	[PF_NAICS_Code] [varchar](max) NULL,
	[PF_Region] [varchar](max) NULL,
	[PF_Sector] [varchar](max) NULL,
	[PF_SubAssetClass] [varchar](max) NULL,
	[BBG_IndustryGroup] [varchar](max) NULL,
	[BBG_IndustrySubGroup] [varchar](max) NULL,
	[BBG_IndustrySector] [varchar](max) NULL,
	[CountryOfIssuance] [varchar](max) NULL,
	[IssueCurrency] [varchar](max) NULL,
	[Issuer] [varchar](max) NULL,
	[RiskCurrency] [varchar](max) NULL,
	[PutDate] [datetime] NULL,
	[PutPrice] [varchar](max) NULL,
	[AskPrice] [varchar](max) NULL,
	[HighPrice] [varchar](max) NULL,
	[LowPrice] [varchar](max) NULL,
	[OpenPrice] [varchar](max) NULL,
	[Volume] [varchar](max) NULL,
	[BidPrice] [varchar](max) NULL,
	[LastPrice] [varchar](max) NULL,
	[CallDate] [datetime] NULL,
	[CallPrice] [varchar](max) NULL,
 CONSTRAINT [PK_CorporateBond] PRIMARY KEY CLUSTERED 
(
	[SecurityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Equity]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Equity](
	[SecurityId] [int] NOT NULL,
	[Name] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[HasPosition] [bit] NULL,
	[IsActiveSecurity] [bit] NULL,
	[LotSize] [varchar](max) NULL,
	[BBG_UniqueName] [varchar](max) NULL,
	[CUSIP] [varchar](max) NULL,
	[ISIN] [varchar](max) NULL,
	[SEDOL] [varchar](max) NULL,
	[BBG_Ticker] [varchar](max) NULL,
	[BBG_UniqueID] [varchar](max) NULL,
	[BBG_GlobalID] [varchar](max) NULL,
	[TickerAndExchange] [varchar](max) NULL,
	[IsAdrFlag] [bit] NULL,
	[AdrUnderlyingTicker] [varchar](max) NULL,
	[AdrUnderlyingCurrency] [varchar](max) NULL,
	[SharesPerADR] [varchar](max) NULL,
	[IPODate] [datetime] NULL,
	[PricingCurrency] [varchar](max) NULL,
	[SettleDays] [varchar](max) NULL,
	[TotalSharesOutstanding] [varchar](max) NULL,
	[VotingRightsPerShare] [varchar](max) NULL,
	[AverageVolume_20D] [varchar](max) NULL,
	[Beta] [varchar](max) NULL,
	[ShortInterest] [varchar](max) NULL,
	[Return_YTD] [varchar](max) NULL,
	[Volatility_90D] [varchar](max) NULL,
	[PF_AssetClass] [varchar](max) NULL,
	[PF_Country] [varchar](max) NULL,
	[PF_CreditRating] [varchar](max) NULL,
	[PF_Currency] [varchar](max) NULL,
	[PF_Instrument] [varchar](max) NULL,
	[PF_LiquidityProfile] [varchar](max) NULL,
	[PF_Maturity] [varchar](max) NULL,
	[PF_NAICS_Code] [varchar](max) NULL,
	[PF_Region] [varchar](max) NULL,
	[PF_Sector] [varchar](max) NULL,
	[PF_SubAssetClass] [varchar](max) NULL,
	[CountryOfIssuance] [varchar](max) NULL,
	[Exchange] [varchar](max) NULL,
	[Issuer] [varchar](max) NULL,
	[IssueCurrency] [varchar](max) NULL,
	[TradingCurrency] [varchar](max) NULL,
	[BBG_IndustrySubGroup] [varchar](max) NULL,
	[BBG_IndustryGroup] [varchar](max) NULL,
	[BBG_Sector] [varchar](max) NULL,
	[CountryOfIncorporation] [varchar](max) NULL,
	[RiskCurrency] [varchar](max) NULL,
	[OpenPrice] [varchar](max) NULL,
	[ClosePrice] [varchar](max) NULL,
	[Volume] [varchar](max) NULL,
	[LastPrice] [varchar](max) NULL,
	[AskPrice] [varchar](max) NULL,
	[BidPrice] [varchar](max) NULL,
	[PE_Ratio] [varchar](max) NULL,
	[DividendDeclaredDate] [datetime] NULL,
	[DividendExDate] [datetime] NULL,
	[DividendRecordDate] [datetime] NULL,
	[DividendPayDate] [datetime] NULL,
	[DividendAmount] [varchar](max) NULL,
	[Frequency] [varchar](max) NULL,
	[DividendType] [varchar](max) NULL,
 CONSTRAINT [PK_Equity] PRIMARY KEY CLUSTERED 
(
	[SecurityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Security]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Security](
	[SecurityId] [int] NOT NULL,
	[SecurityName] [varchar](max) NOT NULL,
	[SecurityType] [char](1) NOT NULL,
 CONSTRAINT [PK_Security] PRIMARY KEY CLUSTERED 
(
	[SecurityId] ASC,
	[SecurityType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SecurityAttributes]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SecurityAttributes](
	[AttributeId] [int] IDENTITY(1,1) NOT NULL,
	[SecurityTypeId] [int] NULL,
	[AttributeDisplayName] [varchar](100) NULL,
	[AttributeRealName] [varchar](50) NULL,
	[TabName] [varchar](100) NULL,
	[AttributeDataType] [varchar](50) NULL,
	[AttributeLength] [int] NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[LastModifiedOn] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SecurityType]    Script Date: 28-01-2016 20:13:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SecurityType](
	[SecurityTypeId] [int] NOT NULL,
	[SecurityTypeName] [varchar](50) NULL,
	[SecurityClassName] [varchar](50) NULL,
	[TableName] [varchar](50) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[LastModifiedOn] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_SecurityType] PRIMARY KEY CLUSTERED 
(
	[SecurityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (1, N'MENTOR 12 1/2 02/15/18', N'MENTOR 12 1/2 02/15/18', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US63688RAD98', N'MENTOR', N'COEI5580481', N'63688RAD9', N'B3N1710', NULL, NULL, NULL, N'2', N'12.5', N'Fixed', NULL, 1, 0, 0, NULL, NULL, NULL, N'60', N'0', NULL, NULL, 1, N'2.569', N'0', N'0', N'0', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Healthcare-Services', N'Medical-Outptnt/Home Med', N'Consumer, Non-cyclical', N'UNITED STATES', N'USD', N'NATIONAL MENTOR HOLDINGS', N'USD', NULL, N'0', N'106.4', N'106.4', N'105', N'105.5', N'1000', N'106.4', N'106.4', NULL, N'106.25')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (2, N'NLSN 5 04/15/22', N'NLSN 5 04/15/22', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US65409QBB77', N'NLSN', N'COEK1536029', N'65409QBB7', N'BNJ34X1', NULL, NULL, NULL, N'2', N'5', N'Fixed', NULL, 1, 0, 0, NULL, NULL, NULL, N'60', N'0', NULL, NULL, 1, N'6.124799', N'15.2242641', N'10.8099365', N'0.246069938', N'1681.08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Media', N'Publishing-Periodicals', N'Communications', N'UNITED STATES', N'USD', N'NIELSEN FINANCE LLC/CO', N'USD', NULL, N'0', N'101', N'101', N'100.55', N'100.5', N'1681', N'101', N'101', NULL, N'103.75')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (3, N'OSG 8 1/8 03/30/18', N'OSG 8 1/8 03/30/18', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US690368AH88', N'OSG', N'COEI1970710', N'690368AH8', N'B55JHR2', NULL, NULL, NULL, N'2', N'8.125', N'Fixed', NULL, 0, 0, 0, NULL, NULL, NULL, N'0', N'0', NULL, NULL, 1, N'2.844', N'26.903', N'30.42', N'0.094', N'892.808', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Transportation', N'Transport-Marine', N'Industrial', N'UNITED STATES', N'USD', N'OVERSEAS SHIPHLDG GROUP', N'USD', NULL, N'0', N'98.1', N'98.1', N'96.4', N'96.8', N'2000', N'98.1', N'98.1', NULL, N'0')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (4, N'WIN 9 7/8 12/01/18', N'WIN 9 7/8 12/01/18', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US695459AF48', N'WIN', N'COEI7032879', N'695459AF4', N'B6Q9XM5', NULL, NULL, NULL, N'2', N'9.875', N'Fixed', NULL, 1, 0, 0, NULL, NULL, NULL, N'60', N'0', NULL, NULL, 1, N'3.322', N'5.192', N'3.926', N'0', N'926.667', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Telecommunications', N'Telecom Services', N'Communications', N'UNITED STATES', N'USD', N'PAETEC HOLDING CORP', N'USD', NULL, N'0', N'105.625', N'105.625', N'104', N'105', N'1788', N'105.625', N'105.625', NULL, N'104.938')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (5, N'PNK 7 3/4 04/01/22', N'PNK 7 3/4 04/01/22', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US723456AP49', N'PNK', N'COEJ0527378', N'723456AP4', N'B7M2CG2', NULL, NULL, NULL, N'2', N'7.75', N'Fixed', NULL, 1, 0, 0, NULL, NULL, NULL, N'60', N'0', NULL, NULL, 1, N'5.623', N'15.657', N'13.917', N'0.098', N'558.75', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Entertainment', N'Gambling (Non-Hotel)', N'Consumer, Cyclical', N'UNITED STATES', N'USD', N'PINNACLE ENTERTAINMENT', N'USD', NULL, N'0', N'106.475', N'106.475', N'104.1', N'104.4', N'3200', N'106.475', N'106.475', NULL, N'103.875')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (6, N'SBGI 6 3/8 11/01/21', N'SBGI 6 3/8 11/01/21', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US829259AQ34', N'SBGI', N'COEJ9984950', N'829259AQ3', N'BJL5G31', NULL, NULL, NULL, N'2', N'6.375', N'Fixed', NULL, 1, 0, 0, NULL, NULL, NULL, N'60', N'0', NULL, NULL, 1, N'5.587', N'5.737', N'7.052', N'0.2', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Media', N'Television', N'Communications', N'UNITED STATES', N'USD', N'SINCLAIR TELEVISION GROU', N'USD', NULL, N'0', N'103.204', N'103.204', N'101.636', N'101.725', N'1600', N'100.237', N'101.72', NULL, N'104.781')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (7, N'SPB 6 5/8 11/15/22', N'SPB 6 5/8 11/15/22', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US84762LAQ86', N'SPB', N'COEK0025677', N'84762LAQ8', N'BJ3Q665', NULL, NULL, NULL, N'2', N'6.625', N'Fixed', NULL, 1, 0, 0, NULL, NULL, NULL, N'60', N'0', NULL, NULL, 1, N'6.254', N'3.598', N'3.568', N'0.082', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Household Products/Wares', N'Consumer Products-Misc', N'Consumer, Non-cyclical', N'UNITED STATES', N'USD', N'SPECTRUM BRANDS INC', N'USD', NULL, N'0', N'106.836', N'106.836', N'106.059', N'106.059', N'1400', N'105.689', N'106.262', NULL, N'103.3125')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (8, N'S 7 7/8 09/15/23', N'S 7 7/8 09/15/23', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US85207UAF21', N'S', N'COEK5536603', N'85207UAF2', N'BSDRYY5', NULL, NULL, NULL, N'2', N'7.875', N'Fixed', NULL, 0, 0, 0, NULL, NULL, NULL, N'0', N'0', NULL, NULL, 1, N'6.297', N'0', N'0', N'0.479', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Telecommunications', N'Cellular Telecom', N'Communications', N'UNITED STATES', N'USD', N'SPRINT CORP', N'USD', NULL, N'0', N'100.577', N'100.577', N'99.043', N'99.392', N'1321', N'98.35', N'99.464', NULL, N'0')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (9, N'TAYMON 5 5/8 03/01/24', N'TAYMON 5 5/8 03/01/24', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US877249AD49', N'TAYMON', N'COEK1028860', N'877249AD4', N'BK8PHJ4', NULL, NULL, NULL, N'2', N'5.625', N'Fixed', NULL, 1, 0, 0, NULL, NULL, NULL, N'60', N'0', NULL, NULL, 1, N'7.09', N'12.039', N'0', N'0.591', N'793.24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Home Builders', N'Bldg-Residential/Commer', N'Consumer, Cyclical', N'UNITED STATES', N'USD', N'TAYLOR MORRISON COMM/MON', N'USD', NULL, N'0', N'96', N'96', N'94', N'94.22', N'1450', N'96', N'96', NULL, N'100')
GO
INSERT [dbo].[CorporateBond] ([SecurityId], [Name], [Description], [AssetType], [InvestmentType], [TradingFactor], [PricingFactor], [ISIN], [BBG_Ticker], [BBG_UniqueID], [CUSIP], [SEDOL], [FirstCouponDate], [Cap], [BondFloor], [CouponFrequency], [Coupon], [CouponType], [Spread], [CallableFlag], [FixToFloatFlag], [PutableFlag], [IssueDate], [LastResetDate], [Maturity], [CallNotificationMaxDays], [PutNotificationMaxDays], [PenultimateCouponDate], [ResetFrequency], [HasPosition], [MacaulayDuration], [Volatility_30D], [Volatility_90D], [Convexity], [AverageVolume_30D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [BBG_IndustryGroup], [BBG_IndustrySubGroup], [BBG_IndustrySector], [CountryOfIssuance], [IssueCurrency], [Issuer], [RiskCurrency], [PutDate], [PutPrice], [AskPrice], [HighPrice], [LowPrice], [OpenPrice], [Volume], [BidPrice], [LastPrice], [CallDate], [CallPrice]) VALUES (10, N'THC 5 1/2 03/01/19', N'THC 5 1/2 03/01/19', N'Fixed Income', N'Corporate Bond', N'1', N'1', N'US88033GCH11', N'THC', N'COEK5144002', N'88033GCH1', N'BR1W5M0', NULL, NULL, NULL, N'2', N'5.5', N'Fixed', NULL, 0, 0, 0, NULL, NULL, NULL, N'0', N'0', NULL, NULL, 1, N'3.72', N'10.548', N'0', N'0.159', N'1917.333', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Healthcare-Services', N'Medical-Hospitals', N'Consumer, Non-cyclical', N'UNITED STATES', N'USD', N'TENET HEALTHCARE CORP', N'USD', NULL, N'0', N'101.875', N'101.875', N'101.875', N'101.875', N'1000', N'101.875', N'101.875', NULL, N'0')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (1, N'IBM US', N'International Business Machines Corp', 1, 1, N'100', N'IBM US', N'459200101', N'US4592001014', N'2005973', N'IBM', N'EQ0010080100001000', N'BBG000BLNNH6', N'IBM US', 0, NULL, NULL, N'0', NULL, N'USD', N'2', N'9.896605E+08', N'1', N'5956690', N'0.7301935', N'21437944', N'-10.36328', N'18.6750946', N'Equity', N'United States of America', N'AA+', N'United States Dollar (USD)', N'Securities', N'<7 Days', NULL, N'Computer & Peripheral Equipment Mfg', N'North America', NULL, N'Other listed equity', N'UNITED STATES', N'Multi-Listed US Exchanges', N'IBM', N'USD', N'USD', N'Computer Software', N'Computers', N'Technology', N'UNITED STATES', N'USD', N'164.16', N'164.16', N'3817529', N'164.16', N'187.68', N'187.67', N'9.762407', NULL, NULL, NULL, NULL, N'1.12', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (2, N'SAMSUNG C&T CORP', N'SAMSUNG C&T CORP', 1, 1, N'100', N'SAMSUNG C&T CORP', NULL, N'KR7000830000', N'6771601', N'KS', N'EQ0011792500001001', NULL, N'KS KR', 0, NULL, NULL, N'0', NULL, N'KRW', N'2', N'0', N'1', N'0', N'1', N'0', N'0', N'0', N'Equity', N'South Korea', N'A-', N'South Korean Won', N'Securities', N'<7 Days', NULL, NULL, N'Asia and Pacific (other than the middle east)', NULL, N'Other listed equity', N'SOUTH KOREA', N'KOSPI', N'Samsung C&T Corporation', N'KRW', N'KRW', N'Distribution/Wholesale', N'Distribution/Wholesale', N'Consumer, Cyclical', N'SOUTH KOREA', N'KRW', N'1378000', N'1377992', N'0', N'1378000', N'1381025', N'1381000', N'19.77', NULL, NULL, NULL, NULL, N'0.8', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (3, N'YELP US', N'YELP INC', 1, 1, N'100', N'YELP US', N'985817105', N'US9858171054', N'B7KCD72', N'YELP', N'EQ0000000009491916', N'BBG000Q2HM09', N'YELP US', 0, NULL, NULL, N'0', NULL, N'USD', N'2', N'6.169416E+07', N'1', N'0', N'2.18101835', N'0', N'0', N'0', N'Equity', N'United States of America', N'A-', N'United States Dollar (USD)', N'Securities', N'<7 Days', NULL, NULL, N'North America', NULL, N'Other listed equity', N'UNITED STATES', N'Multi-Listed US Exchanges', N'YELP', N'USD', N'USD', N'Internet Content-Info/Ne', N'Internet', N'Communications', N'UNITED STATES', N'USD', N'82.03', N'82.86', N'439147', N'82.22', N'82.22', N'82.12', N'23.54', NULL, NULL, NULL, NULL, N'0.45', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (4, N'EBAY US', N'EBAY INC', 1, 1, N'100', N'EBAY US', N'278642103', N'US2786421030', N'2293819', N'EBAY', N'EQ0034854600001000', N'BBG000C43RR5', N'EBAY US', 0, NULL, NULL, N'0', NULL, N'USD', N'2', N'1.24236723E+09', N'1', N'9340867', N'0.8524748', N'1.72628E+07', N'0.1603709', N'25.3783875', N'Equity', N'United States of America', N'AA-', N'United States Dollar (USD)', N'Securities', N'<7 Days', NULL, NULL, N'North America', NULL, N'Other listed equity', N'UNITED STATES', N'Multi-Listed US Exchanges', N'eBay Inc', N'USD', N'USD', N'E-Commerce/Products', N'Internet', N'Communications', N'UNITED STATES', N'USD', N'56.38', N'56.12', N'5901204', N'56.21', N'56.2', N'56.19', N'12.67', NULL, NULL, NULL, NULL, N'0.335', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (5, N'ADT US', N'ADT CORP/THE', 1, 1, N'100', N'ADT US', N'00101J106', N'US00101J1060', N'B7XWRM2', N'ADT', N'EQ0000000025528823', N'BBG003641015', N'ADT US', 0, NULL, NULL, N'0', NULL, N'USD', N'2', N'174527456', N'1', N'2409494.5', N'1.44243121', N'38769616', N'-8.053606', N'30.2886143', N'Equity', N'United States of America', N'AA+', N'United States Dollar (USD)', N'Securities', N'<7 Days', NULL, NULL, N'North America', NULL, N'Other listed equity', N'UNITED STATES', N'Multi-Listed US Exchanges', N'ADT Corp/The', N'USD', N'USD', N'Security Services', N'Commercial Services', N'Consumer, Non-cyclical', N'UNITED STATES', N'USD', N'36', N'36.14', N'1535032', N'36.33', N'36.35', N'36.34', N'17.8768082', NULL, NULL, NULL, NULL, N'0.2', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (6, N'CEVA HOLDINGS LLC', N'CEVA HOLDINGS LLC', 1, 1, N'100', N'CEVA HOLDINGS LLC', NULL, NULL, NULL, N'0813700D', N'EQ0000000030351217', N'BBG004MKGLD4', N'0813700D MH', 0, NULL, NULL, N'0', NULL, N'GBP', N'2', N'0.443', N'1', N'0', N'1', N'0', N'0', N'0', N'Equity', N'Marshall Islands', N'BBB+', N'Great Britain Pound Sterling (GBP)', N'Securities', N'<7 Days', NULL, NULL, N'Europe (EEA)', NULL, N'Other listed equity', N'BRITAIN', N'NYSE LIFFE - London', N'CEVA Holdings LLC', N'GBP', N'GBP', N'Transport-Services', N'Transportation', N'Industrial', N'MARSHALL ISLAND', N'GBP', N'17.78', N'18', N'0', N'18', N'19.32', N'19.08', N'45.21', NULL, NULL, NULL, NULL, N'0', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (7, N'AF FP', N'AIR FRANCE-KLM', 1, 1, N'100', N'AF FP', NULL, N'FR0000031122', N'4916039', N'AF', N'EQ0015604900001000', N'BBG000K79P88', N'AF FR', 0, NULL, NULL, N'0', NULL, N'EUR', N'2', N'300219264', N'1', N'3520425', N'1.353079', N'0', N'1.469112', N'45.36775', N'Equity', N'France', N'BBB+', N'Euro (EUR)', N'Securities', N'<7 Days', NULL, NULL, N'Europe (EEA)', NULL, N'Other listed equity', N'FRANCE', N'Euronext Paris', N'AIR FRANCE-KLM', N'EUR', N'EUR', N'Airlines', N'Airlines', N'Consumer, Cyclical', N'FRANCE', N'EUR', N'8.059', N'7.964', N'2197327', N'8.081', N'8.083', N'8.08', N'15.44', NULL, NULL, NULL, NULL, N'0.255', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (8, N'GME US', N'GAMESTOP CORP-CLASS A', 1, 1, N'100', N'GME US', N'36467W109', N'US36467W1099', N'B0LLFT5', N'GME', N'EQ0175290900001000', N'BBG000BB5BF6', N'GME US', 0, NULL, NULL, N'0', NULL, N'USD', N'2', N'108515424', N'1', N'3788714.5', N'1.2959578', N'48087372', N'0', N'42.6442528', N'Equity', N'United States of America', N'A', N'United States Dollar (USD)', N'Securities', N'<7 Days', NULL, NULL, N'North America', NULL, N'Other listed equity', N'UNITED STATES', N'Multi-Listed US Exchanges', N'GameStop Corp', N'USD', N'USD', N'Retail-Computer Equip', N'Retail', N'Consumer, Cyclical', N'UNITED STATES', N'USD', N'34.06', N'33.8', N'1612946', N'33.8', N'33.82', N'33.81', N'10.4909449', NULL, NULL, NULL, NULL, N'0.33', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (9, N'QIHU US', N'QIHOO 360 TECHNOLOGY CO-ADR', 1, 1, N'100', N'QIHU US', N'74734M109', N'US74734M1099', N'B4MWN57', N'QIHU', N'EQ0000000016977108', N'BBG001KR2ST0', N'QIHU KY', 0, NULL, NULL, N'0', NULL, N'USD', N'2', N'8.941548E+07', N'1.5', N'2639901.75', N'1.27837777', N'8448916', N'2.846666', N'47.5457535', N'Equity', N'Cayman Islands', N'BBB', N'United States Dollar (USD)', N'Securities', N'<7 Days', NULL, NULL, N'North America', NULL, N'Other listed equity', N'UNITED STATES', N'Multi-Listed US Exchanges', N'Qihoo 360 Technology Co. Ltd', N'USD', N'USD', N'Internet Security', N'Internet', N'Communications', N'CAYMAN ISLANDS', N'USD', N'59.37', N'59', N'589097', N'58.89', N'58.88', N'58.82', N'75.019104', NULL, NULL, NULL, NULL, N'0.5', NULL, N'Cash')
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (10, N'DWNI GR', N'DEUTSCHE WOHNEN AG-BR', 1, 1, N'100', N'DWNI GR', NULL, N'DE000A0HN5C6', N'B0YZ0Z5', N'DWNI', N'EQ0000000002399907', N'BBG000GM5V54', N'DWNI DE', 0, NULL, NULL, N'0', NULL, N'EUR', N'2', N'294259968', N'1', N'715150.7', N'0.7474221', N'0', N'1.103164', N'17.34133', N'Equity', N'Germany', N'AA', N'Euro (EUR)', N'Securities', N'<7 Days', NULL, NULL, N'Europe (EEA)', NULL, N'Other listed equity', N'GERMANY', N'Eurex Deutschland', N'DEUTSCHE WOHNEN AG', N'EUR', N'EUR', N'Real Estate Mgmnt/Servic', N'Real Estate', N'Financial', N'GERMANY', N'EUR', N'19.685', N'19.704', N'929464', N'19.796', N'19.789', N'19.789', N'14.9969692', NULL, NULL, NULL, NULL, N'0.34', NULL, N'Cash')
GO
SET IDENTITY_INSERT [dbo].[SecurityAttributes] ON 

GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (64, 1, N'Security Id', N'SecurityId', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (65, 1, N'Security Name', N'Name', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (66, 1, N'Security Description', N'Description', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (67, 1, N'Has Position', N'HasPosition', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (68, 1, N'Is Active Security', N'IsActiveSecurity', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (69, 1, N'Lot Size', N'LotSize', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (70, 1, N'BBG Unique Name', N'BBG_UniqueName', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (71, 1, N'CUSIP', N'CUSIP', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (72, 1, N'ISIN', N'ISIN', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (73, 1, N'SEDOL', N'SEDOL', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (74, 1, N'Bloomberg Ticker', N'BBG_Ticker', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (75, 1, N'Bloomberg Unique ID', N'BBG_UniqueID', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (76, 1, N'BBG Global ID', N'BBG_GlobalID', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (77, 1, N'Ticker and Exchange', N'TickerAndExchange', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (78, 1, N'Is ADR Flag', N'IsAdrFlag', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (79, 1, N'ADR Underlying Ticker', N'AdrUnderlyingTicker', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (80, 1, N'ADR Underlying Currency', N'AdrUnderlyingCurrency', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (81, 1, N'Shares Per ADR', N'SharesPerADR', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (82, 1, N'IPO Date', N'IPODate', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (83, 1, N'Pricing Currency', N'PricingCurrency', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (84, 1, N'Settle Days', N'SettleDays', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (85, 1, N'Total Shares Outstanding', N'TotalSharesOutstanding', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (86, 1, N'Voting Rights Per Share', N'VotingRightsPerShare', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (87, 1, N'Average Volume - 20D', N'AverageVolume_20D', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (88, 1, N'Beta', N'Beta', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (89, 1, N'Short Interest', N'ShortInterest', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (90, 1, N'Return - YTD', N'Return_YTD', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (91, 1, N'Volatility - 90D', N'Volatility_90D', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (92, 1, N'PF Asset Class', N'PF_AssetClass', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (93, 1, N'PF Country', N'PF_Country', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (94, 1, N'PF Credit Rating', N'PF_CreditRating', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (95, 1, N'PF Currency', N'PF_Currency', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (96, 1, N'PF Instrument', N'PF_Instrument', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (97, 1, N'PF Liquidity Profile', N'PF_LiquidityProfile', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (98, 1, N'PF Maturity', N'PF_Maturity', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (99, 1, N'PF NAICS Code', N'PF_NAICS_Code', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (100, 1, N'PF Region', N'PF_Region', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (101, 1, N'PF Sector', N'PF_Sector', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (102, 1, N'PF Sub Asset Class', N'PF_SubAssetClass', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (103, 1, N'Country of Issuance', N'CountryOfIssuance', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (104, 1, N'Exchange', N'Exchange', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (105, 1, N'Issuer', N'Issuer', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (106, 1, N'Issue Currency', N'IssueCurrency', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (107, 1, N'Trading Currency', N'TradingCurrency', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (108, 1, N'BBG Industry Sub Group', N'BBG_IndustrySubGroup', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (109, 1, N'Bloomberg Industry Group', N'BBG_IndustryGroup', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (110, 1, N'Bloomberg Sector', N'BBG_Sector', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (111, 1, N'Country of Incorporation', N'CountryOfIncorporation', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (112, 1, N'Risk Currency', N'RiskCurrency', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (113, 1, N'Open Price', N'OpenPrice', N'Pricing Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (114, 1, N'Close Price', N'ClosePrice', N'Pricing Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (115, 1, N'Volume', N'Volume', N'Pricing Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (116, 1, N'Last Price', N'LastPrice', N'Pricing Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (117, 1, N'Ask Price', N'AskPrice', N'Pricing Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (118, 1, N'Bid Price', N'BidPrice', N'Pricing Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (119, 1, N'PE Ratio', N'PE_Ratio', N'Pricing Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (120, 1, N'Dividend Declared Date', N'DividendDeclaredDate', N'Dividend History', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (121, 1, N'Dividend Ex Date', N'DividendExDate', N'Dividend History', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (122, 1, N'Dividend Record Date ', N'DividendRecordDate', N'Dividend History', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (123, 1, N'Dividend Pay Date', N'DividendPayDate', N'Dividend History', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (124, 1, N'Dividend Amount', N'DividendAmount', N'Dividend History', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (125, 1, N'Frequency', N'Frequency', N'Dividend History', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (126, 1, N'Dividend Type', N'DividendType', N'Dividend History', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (127, 2, N'Security Id', N'SecurityId', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (128, 2, N'Security Description', N'Name', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (129, 2, N'Security Name', N'Description', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (130, 2, N'Asset Type', N'AssetType', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (131, 2, N'Investment Type', N'InvestmentType', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (132, 2, N'Trading Factor', N'TradingFactor', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (133, 2, N'Pricing Factor', N'PricingFactor', N'Security Summary', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (134, 2, N'ISIN', N'ISIN', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (135, 2, N'BBG Ticker', N'BBG_Ticker', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (136, 2, N'BBG Unique ID', N'BBG_UniqueID', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (137, 2, N'CUSIP', N'CUSIP', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (138, 2, N'SEDOL', N'SEDOL', N'Security Identifier', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (139, 2, N'First Coupon Date', N'FirstCouponDate', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (140, 2, N'Cap', N'Cap', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (141, 2, N'Floor', N'BondFloor', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (142, 2, N'Coupon Frequency', N'CouponFrequency', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (143, 2, N'Coupon', N'Coupon', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (144, 2, N'Coupon Type', N'CouponType', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (145, 2, N'Spread', N'Spread', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (146, 2, N'Callable Flag', N'CallableFlag', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (147, 2, N'Fix to Float Flag', N'FixToFloatFlag', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (148, 2, N'Putable Flag', N'PutableFlag', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (149, 2, N'Issue Date', N'IssueDate', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (150, 2, N'Last Reset Date', N'LastResetDate', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (151, 2, N'Maturity', N'Maturity', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (152, 2, N'Call Notification Max Days', N'CallNotificationMaxDays', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (153, 2, N'Put Notification Max Days', N'PutNotificationMaxDays', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (154, 2, N'Penultimate Coupon Date', N'PenultimateCouponDate', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (155, 2, N'Reset Frequency', N'ResetFrequency', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (156, 2, N'Has Position', N'HasPosition', N'Security Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (157, 2, N'Macaulay Duration', N'MacaulayDuration', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (158, 2, N'30D Volatility', N'Volatility_30D', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (159, 2, N'90D Volatility', N'Volatility_90D', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (160, 2, N'Convexity', N'Convexity', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (161, 2, N'30Day Average Volume', N'AverageVolume_30D', N'Risk', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (162, 2, N'PF Asset Class', N'Pf_AssetClass', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (163, 2, N'PF Country', N'Pf_Country', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (164, 2, N'PF Credit Rating', N'Pf_CreditRating', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (165, 2, N'PF Currency', N'Pf_Currency', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (166, 2, N'PF Instrument', N'Pf_Instrument', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (167, 2, N'PF Liquidity Profile', N'Pf_LiquidityProfile', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (168, 2, N'PF Maturity', N'Pf_Maturity', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (169, 2, N'PF NAICS Code', N'Pf_NAICS_Code', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (170, 2, N'PF Region', N'Pf_Region', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (171, 2, N'PF Sector', N'Pf_Sector', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (172, 2, N'PF Sub Asset Class', N'Pf_SubAssetClass', N'Regulatory Details', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (173, 2, N'Bloomberg Industry Group', N'BBG_IndustryGroup', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (174, 2, N'Bloomberg Industry Sub Group', N'BBG_IndustrySubGroup', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (175, 2, N'Bloomberg Industry Sector', N'BBG_IndustrySector', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (176, 2, N'Country of Issuance', N'CountryOfIssuance', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (177, 2, N'Issue Currency', N'IssueCurrency', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (178, 2, N'Issuer', N'Issuer', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (179, 2, N'Risk Currency', N'RiskCurrency', N'Reference Data', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (180, 2, N'Put Date', N'PutDate', N'Put Schedule', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (181, 2, N'Put Price', N'PutPrice', N'Put Schedule', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (182, 2, N'Ask Price', N'AskPrice', N'Pricing and Analytics', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (183, 2, N'High Price', N'HighPrice', N'Pricing and Analytics', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (184, 2, N'Low Price', N'LowPrice', N'Pricing and Analytics', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (185, 2, N'Open Price', N'OpenPrice', N'Pricing and Analytics', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (186, 2, N'Volume', N'Volume', N'Pricing and Analytics', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (187, 2, N'Bid Price', N'BidPrice', N'Pricing and Analytics', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (188, 2, N'Last Price', N'LastPrice', N'Pricing and Analytics', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (189, 2, N'Call Date', N'CallDate', N'Call Schedule', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [TabName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (190, 2, N'Call Price', N'CallPrice', N'Call Schedule', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[SecurityAttributes] OFF
GO
INSERT [dbo].[SecurityType] ([SecurityTypeId], [SecurityTypeName], [SecurityClassName], [TableName], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (1, N'Equity Common Stock', N'Equity', N'Equity', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[SecurityType] ([SecurityTypeId], [SecurityTypeName], [SecurityClassName], [TableName], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (2, N'Corporate Bond', N'CorporateBond', N'CorporateBond', NULL, NULL, NULL, NULL, 1)
GO
USE [master]
GO
ALTER DATABASE [SecurityMaster] SET  READ_WRITE 
GO
