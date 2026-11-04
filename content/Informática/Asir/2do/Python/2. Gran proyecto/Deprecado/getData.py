import sqlite3
import requests
import json

con = sqlite3.connect("DB/data.sqlite3")
cur = con.cursor()

cur.execute("""

CREATE TABLE IF NOT EXISTS MarketMovements(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	symbol VARCHAR(20) NOT NULL,
	profit INTEGER NOT NULL
);

""")

con.commit()

### CONSTRUCTOR DE PETICIÓN ###

class RequestHandler:
	def __init__(self, interval = 30, formatInterval = "min", symbol = "NVDA"):
		self.interval = interval
		self.formatInterval = formatInterval
		self.symbol = symbol

	def getRequest(self) -> str:

		with open("APIKey.env", "r", encoding="UTF-8") as file:
			secret = file.read()

		return f"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol={self.symbol}&outputsize=full&interval={self.interval}{self.formatInterval}&apikey={secret}"

	def doRequest(self) -> str:
		return json.loads(requests.get(self.getRequest()).text)

class SQLRegister:
	def __init__(self, symbol, profit):
		self.symbol = symbol
		self.profit = profit

	def OperateProfit(data: str) -> str:
		del data["Meta Data"]

prueba = RequestHandler()

print(prueba.getRequest())

for x in prueba.doRequest()["Time Series (30min)"].keys():
	print(prueba.doRequest()["Time Series (30min)"][x])