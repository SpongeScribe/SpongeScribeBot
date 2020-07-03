echo "{ \"count\" : [ { \"json\" : \"$(ls ./appdata/out/*.json 2> /dev/null | wc -l)\" }, { \"png\" : \"$(ls ./appdata/out/*.png 2> /dev/null | wc -l)\" } ] }"
