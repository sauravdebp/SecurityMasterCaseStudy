USE [SecurityMaster]
GO
/****** Object:  Table [dbo].[SecurityAttributes]    Script Date: 28-01-2016 12:30:57 ******/
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
SET IDENTITY_INSERT [dbo].[SecurityAttributes] ON 

GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (64, 1, N'Security Id', N'SecurityId', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (65, 1, N'Security Name', N'Name', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (66, 1, N'Security Description', N'Description', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (67, 1, N'Has Position', N'HasPosition', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (68, 1, N'Is Active Security', N'IsActiveSecurity', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (69, 1, N'Lot Size', N'LotSize', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (70, 1, N'BBG Unique Name', N'BBG_UniqueName', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (71, 1, N'CUSIP', N'CUSIP', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (72, 1, N'ISIN', N'ISIN', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (73, 1, N'SEDOL', N'SEDOL', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (74, 1, N'Bloomberg Ticker', N'BBG_Ticker', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (75, 1, N'Bloomberg Unique ID', N'BBG_UniqueID', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (76, 1, N'BBG Global ID', N'BBG_GlobalID', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (77, 1, N'Ticker and Exchange', N'TickerAndExchange', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (78, 1, N'Is ADR Flag', N'IsAdrFlag', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (79, 1, N'ADR Underlying Ticker', N'AdrUnderlyingTicker', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (80, 1, N'ADR Underlying Currency', N'AdrUnderlyingCurrency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (81, 1, N'Shares Per ADR', N'SharesPerADR', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (82, 1, N'IPO Date', N'IPODate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (83, 1, N'Pricing Currency', N'PricingCurrency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (84, 1, N'Settle Days', N'SettleDays', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (85, 1, N'Total Shares Outstanding', N'TotalSharesOutstanding', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (86, 1, N'Voting Rights Per Share', N'VotingRightsPerShare', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (87, 1, N'Average Volume - 20D', N'AverageVolume_20D', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (88, 1, N'Beta', N'Beta', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (89, 1, N'Short Interest', N'ShortInterest', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (90, 1, N'Return - YTD', N'Return_YTD', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (91, 1, N'Volatility - 90D', N'Volatility_90D', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (92, 1, N'PF Asset Class', N'PF_AssetClass', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (93, 1, N'PF Country', N'PF_Country', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (94, 1, N'PF Credit Rating', N'PF_CreditRating', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (95, 1, N'PF Currency', N'PF_Currency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (96, 1, N'PF Instrument', N'PF_Instrument', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (97, 1, N'PF Liquidity Profile', N'PF_LiquidityProfile', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (98, 1, N'PF Maturity', N'PF_Maturity', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (99, 1, N'PF NAICS Code', N'PF_NAICS_Code', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (100, 1, N'PF Region', N'PF_Region', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (101, 1, N'PF Sector', N'PF_Sector', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (102, 1, N'PF Sub Asset Class', N'PF_SubAssetClass', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (103, 1, N'Country of Issuance', N'CountryOfIssuance', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (104, 1, N'Exchange', N'Exchange', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (105, 1, N'Issuer', N'Issuer', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (106, 1, N'Issue Currency', N'IssueCurrency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (107, 1, N'Trading Currency', N'TradingCurrency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (108, 1, N'BBG Industry Sub Group', N'BBG_IndustrySubGroup', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (109, 1, N'Bloomberg Industry Group', N'BBG_IndustryGroup', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (110, 1, N'Bloomberg Sector', N'BBG_Sector', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (111, 1, N'Country of Incorporation', N'CountryOfIncorporation', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (112, 1, N'Risk Currency', N'RiskCurrency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (113, 1, N'Open Price', N'OpenPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (114, 1, N'Close Price', N'ClosePrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (115, 1, N'Volume', N'Volume', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (116, 1, N'Last Price', N'LastPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (117, 1, N'Ask Price', N'AskPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (118, 1, N'Bid Price', N'BidPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (119, 1, N'PE Ratio', N'PE_Ratio', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (120, 1, N'Dividend Declared Date', N'DividendDeclaredDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (121, 1, N'Dividend Ex Date', N'DividendExDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (122, 1, N'Dividend Record Date ', N'DividendRecordDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (123, 1, N'Dividend Pay Date', N'DividendPayDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (124, 1, N'Dividend Amount', N'DividendAmount', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (125, 1, N'Frequency', N'Frequency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (126, 1, N'Dividend Type', N'DividendType', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (127, 2, N'Security Id', N'SecurityId', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (128, 2, N'Security Description', N'Name', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (129, 2, N'Security Name', N'Description', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (130, 2, N'Asset Type', N'AssetType', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (131, 2, N'Investment Type', N'InvestmentType', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (132, 2, N'Trading Factor', N'TradingFactor', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (133, 2, N'Pricing Factor', N'PricingFactor', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (134, 2, N'ISIN', N'ISIN', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (135, 2, N'BBG Ticker', N'BBG_Ticker', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (136, 2, N'BBG Unique ID', N'BBG_UniqueID', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (137, 2, N'CUSIP', N'CUSIP', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (138, 2, N'SEDOL', N'SEDOL', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (139, 2, N'First Coupon Date', N'FirstCouponDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (140, 2, N'Cap', N'Cap', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (141, 2, N'Floor', N'BondFloor', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (142, 2, N'Coupon Frequency', N'CouponFrequency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (143, 2, N'Coupon', N'Coupon', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (144, 2, N'Coupon Type', N'CouponType', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (145, 2, N'Spread', N'Spread', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (146, 2, N'Callable Flag', N'CallableFlag', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (147, 2, N'Fix to Float Flag', N'FixToFloatFlag', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (148, 2, N'Putable Flag', N'PutableFlag', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (149, 2, N'Issue Date', N'IssueDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (150, 2, N'Last Reset Date', N'LastResetDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (151, 2, N'Maturity', N'Maturity', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (152, 2, N'Call Notification Max Days', N'CallNotificationMaxDays', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (153, 2, N'Put Notification Max Days', N'PutNotificationMaxDays', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (154, 2, N'Penultimate Coupon Date', N'PenultimateCouponDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (155, 2, N'Reset Frequency', N'ResetFrequency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (156, 2, N'Has Position', N'HasPosition', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (157, 2, N'Macaulay Duration', N'MacaulayDuration', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (158, 2, N'30D Volatility', N'Volatility_30D', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (159, 2, N'90D Volatility', N'Volatility_90D', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (160, 2, N'Convexity', N'Convexity', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (161, 2, N'30Day Average Volume', N'AverageVolume_30D', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (162, 2, N'PF Asset Class', N'Pf_AssetClass', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (163, 2, N'PF Country', N'Pf_Country', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (164, 2, N'PF Credit Rating', N'Pf_CreditRating', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (165, 2, N'PF Currency', N'Pf_Currency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (166, 2, N'PF Instrument', N'Pf_Instrument', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (167, 2, N'PF Liquidity Profile', N'Pf_LiquidityProfile', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (168, 2, N'PF Maturity', N'Pf_Maturity', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (169, 2, N'PF NAICS Code', N'Pf_NAICS_Code', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (170, 2, N'PF Region', N'Pf_Region', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (171, 2, N'PF Sector', N'Pf_Sector', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (172, 2, N'PF Sub Asset Class', N'Pf_SubAssetClass', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (173, 2, N'Bloomberg Industry Group', N'BBG_IndustryGroup', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (174, 2, N'Bloomberg Industry Sub Group', N'BBG_IndustrySubGroup', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (175, 2, N'Bloomberg Industry Sector', N'BBG_IndustrySector', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (176, 2, N'Country of Issuance', N'CountryOfIssuance', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (177, 2, N'Issue Currency', N'IssueCurrency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (178, 2, N'Issuer', N'Issuer', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (179, 2, N'Risk Currency', N'RiskCurrency', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (180, 2, N'Put Date', N'PutDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (181, 2, N'Put Price', N'PutPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (182, 2, N'Ask Price', N'AskPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (183, 2, N'High Price', N'HighPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (184, 2, N'Low Price', N'LowPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (185, 2, N'Open Price', N'OpenPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (186, 2, N'Volume', N'Volume', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (187, 2, N'Bid Price', N'BidPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (188, 2, N'Last Price', N'LastPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (189, 2, N'Call Date', N'CallDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[SecurityAttributes] ([AttributeId], [SecurityTypeId], [AttributeDisplayName], [AttributeRealName], [AttributeDataType], [AttributeLength], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn], [IsActive]) VALUES (190, 2, N'Call Price', N'CallPrice', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[SecurityAttributes] OFF
GO
