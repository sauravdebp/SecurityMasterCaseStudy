USE [master]
GO
/****** Object:  Database [SecurityMaster]    Script Date: 23-Jan-16 1:00:56 AM ******/
CREATE DATABASE [SecurityMaster]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SecurityMaster', FILENAME = N'C:\Users\saura_000\Desktop\CaseStudy\SecurityMaster.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SecurityMaster_log', FILENAME = N'C:\Users\saura_000\Desktop\CaseStudy\SecurityMaster_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
/****** Object:  StoredProcedure [dbo].[CreateSecurity]    Script Date: 23-Jan-16 1:00:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateSecurity]
(
	@securityTypeId int,
	@xml XML
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(200), @query VARCHAR(MAX)
	--DECLARE @security_type_name VARCHAR(50)
	--SELECT @security_type_name = 'ivp_equity_common_stock'

	SELECT @entity_name = TableName
	FROM SecurityType
	WHERE SecurityTypeId = @securityTypeId

	SET @query = ' DECLARE @security_data XML; '
	SET @query = @query + 'SELECT @security_data = ''' + CONVERT(VARCHAR(MAX), @xml) + ''';' + CHAR(13)	--Assigning the xml data to security data var
	SELECT @query = @query + 'INSERT INTO ' + @entity_name + ' (SecurityId, Name, Description)'	--THIS STATEMENT IS FOR TESTING ONLY
	--SELECT @query = @query + 'INSERT INTO ' + @entity_name	--This is the final statement to be used. NOT THE ABOVE ONE
	SELECT @query = @query + 'SELECT'
	
	--The below part will generate a table which will have all the @entity_name attributes using the sys.columns table
	SELECT @query = @query + ' CASE WHEN doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') = '''' THEN NULL ELSE doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') END [' + name + '], ' + CHAR(13) 
	FROM sys.columns 
	WHERE object_id = OBJECT_ID(@entity_name,'TABLE') 
	AND name IN ('SecurityId', 'Name', 'Description')	--THIS STATEMENT IS FOR TESTING ONLY
	ORDER BY sys.columns.column_id
	
	--The below part is specifying in the generated query to use the XML
	SELECT @query = LEFT(@query, LEN(@query) - 3) +  ' FROM @security_data.nodes(''/Securities/Security'') doc(col); ' + CHAR(13) 
	
	PRINT @query

	EXECUTE (@query)
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteSecurity]    Script Date: 23-Jan-16 1:00:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteSecurity]
(
	@securityTypeId int,
	@securityId int
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(100)
	DECLARE @query VARCHAR(500)

	SELECT @entity_name = TableName
	FROM SecurityType
	WHERE SecurityTypeId = @securityTypeId
	
	SET @query = 'DELETE FROM ' + @entity_name + ' WHERE SecurityId = ' + CONVERT(VARCHAR(MAX), @securityId)

	EXECUTE(@query)
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateSecurity]    Script Date: 23-Jan-16 1:00:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateSecurity]
(
	@securityTypeId INT,
	@xml XML
)
AS
BEGIN
	--DECLARE @securityId INT
	--retrieve securityId from XML
	DECLARE @deleteQuery VARCHAR(500)

	SET @deleteQuery = ' '

	SELECT
		@deleteQuery = @deleteQuery + 'EXEC DeleteSecurity ' + CONVERT(VARCHAR(MAX), @securityTypeId) + ', ' + doc.col.value('SecurityId[1]', 'VARCHAR(MAX)') + ';'
	FROM @xml.nodes('Securities/Security') doc(col)
	
	EXECUTE(@deleteQuery)
	EXEC CreateSecurity @securityTypeId, @xml
END
GO
/****** Object:  Table [dbo].[CorporateBond]    Script Date: 23-Jan-16 1:00:57 AM ******/
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
	[TradingFactor] [numeric](17, 2) NULL,
	[PricingFactor] [numeric](17, 2) NULL,
	[ISIN] [varchar](max) NULL,
	[BBG_Ticker] [varchar](max) NULL,
	[BBG_UniqueID] [varchar](max) NULL,
	[CUSIP] [varchar](max) NULL,
	[SEDOL] [varchar](max) NULL,
	[FirstCouponDate] [datetime] NULL,
	[Cap] [varchar](max) NULL,
	[BondFloor] [varchar](max) NULL,
	[CouponFrequency] [numeric](7, 2) NULL,
	[Coupon] [numeric](17, 2) NULL,
	[CouponType] [varchar](max) NULL,
	[Spread] [varchar](max) NULL,
	[CallableFlag] [bit] NULL,
	[FixToFloatFlag] [bit] NULL,
	[PutableFlag] [bit] NULL,
	[IssueDate] [datetime] NULL,
	[LastResetDate] [datetime] NULL,
	[Maturity] [datetime] NULL,
	[CallNotificationMaxDays] [numeric](7, 2) NULL,
	[PutNotificationMaxDays] [numeric](7, 2) NULL,
	[PenultimateCouponDate] [datetime] NULL,
	[ResetFrequency] [varchar](max) NULL,
	[HasPosition] [bit] NULL,
	[MacaulayDuration] [numeric](17, 2) NULL,
	[Volatility_30D] [numeric](17, 2) NULL,
	[Volatility_90D] [numeric](17, 2) NULL,
	[Convexity] [numeric](17, 2) NULL,
	[AverageVolume_30D] [numeric](17, 2) NULL,
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
	[PutPrice] [numeric](17, 2) NULL,
	[AskPrice] [numeric](17, 2) NULL,
	[HighPrice] [numeric](17, 2) NULL,
	[LowPrice] [numeric](17, 2) NULL,
	[OpenPrice] [numeric](17, 2) NULL,
	[Volume] [numeric](17, 2) NULL,
	[BidPrice] [numeric](17, 2) NULL,
	[LastPrice] [numeric](17, 2) NULL,
	[CallDate] [datetime] NULL,
	[CallPrice] [numeric](17, 2) NULL,
 CONSTRAINT [PK_CorporateBond] PRIMARY KEY CLUSTERED 
(
	[SecurityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Equity]    Script Date: 23-Jan-16 1:00:57 AM ******/
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
	[LotSize] [numeric](10, 0) NULL,
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
	[SharesPerADR] [numeric](10, 2) NULL,
	[IPODate] [datetime] NULL,
	[PricingCurrency] [varchar](max) NULL,
	[SettleDays] [numeric](4, 0) NULL,
	[TotalSharesOutstanding] [numeric](17, 2) NULL,
	[VotingRightsPerShare] [numeric](5, 0) NULL,
	[AverageVolume_20D] [numeric](17, 2) NULL,
	[Beta] [numeric](16, 15) NULL,
	[ShortInterest] [numeric](17, 2) NULL,
	[Return_YTD] [numeric](17, 2) NULL,
	[Volatility_90D] [numeric](17, 2) NULL,
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
	[OpenPrice] [numeric](17, 2) NULL,
	[ClosePrice] [numeric](17, 2) NULL,
	[Volume] [numeric](17, 2) NULL,
	[LastPrice] [numeric](17, 2) NULL,
	[AskPrice] [numeric](17, 2) NULL,
	[BidPrice] [numeric](17, 2) NULL,
	[PE_Ratio] [numeric](17, 2) NULL,
	[DividendDeclaredDate] [datetime] NULL,
	[DividendExDate] [datetime] NULL,
	[DividendRecordDate] [datetime] NULL,
	[DividendPayDate] [datetime] NULL,
	[DividendAmount] [numeric](17, 2) NULL,
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
/****** Object:  Table [dbo].[Security]    Script Date: 23-Jan-16 1:00:57 AM ******/
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
/****** Object:  Table [dbo].[SecurityAttributes]    Script Date: 23-Jan-16 1:00:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SecurityAttributes](
	[AttributeId] [nchar](10) NULL,
	[SecurityTypeId] [int] NULL,
	[AttributeDisplayName] [varchar](100) NULL,
	[AttributeRealName] [varchar](50) NULL,
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
/****** Object:  Table [dbo].[SecurityType]    Script Date: 23-Jan-16 1:00:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SecurityType](
	[SecurityTypeId] [int] NOT NULL,
	[SecurityTypeName] [varchar](50) NULL,
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
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (25, N'MICROSOFT', N'Microsoft Stock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Equity] ([SecurityId], [Name], [Description], [HasPosition], [IsActiveSecurity], [LotSize], [BBG_UniqueName], [CUSIP], [ISIN], [SEDOL], [BBG_Ticker], [BBG_UniqueID], [BBG_GlobalID], [TickerAndExchange], [IsAdrFlag], [AdrUnderlyingTicker], [AdrUnderlyingCurrency], [SharesPerADR], [IPODate], [PricingCurrency], [SettleDays], [TotalSharesOutstanding], [VotingRightsPerShare], [AverageVolume_20D], [Beta], [ShortInterest], [Return_YTD], [Volatility_90D], [PF_AssetClass], [PF_Country], [PF_CreditRating], [PF_Currency], [PF_Instrument], [PF_LiquidityProfile], [PF_Maturity], [PF_NAICS_Code], [PF_Region], [PF_Sector], [PF_SubAssetClass], [CountryOfIssuance], [Exchange], [Issuer], [IssueCurrency], [TradingCurrency], [BBG_IndustrySubGroup], [BBG_IndustryGroup], [BBG_Sector], [CountryOfIncorporation], [RiskCurrency], [OpenPrice], [ClosePrice], [Volume], [LastPrice], [AskPrice], [BidPrice], [PE_Ratio], [DividendDeclaredDate], [DividendExDate], [DividendRecordDate], [DividendPayDate], [DividendAmount], [Frequency], [DividendType]) VALUES (26, N'crAPPLE', N'Apple Equity', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityType] ([SecurityTypeId], [SecurityTypeName], [TableName], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (1, N'Equity Common Stock', N'Equity', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[SecurityType] ([SecurityTypeId], [SecurityTypeName], [TableName], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (2, N'Corporate Bond', N'CorporateBond', NULL, NULL, NULL, NULL, 1)
GO
USE [master]
GO
ALTER DATABASE [SecurityMaster] SET  READ_WRITE 
GO
