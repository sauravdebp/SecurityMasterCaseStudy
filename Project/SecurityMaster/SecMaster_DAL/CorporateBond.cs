using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Data.SqlTypes;

namespace SecMaster_DAL.DataModel
{
    [Serializable]
    public class CorporateBond : Security
    {
      
        [XmlElement(IsNullable = true)]
        public string AssetType { get; set; }
        [XmlElement(IsNullable = true)]
        public string InvestmentType { get; set; }
        public float TradingFactor { get; set; }
        public float PricingFactor { get; set; }
        [XmlElement(IsNullable = true)]
        public string ISIN { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_Ticker { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_UniqueID { get; set; }
        [XmlElement(IsNullable = true)]
        public string CUSIP { get; set; }
        [XmlElement(IsNullable = true)]
        public string SEDOL { get; set; }
        public SqlDateTime FirstCouponDate { get; set; }
        [XmlElement(IsNullable = true)]
        public string Cap { get; set; }
        [XmlElement(IsNullable = true)]
        public string BondFloor { get; set; }
        public float CouponFrequency { get; set; }
        public float Coupon { get; set; }
        [XmlElement(IsNullable = true)]
        public string CouponType { get; set; }
        [XmlElement(IsNullable = true)]
        public string Spread { get; set; }
        public bool CallableFlag { get; set; }
        public bool FixToFloatFlag { get; set; }
        public bool PutableFlag { get; set; }
        public SqlDateTime IssueDate { get; set; }
        public SqlDateTime LastResetDate { get; set; }
        public SqlDateTime Maturity { get; set; }
        public int CallNotificationMaxDays { get; set; }
        public int PutNotificationMaxDays { get; set; }
        public SqlDateTime PenultimateCouponDate { get; set; }
        [XmlElement(IsNullable = true)]
        public string ResetFrequency { get; set; }
        public bool HasPosition { get; set; }
        public float MacaulayDuration { get; set; }
        public float Volatility_30D { get; set; }
        public float Volatility_90D { get; set; }
        public float Convexity { get; set; }
        public float AverageVolume_30D { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_AssetClass { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_Country { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_CreditRating { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_Currency { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_Instrument { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_LiquidityProfile { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_Maturity { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_NAICS_Code { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_Region { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_Sector { get; set; }
        [XmlElement(IsNullable = true)]
        public string Pf_SubAssetClass { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_IndustryGroup { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_IndustrySubGroup { get; set; }
        [XmlElement(IsNullable = true)]
        public string BBG_IndustrySector { get; set; }
        [XmlElement(IsNullable = true)]
        public string CountryOfIssuance { get; set; }
        [XmlElement(IsNullable = true)]
        public string IssueCurrency { get; set; }
        [XmlElement(IsNullable = true)]
        public string Issuer { get; set; }
        [XmlElement(IsNullable = true)]
        public string RiskCurrency { get; set; }
        public SqlDateTime PutDate { get; set; }
        public float PutPrice { get; set; }
        public float AskPrice { get; set; }
        public float HighPrice { get; set; }
        public float LowPrice { get; set; }
        public float OpenPrice { get; set; }
        public float Volume { get; set; }
        public float BidPrice { get; set; }
        public float LastPrice { get; set; }
        public SqlDateTime CallDate { get; set; }
        public float CallPrice { get; set; }
    }
}