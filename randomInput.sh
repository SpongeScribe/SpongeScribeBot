if [ -z $IMAGE_TEXT]; then
	IMAGE_TEXT="Hello!\nPotato."
fi

FILENAME=in/input.random.`uuidgen`.json
echo "{
    \"items\": [
        { \"username\" : \"TEST\", \"imageText\" : \"$IMAGE_TEXT\" }" > $FILENAME;
for run in {1..10}; do
	USERNAME=`uuidgen`
	for run in {1..100}; do
		echo "        , { \"username\" : \"$USERNAME\", \"imageText\" : \"$(uuidgen)\" }" >> $FILENAME;
	done
done
echo "    ]" >> $FILENAME
echo "}" >> $FILENAME
