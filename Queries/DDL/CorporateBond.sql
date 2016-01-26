USE [SecurityMaster]
GO

/****** Object:  Table [dbo].[CorporateBond]    Script Date: 26-Jan-16 3:06:26 AM ******/
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


