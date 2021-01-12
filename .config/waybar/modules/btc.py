#!/usr/bin/python

import requests

btceur = 'https://www.bitstamp.net/api/v2/ticker/btceur/'

data = requests.get(btceur).json()
bid = float(data['bid'])
ask = float(data['ask'])

price = (bid + ask) / 2

print(str(round(price, 1)))

