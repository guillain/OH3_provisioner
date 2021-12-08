## Tree

````commandline
$ find . | grep -v '.git' | grep -v '.idea' | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
.
  |-.env
  |-app
  |  |-ESP
  |  |  |-config.dat
  |  |  |-rules1.txt
  |  |  |-rules2.txt
  |  |  |-rules4.txt
  |  |-generate.sh
  |  |-jq.exe
  |  |-NodeRed
  |  |  |-ESP_8266-RFID_TEMPLATE.json
  |  |  |-ESP_8266_TEMPLATE.json
  |  |  |-functions.json
  |  |-OpenHAB
  |  |  |-API
  |  |  |  |-items_ESP_32_TEMPLATE.json
  |  |  |  |-items_ESP_8266_TEMPLATE.json
  |  |  |  |-items_Location_TEMPLATE.json
  |  |  |  |-links_ESP_32_TEMPLATE.json
  |  |  |  |-links_ESP_8266_TEMPLATE.json
  |  |  |  |-rules_ESP_32_TEMPLATE.json
  |  |  |  |-rules_ESP_8266_TEMPLATE.json
  |  |  |  |-things_ESP_32_TEMPLATE.json
  |  |  |  |-things_ESP_8266_TEMPLATE.json
  |  |  |-ESP_32_Overview_HEADER.yml
  |  |  |-ESP_32_Overview_TEMPLATE.yml
  |  |  |-ESP_32_Page_TEMPLATE.yml
  |  |  |-ESP_8266_Overview_HEADER.yml
  |  |  |-ESP_8266_Overview_TEMPLATE.yml
  |  |  |-ESP_8266_Page_TEMPLATE.yml
  |  |  |-HABPanel
  |  |  |  |-first_floor.html
  |  |  |  |-ground_floor.html
  |  |  |  |-images
  |  |  |  |  |-0_ground_floor.png
  |  |  |  |  |-1_first_floor.png
  |  |  |  |  |-2_second_floor.png
  |  |  |  |  |-outdoor.png
  |  |  |  |-outdoor.html
  |  |  |  |-second_floor.html
  |  |  |  |-test.html
  |  |  |-map
  |  |  |  |-lamp.map
  |  |  |  |-switch.map
  |-doc
  |  |-default_parameters.md
  |  |-images
  |  |  |-ESP-device_overview.png
  |  |  |-HABPanel-Overview.png
  |  |  |-HABPanel_first_floor.png
  |  |  |-HABPanel_ground_floor.png
  |  |  |-HABPanel_outdoor.png
  |  |  |-HABPanel_second_floor.png
  |  |  |-OH3-ESP_32-Overview.png
  |  |  |-OH3-ESP_32-Page.png
  |  |  |-OH3-ESP_8266-Overview.png
  |  |  |-OH3-ESP_8266-Page.png
  |  |  |-OH3-ESP_8266_RFID-Page.png
  |  |  |-OH3-Overview-Location.png
  |  |  |-OH3-Properties.png
  |  |  |-OH3_Temperature-analyse.png
  |  |-infrastructure.md
  |  |-links.md
  |  |-next.md
  |  |-prerequisite.md
  |  |-usage.md
  |-README.md
  |-TODO.txt
````
