echo "{ \"count\" : [ { \"json\" : \"$(ls ./data/out/*.json 2> /dev/null | wc -l)\" }, { \"png\" : \"$(ls ./data/out/*.png 2> /dev/null | wc -l)\" } ] }"
