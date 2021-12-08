## Default parameters

Can be changed directly on the top of the `generate.sh` script file.

````commandline
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
_JQ="jq"
````