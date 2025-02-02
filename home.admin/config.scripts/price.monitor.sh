#!/usr/bin/env bash

calc_percent_change() {
    old_value=$1
    new_value=$2

    if [ "$(echo "$old_value == 0" | bc)" -eq 1 ]; then
        echo "Undefined (division by zero)"
        return
    fi

    change=$(echo "scale=4; (($new_value - $old_value) / $old_value) * 100" | bc)

    echo "${change}"
}

response=$(curl -s -X 'GET' 'https://api.exchange.coinbase.com/products/BTC-USD/stats' -H 'Content-Type: application/json')

open_price=$(echo "${response}" | jq '.open' | xargs printf "%.2f")
raw_price=$(echo "${response}" | jq '.last' | xargs printf "%.2f")
price=$(echo "${raw_price}" | xargs printf "%'.0f")

percent_change=$(calc_percent_change "${open_price}" "${raw_price}")
percent_change=$(printf '%01.2f' "${percent_change}")

echo "btc_price='${price}'"
echo "btc_24h_price_change_percent='${percent_change}'"

exit 0
