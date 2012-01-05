#!/bin/sh
URL=$1
PASSWORD=$2

if [ -z "$URL" ]; then
  echo "Missing URL parameter"
  exit 10
fi

if [ -z "$PASSWORD" ]; then
  echo "Missing password parameter"
  exit 15
fi

set -e
COOKIE_JAR=$0.cookies
OUTPUT_FILE=$0.output

rm -f $COOKIE_JAR

if curl --fail --silent -o $OUTPUT_FILE -c $COOKIE_JAR -d adminpw="$PASSWORD" -d adminlogin="Let me in..." $URL; then
    :
else
  echo "Failed to retreive $URL" >&2
  exit 18
fi

if grep -q "Authorization failed." $OUTPUT_FILE; then
  echo "Authorization failed" >&2
  rm $OUTPUT_FILE $COOKIE_JAR
  exit 20
fi

if grep -q "There are no pending requests." $OUTPUT_FILE; then
  rm $OUTPUT_FILE $COOKIE_JAR
  exit 0
fi

if ! grep -q "Discard all messages marked" $OUTPUT_FILE; then
  echo "Unexpected response, see $OUTPUT"
  exit 30
fi

tidy -quiet $OUTPUT_FILE 2>/dev/null |
xmllint --html --format --xmlout - |
xsltproc --novalid `dirname $0`/mailman-discard.xsl - > $0.form
 
#mv $OUTPUT_FILE x
#--trace-ascii y 

curl --fail --silent -o $OUTPUT_FILE -b $COOKIE_JAR -d submit="Submit All Data" -d discardalldefersp=0 -d @$0.form $URL

if grep -q "There are no pending requests." $OUTPUT_FILE; then
  rm $OUTPUT_FILE $COOKIE_JAR
  exit 0
fi

echo "Unexpected response, see $OUTPUT_FILE"
exit 40

