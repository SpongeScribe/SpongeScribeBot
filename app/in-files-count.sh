echo "{ \"count\" : [ { \"json\" : \"$(ls ./data/in/*.json 2> /dev/null | wc -l)\" }, { \"png\" : \"$(ls ./data/in/*.png 2> /dev/null | wc -l)\" } ] }"
