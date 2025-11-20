#!/bin/bash

OUTPUT_FILE="/home/ubuntu/run_status/run_status.txt"
HOST="aerowise-dev-db.c7i08ukwctz8.ap-south-1.rds.amazonaws.com"
USER="aerowise_admin"
DB="aerowise_mbapp"

# ESCAPED PASSWORD
export PGPASSWORD="V4Na\$Lk#n\$78DP3eeX1t"

echo "=== Run Status Report: $(date) ===" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

run_query() {
  local label="$1"
  local query="$2"

  echo "Running: $label"
  echo "---- $label ----" >> $OUTPUT_FILE

  psql "host=$HOST user=$USER dbname=$DB sslmode=require" \
       -t -A -c "$query" >> $OUTPUT_FILE 2>&1

  echo "" >> $OUTPUT_FILE
}

run_query "cab_details_entry" \
"select max(inserted_at),max(updated_at) from assets.cab_details_entry;"

run_query "cab_details_exit" \
"select max(inserted_at),max(updated_at) from assets.cab_details_exit;"

run_query "actual_pax_distribution" \
"select max(created_at),max(updated_at) from flight_service.actual_pax_distribution;"

run_query "flight_info" \
"select max(crt_date),max(mod_date) from flight_service.flight_info;"

run_query "flight_performance" \
"select max(crt_date),max(mod_date) from flight_service.flight_performance;"

run_query "location_details" \
"select max(inserted_at),max(updated_at) from flight_service.location_details;"

run_query "queue_dist" \
"select max(created_at),max(updated_at) from flight_service.queue_dist;"

run_query "queue_info" \
"select max(created_at),max(updated_at) from flight_service.queue_info;"

run_query "touchpoint_wise_location_mapping" \
"select max(inserted_at),max(updated_at) from flight_service.touchpoint_wise_location_mapping;"

run_query "flightwise_bookload_stats" \
"select max(inserted_at),max(updated_at) from flight_service.flightwise_bookload_stats;"

run_query "terminalwise_bookload_stats" \
"select max(inserted_at),max(updated_at) from flight_service.terminalwise_bookload_stats;"

echo "Output saved to: $OUTPUT_FILE"
