#!/usr/bin/env bash

base_url=http://localhost:4080

numfmt="numfmt --to=iec"

####################
# Upcoming blocks
upcoming_blocks=$(curl -sSL "${base_url}/api/v1/fees/mempool-blocks")

next_block=$(echo "${upcoming_blocks}" | jq '.[0]')
fee_range=$(echo "${next_block}" | jq '."feeRange"')

first_fee=$(echo $fee_range | jq ".[0]" | $numfmt)
last_fee=$(echo $fee_range | jq ".[-1]" | $numfmt)
median_fee=$(echo "${next_block}" | jq '.medianFee' | $numfmt)

echo "mempool_next_block_fee_first='${first_fee}'"
echo "mempool_next_block_fee_last='${last_fee}'"
echo "mempool_next_block_fee_median='${median_fee}'"

####################
# Recommended Fees
recommended_fees=$(curl -sSL "${base_url}/api/v1/fees/recommended")

high_priority=$(echo ${recommended_fees} | jq '."fastestFee"')
medium_priority=$(echo ${recommended_fees} | jq '."halfHourFee"')
low_priority=$(echo ${recommended_fees} | jq '."hourFee"')
no_priority=$(echo ${recommended_fees} | jq '."economyFee"')

echo "mempool_rec_fee_high='${high_priority}'"
echo "mempool_rec_fee_medium='${medium_priority}'"
echo "mempool_rec_fee_low='${low_priority}'"
echo "mempool_rec_fee_no='${no_priority}'"

####################
# Latest Blocks

blocks=$(curl -sSL "${base_url}/api/v1/blocks")
latest_block=$(printf '%s' "${blocks}" | jq '.[0]')

height=$(printf '%s' "${latest_block}" | jq '."height"' )
timestamp=$(printf '%s' "${latest_block}" | jq '."timestamp"' )

now=$(date +%s)

ago=$(printf '%d %s' "$(( (now-timestamp) / 60 ))" "min ago")

block_fee_range=$(printf '%s' "${latest_block}" | jq '."extras"."feeRange"' )
block_first_fee=$(printf '%s' "${block_fee_range}" | jq ".[0]" | $numfmt)
block_last_fee=$(printf '%s' "${block_fee_range}" | jq ".[-1]" | $numfmt)
block_median_fee=$(printf '%s' "${latest_block}" | jq '."extras"."medianFee"' | $numfmt)

echo "mempool_l_block_height='${height}'"
echo "mempool_l_block_time_ago='${ago}'"
echo "mempool_l_block_first_fee='${block_first_fee}'"
echo "mempool_l_block_last_fee='${block_last_fee}'"
echo "mempool_l_block_median_fee='${block_median_fee}'"

####################
# Difficulty Adjustment

difficulty=$(curl -sSL "${base_url}/api/v1/difficulty-adjustment")
time_to_next_block=$(printf '%s' "${difficulty}" | jq '.timeAvg')
avg_block_time=$(echo "${time_to_next_block} / 1000.0 / 60.0" | bc -l)
avg_block_time=$(printf '%.1f' "${avg_block_time}")

echo "mempool_avg_block_time='${avg_block_time}'"

exit 0
