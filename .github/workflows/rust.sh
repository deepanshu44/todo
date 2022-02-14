# here napi argument passed to the script converted from "1,2,3.." to "1 2 3 ..."
# had to do this since github doesn't accepts space separated list
napi_versions=${1//,/ }
# A "flag" in "flags" is specified as-
# <flag-name>:<minimum-napi-version-supported>
# or
# <flag-name>
flags=${2//,/ }
echo -e "\n"
for napi in $napi_versions; do
    final_flags=""
    for flag in $flags; do
	count=`expr $count + 1`
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
		# if final_flags empty or null
		if [ -z $final_flags ]
		then
		    final_flags=$flag_name
		else
		    final_flags=$final_flags,$flag_name
		fi
	    fi
        else
	    # if final_flags empty or null
	    if [ -z $final_flags ]
	    then
		final_flags=$flag
	    else
		final_flags=$final_flags,$flag
	    fi
        fi
    done
            echo cargo check --no-default-features --features=napi-${napi},${final_flags}
done
