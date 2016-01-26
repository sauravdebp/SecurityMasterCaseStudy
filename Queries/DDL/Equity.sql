USE [SecurityMaster]
GO

/****** Object:  Table [dbo].[Equity]    Script Date: 26-Jan-16 3:06:50 AM ******/
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


