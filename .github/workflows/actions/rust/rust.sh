# list of napi-versions separated by space
napi_versions="1 2 3 4 5 6 experimental"

# A "flag" in "flags" is specified as-
# <flag-name>:<minimum-napi-version-supported>
# or
# <flag-name>
flags="proc-macros try-catch-api:5 channel-api:4"

for napi in $napi_versions; do
    for flag in $flags; do
        # checks if ":" exists in the flag, outputs the index or 0 if false
        index_of_colon=`expr index "$flag" :`

        if [[ $index_of_colon != 0 ]]  
        then
	    #gets napi version from flag; substring is extracted from "flag" from index "index_of_colon"
            napi_version_in_flag=${flag:$index_of_colon}
            # evaluate index_of_colon minus 1
            index=`expr $index_of_colon - 1`
            # get the flag name in "flag" which is from index 0 to $index
            flag_name=${flag:0:$index}
            # if the left part below is greater than equal to(-ge) the right part
            if [[ $napi -ge $napi_version_in_flag ]]
            then
                echo cargo check --no-default-features --features=napi-${napi},${flag_name}
	    fi
         else
             echo cargo check --no-default-features --features=napi-${napi}
         fi
    done
done


