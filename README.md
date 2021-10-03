

# UI
Coinmarket cap: https://coinmarketcap.com/
https://coinmarketcap.com/defi/

Góra bardziej jak trading view
https://www.tradingview.com/

Wyszukiwarka z ?
https://lbry.tv/



* icons from twitter/linkedin/facebook
  * https://twitter.com/blackrock

# How to scrape

* https://demo.trading212.com/

* Download all etfs from current systems:
  - visit per market url, iterate over pages in filter
    - https://www.ishares.com/uk/individual/en/products/etf-investments#!type=all&view=keyFacts
  - create models
  - create initial instrument
  - download details per ishare
* Download pdf from mbank
  - match with fetched etf
* Download etf details that have attached broker
* add tests with https://github.com/oesmith/puffing-billy/blob/8b5d92184b8e275150bcb4dc818bcca94f080302/lib/billy/browsers/capybara.rb#L107

https://github.com/ankane/rollup#date-storage

https://www.tradingview.com/screener/


Domy maklerskie:
https://www.gpw.pl/etfy

- Scrapować reszte etf dla londynu ktorych brakuje
- Zastanowic sie jak ugryzc ishare ale dla niemiec
  - użyć https://www.deepl.com/app do translacji?
    - to trzeba też cachować just in case
Część etf jak na złość jest na niemieckiej stronie ishare

  https://www.lyxoretf.de/de/instit/products/search

Fix two failing scrape jobs
Fetch jobs

Ile procent pokrycia from this one
https://docs.google.com/spreadsheets/d/1PD_OHTK8z06CF9wG2TEyc0NvNd8DEYceDeI1A_hGAB0/edit?usp=sharing
https://docs.google.com/spreadsheets/d/1YR9hVLJqsf3weVUGoG8myKErK6PYEauF3hFsJ4uUp_g/edit#gid=931994470

# amundi etfs
https://www.amundietf.fr/professional/products
ETP: https://etc.dws.com/GBR/ENG/ETC/Productoverview
https://www.vanguard.co.uk/adviser/adv/investments/all-products?productType=etf

bossa missing etfs:
=> [#<PendingEtf name="Amundi ETF Leveraged MSCI USA Daily UCITS ETF" symbol="CL2" isin="FR0010755611">,
 #<PendingEtf name="Amundi ETF MSCI Emerging Markets" symbol="AEEM" isin="LU1681045370">,
 #<PendingEtf name="Amundi ETF MSCI India UCITS" symbol="CI2" isin="LU1681043086">,
 #<PendingEtf name="Amundi ETF MSCI Spain UCITS" symbol="CS1" isin="FR0010655746">,
 #<PendingEtf name="Amundi MSCI EM Asia UCITS ETF" symbol="AASI" isin="LU1681044480">,
 #<PendingEtf name="db Physical Silver Euro Hedged ETC" symbol="XAD2" isin="DE000A1EK0J7">,
 #<PendingEtf name="Emerging Markets Internet & Ecommerce UCITS ETF" symbol="EMQQ" isin="IE00BFYN8Y92">,
 #<PendingEtf name="Expat Bulgaria SOFIX UCITS ETF" symbol="BGX" isin="BG9000011163">,
 #<PendingEtf name="HSBC FTSE 100 UCITS ETF" symbol="UKX" isin="IE00B42TW061">,
 #<PendingEtf name="HSBC MSCI Brazil UCITS ETF" symbol="HMBR" isin="IE00B5W34K94">,
 #<PendingEtf name="HSBC MSCI Indonesia UCITS ETF" symbol="HIDD" isin="IE00B46G8275">,
 #<PendingEtf name="HSBC MSCI Malaysia UCITS ETF" symbol="HMYD" isin="IE00B3X3R831">,
 #<PendingEtf name="HSBC MSCI Mexico Capped UCITS ETF" symbol="HMED" isin="IE00B3QMYK80">,
 #<PendingEtf name="HSBC MSCI Pacific ex Japan UCITS ETF" symbol="MXJ" isin="IE00B5SG8Z57">,
 #<PendingEtf name="HSBC MSCI RUSSIA CAPPED UCITS ETF" symbol="HRUD" isin="IE00B5LJZQ16">,
 #<PendingEtf name="HSBC S&P 500 UCITS ETF" symbol="HSPD" isin="IE00B5KQNG97">,
 #<PendingEtf name="Invesco Elwood Global Blockchain UCITS ETF" symbol="BCHN" isin="IE00BGBN6P67">,
 #<PendingEtf name="Invesco EQQQ NASDAQ-100 UCITS ETF" symbol="EQQQ" isin="IE0032077012">,
 #<PendingEtf name="Invesco Health Care S&P US Select Sector UCITS ETF" symbol="XLSV" isin="IE00B3WMTH43">,
 #<PendingEtf name="Invesco MSCI Saudi Arabia UCITS ETF" symbol="MSAU" isin="IE00BFWMQ331">,
 #<PendingEtf name="Invesco Nasdaq Biotech UCITS ETF" symbol="SBIO" isin="IE00BQ70R696">,
 #<PendingEtf name="Invesco Physical Gold ETC" symbol="SGLD" isin="IE00B579F325">,
 #<PendingEtf name="Invesco Physical Platinum ETC" symbol="SPPT" isin="IE00B40QP990">,
 #<PendingEtf name="Invesco S&P 500 UCITS ETF" symbol="SPXS" isin="IE00B3YCGJ38">,
 #<PendingEtf name="L&G Battery Value-Chain UCITS ETF" symbol="BATT" isin="IE00BF0M2Z96">,
 #<PendingEtf name="L&G Ecommerce Logistics UCITS ETF" symbol="ECOM" isin="IE00BF0M6N54">,
 #<PendingEtf name="Leverage Shares -1x Tesla ETP" symbol="TSLS" isin="IE00BKT6ZH01">,
 #<PendingEtf name="Market Access Rogers International Commodity Index UCITS ETF" symbol="M9SA" isin="LU0249326488">,
 #<PendingEtf name="Royal Mint Physical Gold ETC" symbol="RM8U" isin="XS2115336336">,
 #<PendingEtf name="SPDR MSCI World Value UCITS ETF" symbol="WVAL" isin="IE00BJXRT813">,
 #<PendingEtf name="Sprott Physical Gold Trust ETF" symbol="PHYS" isin="CA85207H1047">,
 #<PendingEtf name="Sprott Physical Silver Trust ETF" symbol="PSLV" isin="CA85207K1075">,
 #<PendingEtf name="UBS DJ Global Select Dividend UCITS ETF" symbol="UBUM" isin="IE00BMP3HG27">,
 #<PendingEtf name="UBS MSCI Singapore UCITS ETF" symbol="UE24" isin="LU1169825954">,
 #<PendingEtf name="Vanguard FTSE All-World High Dividend Yield UCITS ETF" symbol="VHYA" isin="IE00BK5BR626">,
 #<PendingEtf name="Vanguard FTSE All-World UCITS ETF Accumulating" symbol="VWCE" isin="IE00BK5BQT80">,
 #<PendingEtf name="Vanguard FTSE Developed World UCITS ETF" symbol="VHVE" isin="IE00BK5BQV03">,
 #<PendingEtf name="Vanguard FTSE Emerging Markets UCITS ETF" symbol="VFEA" isin="IE00BK5BR733">,
 #<PendingEtf name="Vanguard Global Aggregate Bond UCITS ETF" symbol="VAGF" isin="IE00BG47KH54">,
 #<PendingEtf name="Vanguard Global Aggregate Bond UCITS ETF (USD)" symbol="VAGU" isin="IE00BG47KJ78">,
 #<PendingEtf name="Vanguard S&P 500 UCITS ETF acc" symbol="VUAA" isin="IE00BFMXXD54">,
 #<PendingEtf name="Vanguard USD Corporate 1-3 Year Bond UCITS ETF" symbol="VDCA" isin="IE00BGYWSV06">,
 #<PendingEtf name="WisdomTree NASDAQ 100 3x Daily Leveraged" symbol="QQQ3" isin="IE00B8W5C578">,
 #<PendingEtf name="WisdomTree NASDAQ 100 3x Daily Short" symbol="QQQS" isin="IE00B8VZVH32">,
 #<PendingEtf name="WisdomTree Natural Gas 3x Daily Leveraged" symbol="3LNG" isin="IE00B8VC8061">,
 #<PendingEtf name="WisdomTree WTI Crude Oil 1yr" symbol="OSW1" isin="JE00B1YPB605">,
 #<PendingEtf name="Xtrackers Brent Crude Oil Optimum Yield EUR Hedged ETC" symbol="XETC" isin="DE000A1AQGX1">,
 #<PendingEtf name="Xtrackers Physical Platinum ETF" symbol="XAD3" isin="DE000A1EK0H1">,
 #<PendingEtf name="Xtrackers Physical Silver ETC" symbol="XAD6" isin="DE000A1E0HS6">]



# Nastepne
Pobierz liste etf z bossa i porownaj

# vanguard
  - institutional ui is diffrent need new ui

MBank: 300.0/327 = 92%
XTB: 185.0/229
BOS: 271.0/320 = 84% - do poprawy pare ktore sa scrapowane brakuje


# Prosty interfejs
Wyszukiwarka
- elasticsearch
Wyniki

styled components
Graphql endpoint