set -e

echo -e "\nWaiting 60 seconds for internet check to run"
sleep 60

# Test internet through NAT GW
aws logs tail $INTERNET_TEST_LOG_GROUP | grep -vi error
aws logs tail $INTERNET_TEST_LOG_GROUP | grep -i "connected successfully"

# Test host in hub