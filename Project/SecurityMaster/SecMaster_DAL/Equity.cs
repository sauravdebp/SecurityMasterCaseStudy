using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Data.SqlTypes;

namespace SecMaster_DAL.DataModel
{
    [Serializable]
    public class Equity : Security
    {
        
        
        public bool HasPosition { get; set; }
        public bool IsActiveSecurity { get; set; }
        public float LotSize { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_UniqueName { get; set; }
        [XmlElement(IsNullable = true)]
        public string CUSIP { get; set; }
        [XmlElement(IsNullable = true)]
        public string ISIN { get; set; }
        [XmlElement(IsNullable = true)]
        public string SEDOL { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_Ticker { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_UniqueID { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_GlobalID { get; set; }
        [XmlElement(IsNullable = true)]
        public string TickerAndExchange { get; set; }
        public bool IsAdrFlag { get; set; }
        [XmlElement(IsNullable = true)]
        public string AdrUnderlyingTicker { get; set; }
        [XmlElement(IsNullable = true)]
        public string AdrUnderlyingCurrency { get; set; }
        public float SharesPerADR { get; set; }
        public SqlDateTime IPODate { get; set; }
        public string PricingCurrency { get; set; }
        public float SettleDays { get; set; }
        public float TotalSharesOutstanding { get; set; }
        public float VotingRightsPerShare { get; set; }
        public float AverageVolume_20D { get; set; }
        public float Beta { get; set; }
        public float ShortInterest { get; set; }
        public float Return_YTD { get; set; }
        public float Volatility_90D { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_AssetClass { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_Country { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_CreditRating { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_Currency { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_Instrument { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_LiquidityProfile { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_Maturity { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_NAICS_Code { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_Region { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_Sector { get; set; }
        [XmlElement(IsNullable = true)]
        public string PF_SubAssetClass { get; set; }
        [XmlElement(IsNullable = true)]
        public string CountryOfIssuance { get; set; }
        [XmlElement(IsNullable = true)]
        public string Exchange { get; set; }
        [XmlElement(IsNullable = true)]
        public string Issuer { get; set; }
        [XmlElement(IsNullable = true)]
        public string IssueCurrency { get; set; }
        [XmlElement(IsNullable = true)]
        public string TradingCurrency { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_IndustrySubGroup { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_IndustryGroup { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_Sector { get; set; }
        [XmlElement(IsNullable = true)]
        public string CountryOfIncorporation { get; set; }
        [XmlElement(IsNullable = true)]
        public string RiskCurrency { get; set; }
        public float OpenPrice { get; set; }
        public float ClosePrice { get; set; }
        public float Volume { get; set; }
        public float LastPrice { get; set; }
        public float AskPrice { get; set; }
        public float BidPrice { get; set; }
        public float PE_Ratio { get; set; }
        public SqlDateTime DividendDeclaredDate { get; set; }
        public SqlDateTime DividendExDate { get; set; }
        public SqlDateTime DividendRecordDate { get; set; }
        public SqlDateTime DividendPayDate { get; set; }
        public float DividendAmount { get; set; }
        [XmlElement(IsNullable = true)]
        public string Frequency { get; set; }
        [XmlElement(IsNullable = true)]
        public string DividendType { get; set; }
    }
}