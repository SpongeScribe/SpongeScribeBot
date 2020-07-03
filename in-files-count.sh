echo "{ \"count\" : [ { \"json\" : \"$(ls ./appdata/in/*.json 2> /dev/null | wc -l)\" }, { \"png\" : \"$(ls ./appdata/in/*.png 2> /dev/null | wc -l)\" } ] }"
