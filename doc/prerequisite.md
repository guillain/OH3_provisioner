## Pre-requisite
### File templates
Prepare **yours** file templates by:
- reusing and adapting the existing ones
- generating your own

#### Template from the repo
1. ESP-32: **Web cam**
   - OpenHab:
       - API: 
           - `./OpenHAB/API/items_ESP_32_TEMPLATE.json`
           - `./OpenHAB/API/links_ESP_32_TEMPLATE.json`
           - `./OpenHAB/API/rules_ESP_32_TEMPLATE.json`
           - `./OpenHAB/API/things_ESP_32_TEMPLATE.json`
       - Web pages:
           - `./OpenHAB/ESP_32_Overview_TEMPLATE.yml`
           - `./OpenHAB/ESP_32_Page_TEMPLATE.yml`
2. ESP-8266: **Sensors** (temperature, luminosity, humidity, sound, presence, motion, water pump, sole moisture)
   - OpenHab:
       - API: 
           - `./OpenHAB/API/items_ESP_8266_TEMPLATE.json`
           - `./OpenHAB/API/links_ESP_8266_TEMPLATE.json`
           - `./OpenHAB/API/rules_ESP_8266_TEMPLATE.json`
           - `./OpenHAB/API/things_ESP_8266_TEMPLATE.json`
       - Web pages:
           - `./OpenHAB/ESP_8266_Overview_TEMPLATE.yml`
           - `./OpenHAB/ESP_8266_Page_TEMPLATE.yml`
   - NodeRed: (old setup, no more used)
       - `./NodeRed/ESP_8266_TEMPLATE.yml`
3. ESP-8266-RFID: **RFID**
    - Firmware: https://github.com/esprfid
        - `./ESP/normal_ESP8266-RFID_v5.3.bin` (not provided by the SCM)
    - Templates: (industrialisation ongoing)
    - NodeRed:
       - `./NodeRed/ESP_8266-RFID_TEMPLATE.yml`

#### Generate your templates
To easily prepare the TEMPLATES, you can export your current configuration, clean it and convert it to template.

Below an example that can be used to do it:
````commandline
ESP_PATTERN="My_pattern_to_grabe_one_thing"
for tag in "things" "items" "links" "rules"; do
    # Grabe the current conf
    _curl "GET" ${tag} > ${tag}.json
    
    # Add the key words to be replaced, cf. `generate.sh` fct `_sed`
    # - ESP_REFERENCE <> esp_reference
    # - ESP_NAME <> esp_name
    # - ESP_LOCATION <> esp_location
    # - ESP_IP_ADDRESS <> esp_ip_address
    # - ESP_ICON <> esp_icon
    # - OPENHAB_WEB_URL <> OH_WEB_URL
    # - ROW_REFERENCE  <> PAGE_ROW_INDEX + row_index
    
    # Save the template
    ${_JQ} ".[] | select(.label | contains(${ESP_PATTERN}))" ${tag}.json > ${tag}_ESP_8266_TEMPLATE.json
done
````

### OpenHAB3

#### Map transformation
Copy the map files in your OpenHab instance:
- Source:
  - `./OpenHAB/map/lamp.map`
  - `./OpenHAB/map/switch.map`
- Destination:
  - `/etc/openhab/transform/`

They are used by some linked items.

#### HABPanel
##### Images
Copy and/or change the image files in your OpenHab instance in the static web server folder:
- Source:
  - `./OpenHAB/HABPanel/images/0_ground_floor.png`
  - `./OpenHAB/HABPanel/images/1_first_floor.png`
  - `./OpenHAB/HABPanel/images/2_second_floor.png`
- Destination:
  - `/etc/openhab/html/images/`

So the images can be browsed on the following url: https://opnehab:8443/images/{IMAGE_NAME}.png

They are used as background images of the HABPanel floor displays.

##### Layout
Copy and/or adapt the web page from `OpenHAB/HABPanel/*.html` according to your needs.

### ESP
We need of course some ESP ready to be used.

For that the following firmwares have been build. Only the ESP-8266 has few tuning.
1. ESP-32: **Web cam** 
    - Firmware: https://github.com/easytarget/esp32-cam-webserver
2. ESP-8266: **Sensors** (temperature, luminosity, humidity, sound, presence, motion, water pump, sole moisture)
    - Firmware: https://github.com/letscontrolit/ESPEasy
    - Rules
        - `./ESP/rules1.txt`
        - `./ESP/rules2.txt`
        - `./ESP/rules4.txt`

    *tips*: when you have huge number of devices, use the file explorer to upload a generic `config.data` on all of 
your devices and just adapt the needs (ie ES Pref and IP address)
4. ESP-8266-RFID: **RFID**
    - Firmware: https://github.com/esprfid
