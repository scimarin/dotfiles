#!/usr/bin/python

import requests

etheur = 'https://www.bitstamp.net/api/v2/ticker/etheur/'

data = requests.get(etheur).json()
bid = float(data['bid'])
ask = float(data['ask'])

price = (bid + ask) / 2

print(str(round(price, 1)))
