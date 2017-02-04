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
FORM_FILE=$0.form

rm -f $COOKIE_JAR
	
trap "rm -f $OUTPUT_FILE $COOKIE_JAR $FORM_FILE; exit" INT TERM EXIT

if curl --fail --silent --show-error --include -o $OUTPUT_FILE -c $COOKIE_JAR -d adminpw="$PASSWORD" -d adminlogin="Let me in..." $URL; then
    :
else
  if test -f $OUTPUT_FILE && grep -q 'curl: (56) SSL read: error:00000000:lib(0):func(0):reason(0), errno 104$' $OUTPUT_FILE; then 
    exit 17
  fi

  echo "Failed to retreive $URL" >&2
  test -f $OUTPUT_FILE && cat $OUTPUT_FILE
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
  echo "**** Unexpected response ****"
  test -f $OUTPUT_FILE && cat $OUTPUT_FILE
  exit 30
fi

tidy -quiet $OUTPUT_FILE 2>/dev/null |
xmllint --html --format --xmlout - |
xsltproc --novalid `dirname $0`/mailman-discard.xsl - > $FORM_FILE
 
curl --fail --silent -o $OUTPUT_FILE -b $COOKIE_JAR -d submit="Submit All Data" -d discardalldefersp=0 -d @$FORM_FILE $URL

if grep -q "There are no pending requests." $OUTPUT_FILE; then
  rm $OUTPUT_FILE $COOKIE_JAR $FORM_FILE
  exit 0
fi

echo "**** Unexpected response ****"
test -f $OUTPUT_FILE && cat $OUTPUT_FILE
exit 40

