#!/bin/bash
# @Author: Guillain
# @Date: 2021/12/07
# @Rev: 1.0

# To easily prepare the TEMPLATES ############################################################################
# _curl "GET" "things" > things.json && ${_JQ} '.[] | select(.label | contains("ESP_NAME"))' things.json > things_ESP_8266_TEMPLATE.json
# _curl "GET" "items" > items.json   && ${_JQ} '.[] | select(.groupNames[] | contains("ESP_NAME"))' items.json > items_ESP_8266_TEMPLATE.json
# _curl "GET" "links" > links.json   && ${_JQ} '.[] | select(.channelUID | contains("ESP_NAME"))' links.json > links_ESP_8266_TEMPLATE.json
# _curl "GET" "rules" > rules.json   && ${_JQ} '.[] | select(.channelUID | contains("ESP_NAME"))' rules.json > rules_ESP_8266_TEMPLATE.json

# DEFAULT PARAMETERS #########################################################################################
EXEC_API=0
DO_ITEMS=1
WEB_PAGES=0
DEBUG=0

ESP_INDEX_START=15
ESP_INDEX_END=30
ESP_IP_PATTERN="10.1.1.1"

PAGE_ROW_INDEX=1

OH_WEB_URL="http://domo:8080"
OH_TOKEN=""

INPUT_DIR="./"
GENE_DIR="generate/"
API_DIR="${INPUT_DIR}OpenHAB/API/"
TMP_FILE="temp.json"
_JQ="./jq.exe"

_help(){
    echo "Used to provision OpenHAB3 via API with the help of JSON templates and to generate the template web files.
    -h | --help                           Print this help.
    -a | --action                         Which action to perform? Can be: create, update, destroy. Required.
    -c | --components                     On which component the action must be performed? Can be: all or one of things, items, links, rules. Required.
    -t | --ohtoken                        OpenHab token. Required.
    -s | --startindex                     Starting ESP index. Default: ${ESP_INDEX_START}.
    -e | --endindex                       Ending ESP index. Default: ${ESP_INDEX_END}.
    -i | --ippattern                      ESP IP pattern used like a prefix. Default: ${ESP_IP_PATTERN}.
    -u | --ohurl                          OpenHab URL. Default: ${OH_WEB_URL}.
    -w | --rowindex                       Starting row index to build the Overview pages. Default: ${PAGE_ROW_INDEX}.
    -p | --webpage <> -P | --nowebpage    Should I generate the OpenHab web pages?. Default: ${WEB_PAGES}.
    -r | --runapi  <> -R | --norunapi     Should I run the API call? Default: ${EXEC_API}.
    -d | --doitems <> -D | --nodoitems    Should I do all single items? Default: ${DO_ITEMS}.
    -v | --verbose                        Display verbose traces. Default: ${DEBUG}"
}
_err(){
    echo -e "${1}\n"
    _help
    exit 1
}

# ARGUMENTS ##################################################################################################
TEMP=$(getopt -o ha:c:rRdDs:e:i:u:t:w:pv \
        --long help,action:,components:,runapi,norunapi,doitems,nodoitems,startindex:,endindex:,ippattern:,ohurl:,ohtoken:,rowindex:,webpage,verbose \
        -n 'generate.sh' -- "$@")
if [ $? != 0 ] ; then _err "Wrong argument provided, thanks to read carefully the help :)"; fi
eval set -- "$TEMP"
while true; do
  case "$1" in
    -h | --help )        _help; exit 0;;
    -a | --action )      ACTION=${2}; shift 2;;
    -c | --components )  COMPONENTS=${2}; shift 2;;
    -r | --runapi )      EXEC_API=1; shift;;
    -R | --norunapi )    EXEC_API=0; shift;;
    -d | --doitems )     DO_ITEMS=1; shift;;
    -D | --nodoitems )   DO_ITEMS=0; shift;;
    -p | --webpage )     WEB_PAGES=1; shift;;
    -P | --nowebpage )   WEB_PAGES=0; shift;;
    -s | --startindex )  ESP_INDEX_START=${2}; shift 2;;
    -e | --endindex )    ESP_INDEX_END=${2}; shift 2;;
    -i | --ippattern )   ESP_IP_PATTERN=${2}; shift 2;;
    -u | --ohurl )       OH_WEB_URL=${2}; shift 2;;
    -t | --ohtoken )     OH_TOKEN=${2}; shift 2;;
    -w | --rowindex )    PAGE_ROW_INDEX=${2}; shift 2;;
    -v | --verbose )     DEBUG=1; shift;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
if [ "${ACTION}" == "" ]; then _err "Action is missing."; fi
if [ "${COMPONENTS}" == "" ]; then _err "Components is missing."; fi
if [ "${COMPONENTS}" == "" ]; then _err "Components is missing."; fi

# FUNCTIONS ##################################################################################################
_sed(){
    sed -e '/"state"/d' \
        -e "s/ESP_REFERENCE/${esp_reference}/g" \
        -e "s/ESP_NAME/${esp_name}/g" \
        -e "s/ESP_LOCATION/${esp_location}/g" \
        -e "s/ESP_IP_ADDRESS/${esp_ip_address}/g" \
        -e "s/ESP_ICON/${esp_icon}/g" \
        -e "s/OPENHAB_WEB_URL/$(echo ${OH_WEB_URL}  | sed 's/\//\\\//g')/g" \
        -e "s/ROW_REFERENCE/$((${PAGE_ROW_INDEX} + ${row_index}))/g" \
        ${1} > ${2}
}
_esp(){
    case ${1} in
        14) model="8266";  name="Entry";       location="Entry";      icon="oh:frontdoor";;
        15) model="8266";  name="Entry";       location="Entry";      icon="oh:frontdoor";;
        16) model="8266";  name="Livingroom";  location="LivingRoom"; icon="oh:groundfloor";;
        17) model="8266";  name="Kitchen";     location="Kitchen";    icon="oh:kitchen";;
        18) model="8266";  name="Bathroom";    location="BathRoom";   icon="oh:bath";;
        19) model="8266";  name="Nina";        location="Nina";       icon="oh:bedroom_orange";;
        20) model="8266";  name="Luca";        location="Luca";       icon="oh:bedroom_blue";;
        21) model="8266";  name="Friendroom";  location="FriendRoom"; icon="oh:bedroom_red";;
        22) model="8266";  name="Guillain";    location="Guillain";   icon="oh:bedroom";;
        23) model="8266";  name="Deskroom";    location="DeskRoom";   icon="oh:office";;
        24) model="8266";  name="Garage";      location="Garage";     icon="oh:garage";;
        25) model="8266";  name="Garden";      location="Garden";     icon="oh:garden";;
        26) model="32";    name="Entry";       location="Entry";      icon="oh:frontdoor";;
        27) model="32";    name="Garage";      location="Garage";     icon="oh:garage";;
        28) model="32";    name="Garden";      location="Garden";     icon="oh:garden";;
        29) model="32";    name="Lab32";       location="Lab";        icon="oh:zoom";;
        30) model="8266";  name="Lab8266";     location="Lab";        icon="oh:zoom";;
        # For test
        98) model="32";    name="Test32";      location="Lab";        icon="oh:zoom";;
        99) model="8266";  name="Test8266";    location="Lab";        icon="oh:zoom";;
        *)  echo "ESP ref '${1}' does not exist";;
    esac
    esp_reference=${1}
    esp_name="${esp_reference}_${name}"
    esp_location="${location}"
    esp_ip_address="${ESP_IP_PATTERN}${esp_reference}"
    esp_model="${model}"
    esp_icon="${icon}"
}
_curl(){
    echo " -- -- -> ${1} ${2}"
    if [ "${3}" != "" ] && [ "${1}" != "DELETE" ]; then
        if [ ${DEBUG} -eq 1 ]; then
            echo " -- -- -- -> Request: curl -X ${1} ${OH_WEB_URL}/rest/${2} -u \"\${OH_TOKEN}:\" -H  \"accept: */*\"  -H \"Content-Type: application/json\" --data @${3}" 
            echo " -- -- -- -> Data file: ${3}"
            # cat ${3}
        fi

        if [ ${EXEC_API} -eq 1 ]; then
            resp=$(curl -s -X "${1}" "${OH_WEB_URL}/rest/${2}" -u "${OH_TOKEN}:" -H  "accept: */*"  -H "Content-Type: application/json" --data @${3} 2>&1)
        fi
    else
        if [ ${DEBUG} -eq 1 ]; then
            echo " -- -- -- -> Request: curl -X ${1} ${OH_WEB_URL}/rest/${2} -u \"\${OH_TOKEN}:\" -H  \"accept: */*\"  -H \"Content-Type: application/json\""
        fi
        if [ ${EXEC_API} -eq 1 ]; then
            resp=$(curl -s -X "${1}" "${OH_WEB_URL}/rest/${2}" -u "${OH_TOKEN}:" -H  "accept: */*"  -H "Content-Type: application/json" 2>&1)
        fi
    fi
    if [ ${DEBUG} -eq 1 ]; then echo " -- -- -- -> Response: ${resp}"; fi
    
    if [ "$(echo ${resp} | grep '"error')" != "" ]; then
        echo " -- -- -- -> Error: $(echo ${resp} | awk -F'{' '{print $3}' | awk -F'}' '{print $1}')"
    fi
}
_jq(){
    echo $(${_JQ} ".${1}" ${2} | sed 's/"//g')
}
_UID(){
    echo $(grep '"UID"' ${1} | awk -F'"' '{print $4}')
}
_templates(){
    for d in $(ls -d */); do
        echo " -> Folder: ${d}"
        
        for f in $(ls ${d} | grep "TEMPLATE"); do
            row_index=0
            echo " -- -> File: ${f}"
                    
            for esp_index in $(seq ${ESP_INDEX_START} ${ESP_INDEX_END}); do
                _esp ${esp_index}
                if [ $(echo "${d}/${f}" | grep -c "_${esp_model}_") -ne 0 ]; then
                    input_file="${d}${f}"
                    output_file=${d}${GENE_DIR}$(echo ${f} | sed "s/TEMPLATE/${esp_name}/g")
                    if [ ! -d ${d}${GENE_DIR} ]; then 
                        mkdir -p ${d}${GENE_DIR}
                    fi
                    
                    echo " -- -- -> ${esp_index}, row_index: ${row_index}, output_file: ${output_file}"
                    _sed ${input_file} ${output_file}
                    
                    row_index=$((${row_index}+1))
                fi
            done
        done
        for f in $(ls ${d} | grep "HEADER"); do
            input_file="${d}${f}"
            output_file="${d}${GENE_DIR}$(echo ${f} | sed 's/_HEADER//g')"
            _sed ${input_file} ${output_file}
            for ff in $(ls ${output_file::-4}_*); do
                cat ${ff} >> ${output_file}
            done
        done
    done
}
_loop(){
    do_loop=${DO_ITEMS}
    i_loop=0
    while [ ${do_loop} -eq 1 ]; do
        ${_JQ} ".[${i_loop}]" ${2} > ${TMP_FILE}
        if [ $(wc -l < ${TMP_FILE}) -le 3 ]; then 
            do_loop=0
        else
            case ${api_tag} in
                "things") if [ "${1}" != "POST" ]; then uri=/$(_jq "UID" ${TMP_FILE}); fi;;
                "items")  uri=/$(_jq "name" ${TMP_FILE});;
                "links")  uri=/$(_jq "itemName" ${TMP_FILE})/$(_jq "channelUID" ${TMP_FILE});;
                "rules")  if [ "${1}" != "POST" ]; then uri=/$(_jq "uid" ${TMP_FILE}); fi;;
                *) _err "API tag '${api_tag}' does not exist";;
            esac
            _curl ${1} "${api_tag}${uri}" ${TMP_FILE}
            i_loop=$(expr ${i_loop} + 1)
        fi
    done
    if [ ${DEBUG} -eq 0 ]; then rm -f ${TMP_FILE}; fi
}

# MAIN #######################################################################################################

# Generate the pages from the templates
if [ ${WEB_PAGES} -eq 1 ]; then
    echo "Standard files generation -------------------------------------------------------------------------------"
    _templates
fi 

# Creation by API with the help of the template
echo "API ${ACTION} --------------------------------------------------------------------------------------------"
if [ ! -d ${API_DIR}/${GENE_DIR} ]; then mkdir -p ${API_DIR}/${GENE_DIR}; fi

api_tags=${COMPONENTS}
if [ "${COMPONENTS}" == "all" ]; then 
    case ${ACTION} in
        "create"|"update") api_tags="things items links rules";;
        "destroy") api_tags="rules links items things";;        
        *) _err "ACTION '${ACTION}' does not exist";;
    esac
fi

for api_tag in ${api_tags}; do
    echo " -> ${api_tag}"
    
    for esp_index in $(seq ${ESP_INDEX_START} ${ESP_INDEX_END}); do
        _esp ${esp_index}
        filename=${api_tag}_ESP_${model}_TEMPLATE.json
        input_file=${API_DIR}${filename}
        output_file=${API_DIR}${GENE_DIR}$(echo ${filename} | sed "s/TEMPLATE/${esp_name}/g")
        echo " -- -> ${esp_name}, model: ${model}, output_file: ${output_file}"

        if [ ${WEB_PAGES} -eq 1 ]; then _sed ${input_file} ${output_file}; fi
        
        case ${ACTION} in
            "create")
                case ${api_tag} in
                    "things") _loop "POST" ${output_file};;
                    "items")  _curl "PUT"  ${api_tag} ${output_file};;
                    "links")  _loop "PUT"  ${output_file};;
                    "rules")  _loop "POST" ${output_file};;
                    *) _err "API tag '${api_tag}' does not exist.";;
                esac
                ;;
            "update")
                case ${api_tag} in
                    "things") _loop "PUT" ${output_file};;
                    "items")  _curl "PUT" ${api_tag} ${output_file};;
                    "links")  _loop "PUT" ${output_file};;
                    "rules")  _loop "PUT" ${output_file};;
                    *) _err "API tag '${api_tag}' does not exist";;
                esac
                ;;
            "destroy") _loop "DELETE" ${output_file};;
            *) _err "ACTION '${ACTION}' does not exist";;
        esac
    done
done

echo "Done"
exit 0