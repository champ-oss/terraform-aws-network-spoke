set -e

if [ "$ENABLED" = "true" ]; then
  echo -e "\nWaiting 60 seconds for checks to run..."
  sleep 60

  # Test internet from spoke through NAT GW. The Lambda function connects to api.seeip.org which responds with our public IP
  aws logs tail $INTERNET_TEST_LOG_GROUP | grep -vi error
  aws logs tail $INTERNET_TEST_LOG_GROUP | grep -i "search data found"

  # Test connecting from spoke to mysql host in hub
  aws logs tail $MYSQL_TEST_LOG_GROUP | grep -vi error
  aws logs tail $MYSQL_TEST_LOG_GROUP | grep -i "connected successfully"
else
    echo "Module is disabled, no resources created"
fi