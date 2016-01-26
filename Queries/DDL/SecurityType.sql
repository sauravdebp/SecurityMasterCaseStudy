USE [SecurityMaster]
GO

/****** Object:  Table [dbo].[SecurityType]    Script Date: 26-Jan-16 3:07:21 AM ******/
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


