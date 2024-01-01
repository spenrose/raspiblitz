#!/usr/bin/env bash

response=$(curl -s -X 'GET' 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true&include_market_cap=true' -H 'acceprt: application/json')

price=$(echo "${response}" | jq '.bitcoin.usd' | xargs printf "%'.0f")
percent_change=$(echo "${response}" | jq '.bitcoin.usd_24h_change')
percent_change=$(printf '%01.2f' "${percent_change}")

echo "btc_price='${price}'"
echo "btc_24h_price_change_percent='${percent_change}'"

exit 0
