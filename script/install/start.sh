#!/bin/bash

# micro service name 
APPLICATION_NAME=$1

# Actual file name of Micro Service (jar), 
JAR_NAME=$2
# ^^^ that should relative to MS_HOME directory.

# Total instance to run
TOTAL_INSTANCE_TO_RUN=$3

# Total instance to run
PROFILES=$4

# Where micro service jar file sits?
MS_HOME=/opt/build

# Which username we should run as.
RUNASUSER=jenkins # <-- EDIT THIS LINE, 
# if port number for spring boot is < 1024 it needs root perm.

# wait before issuing 
STARTUP_WAIT=60

#wait for servie to write pid file
INITIAL_WAIT=15

# These options are used when micro service is starting 
# Add whatever you want/need here... overrides application*.yml.
SPRING_OPTS=" --server.port=0 --spring.profiles.active=${PROFILES} ";

JVM_OPTS=" -Xmx256M -Xms128M ";

#Old processes ids
declare -a OLD_PROCESSES_FILE=()

#New processes ids
declare -a NEW_PROCESSES_FILE=()

#New processes ids
declare -a NEW_SUCCESS_PROCESSES_FILE=()

declare -a NEW_FAILED_PROCESSES_FILE=()

declare -a TEMP_PROCESSES_FILE=()

# Function to extract new processes ids.
diff(){
  awk 'BEGIN{RS=ORS=" "}
       {NR==FNR?a[$0]++:a[$0]--}
       END{for(k in a)if(a[k])print k}' <(echo -n "${!1}") <(echo -n "${!2}")
}

echo "Moving to ms home directory [ ${MS_HOME} ]"
cd ${MS_HOME}

for fname in $(find . -name "*.pid")
    do
    if [[ $fname == *"${APPLICATION_NAME}"* ]]; then
            OLD_PROCESSES_FILE[${#OLD_PROCESSES_FILE[*]}]=${fname%.*} 
        fi
    done

echo "Old Process instances."
for ((i=0; i<${#OLD_PROCESSES_FILE[*]}; i++)); do echo "${OLD_PROCESSES_FILE[$i]}"; done

for ((i=1; i<=${TOTAL_INSTANCE_TO_RUN}; i++)); 
    do 
        echo "nohup ./${JAR_NAME} $JVM_OPTS $SPRING_OPTS &"
        #chmod 755 ${JAR_NAME}
        nohup java -jar $JVM_OPTS ${JAR_NAME}  $SPRING_OPTS &
        CmdExit=$?
        sleep ${INITIAL_WAIT};
            if [ "$CmdExit" = 0 ]
            then
                echo "Service [${JAR_NAME}] instance [${i}] starting .... "
            else
                echo "Faild to start Service name [${JAR_NAME}] instance [${i}] "
            fi
    done


for fname in $(find . -name "*.pid")
    do
    if [[ $fname == *"${APPLICATION_NAME}"* ]]; then
            NEW_PROCESSES_FILE[${#NEW_PROCESSES_FILE[*]}]=${fname%.*} 
    fi
done

# Extrating new instances
for i in "${OLD_PROCESSES_FILE[@]}"; do
    NEW_PROCESSES_FILE=(${NEW_PROCESSES_FILE[@]//*$i*})
done

echo "New Process instances."
for ((i=0; i<${#NEW_PROCESSES_FILE[*]}; i++)); do echo "${NEW_PROCESSES_FILE[$i]}"; done


echo "Validating the processes..."
for ((i=0; i<${#NEW_PROCESSES_FILE[*]}; i++)); 
     do 
        time=0
        flag=0
        while [ $flag -le 0 ]
        do
              if  [ -e "${NEW_PROCESSES_FILE[$i]}.port" ] 
              then
                    port=0;
                    read port<"${NEW_PROCESSES_FILE[$i]}.port"
                    echo "Service instance [${NEW_PROCESSES_FILE[$i]}][${i}] started at port [${port}] "
                    flag=1
              elif [ $time -lt $STARTUP_WAIT ]  
              then
                    echo "Waiting for Service to Start.."
                    time=$(( $time + 5 ));
                    sleep 5
              else
                    echo "Service instance [${NEW_PROCESSES_FILE[$i]}][${i}] faild to start in [${STARTUP_WAIT}] seconds, Marking for termination."
                    NEW_FAILED_PROCESSES_FILE[${#NEW_FAILED_PROCESSES_FILE[*]}]=${NEW_PROCESSES_FILE[$i]}
                    flag=2;
               fi
        done    
done



if [[ ${NEW_FAILED_PROCESSES_FILE[@]} ]]; then
        echo "Terminating the new process if extis"
        for ((i=0; i<${#NEW_PROCESSES_FILE[*]}; i++)); do 
            echo "Terminating service instance [${NEW_PROCESSES_FILE[$i]}][${i}] "
                read pid<"${NEW_PROCESSES_FILE[$i]}.pid"
                # Kill failed process
                kill -9 $pid
                CmdExit=$?
                # wait for 5 second to ternimate
                sleep 5
                #remove pid file if not removed
                if  [ -e "${NEW_PROCESSES_FILE[$i]}.pid" ] 
                then
                    rm -rf  "${NEW_PROCESSES_FILE[$i]}.pid"
                fi

                if  [ -e "${NEW_PROCESSES_FILE[$i]}.port" ] 
                then
                    rm -rf  "${NEW_PROCESSES_FILE[$i]}.port"
                fi
                
                if [ "$CmdExit" -eq "0" ]
                then
                    echo "Service instance [${NEW_PROCESSES_FILE[$i]}][${i}] sucessfully terminated. "
                else
                    echo "Service instance [${NEW_PROCESSES_FILE[$i]}][${i}] unable to terminate. "
                fi
        done 
        exit 1
    else
        echo "Terminating the old process if extis"
        for ((i=0; i<${#OLD_PROCESSES_FILE[*]}; i++)); do 
            echo "Terminating service instance [${OLD_PROCESSES_FILE[$i]}][${i}] "
                read pid<"${OLD_PROCESSES_FILE[$i]}.pid"
                # Kill failed process
                kill -9 $pid
                CmdExit=$?

                # wait for 5 second to ternimate
                sleep 5
                #remove pid file if not removed
                if  [ -e "${OLD_PROCESSES_FILE[$i]}.pid" ] 
                then
                    rm -rf  "${OLD_PROCESSES_FILE[$i]}.pid"
                fi

                #remove port file if not removed
                if  [ -e "${OLD_PROCESSES_FILE[$i]}.port" ] 
                then
                    rm -rf  "${OLD_PROCESSES_FILE[$i]}.port"
                fi
                
                if [ "$CmdExit" -eq "0" ]
                then
                    echo "Service instance [${OLD_PROCESSES_FILE[$i]}][${i}] sucessfully terminated. "
                else
                    echo "Service instance [${OLD_PROCESSES_FILE[$i]}][${i}] unable to terminate. "
                fi
        done 
        exit 0
    fi
