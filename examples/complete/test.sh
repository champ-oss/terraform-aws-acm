set -e
if [ "$ENABLED" = "true" ]; then
  aws acm describe-certificate --certificate-arn $ARN | grep ISSUED
else
  echo "Module is disabled, no resources created"
fi
