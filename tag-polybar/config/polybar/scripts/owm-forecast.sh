#!/bin/sh

get_icon() {
    case $1 in
        # Icons for Nerd Fonts Weather Icons
        01d) icon="";; # clear sky
        01n) icon="";;
        02d) icon="";; # few clouds
        02n) icon="";;
        03*) icon="";; # scattered clouds
        04*) icon="";; # broken clouds
        09d) icon="";; # shower rain
        09n) icon="";;
        10d) icon="";; # rain
        10n) icon="";;
        11d) icon="";; # thunderstorm
        11n) icon="";;
        13d) icon="";; # snow
        13n) icon="";;
        50d) icon="";; # mist
        50n) icon="";;
        *  ) icon="";

        # Icons for Nerd Fonts Material Design Icons
        # 01d) icon="󰖙";; # clear sky
        # 01n) icon="󰖔";;
        # 02d) icon="󰖕";; # few clouds
        # 02n) icon="󰼱";;
        # 03*) icon="󰖐";; # scattered clouds
        # 04*) icon="󰖐";; # broken clouds
        # 09*) icon="󰖖";; # shower rain
        # 10d) icon="󰼳";; # rain
        # 10n) icon="󰖗";;
        # 11d) icon="󰼲";; # thunderstorm
        # 11n) icon="󰖓";;
        # 13d) icon="󰼴";; # snow
        # 13n) icon="󰖘";;
        # 50*) icon="󰖑";; # mist
        # *  ) icon="󱓤";

        # Icons for weather-icons
        # 01d) icon="";;
        # 01n) icon="";;
        # 02d) icon="";;
        # 02n) icon="";;
        # 03*) icon="";;
        # 04*) icon="";;
        # 09d) icon="";;
        # 09n) icon="";;
        # 10d) icon="";;
        # 10n) icon="";;
        # 11d) icon="";;
        # 11n) icon="";;
        # 13d) icon="";;
        # 13n) icon="";;
        # 50d) icon="";;
        # 50n) icon="";;
        # *) icon="";

        # Icons for Font Awesome 5 Pro
        #01d) icon="";;
        #01n) icon="";;
        #02d) icon="";;
        #02n) icon="";;
        #03d) icon="";;
        #03n) icon="";;
        #04*) icon="";;
        #09*) icon="";;
        #10d) icon="";;
        #10n) icon="";;
        #11*) icon="";;
        #13*) icon="";;
        #50*) icon="";;
        #*) icon="";
    esac

    [ -n "$PB_OWM_ICON_FONT" ] && echo %{$PB_OWM_ICON_FONT}$icon%{T-} || echo $icon
}

KEY="${PB_OWM_KEY}"
CITY="${PB_OWM_CITY}"
UNITS="${PB_OWM_METRIC:-metric}"
SYMBOL="${PB_OWM_SYMBOL:-°}"

API="https://api.openweathermap.org/data/2.5"

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    current=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    forecast=$(curl -sf "$API/forecast?appid=$KEY&$CITY_PARAM&units=$UNITS&cnt=1")
else
    location=$(curl -sf "https://location.services.mozilla.com/v1/geolocate?key=geoclue")

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        current=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
        forecast=$(curl -sf "$API/forecast?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS&cnt=1")
    fi
fi

if [ -n "$current" ] && [ -n "$forecast" ]; then
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")
    # current_desc=$(echo "$current" | jq -r ".weather[0].description")

    forecast_temp=$(echo "$forecast" | jq ".list[].main.temp" | cut -d "." -f 1)
    forecast_icon=$(echo "$forecast" | jq -r ".list[].weather[0].icon")
    # forecast_desc=$(echo "$forecast" | jq -r ".list[].weather[0].description")

    if [ "$current_temp" -gt "$forecast_temp" ]; then
        trend=""
    elif [ "$forecast_temp" -gt "$current_temp" ]; then
        trend=""
    else
        trend=""
    fi

    echo "$(get_icon "$current_icon") $current_temp$SYMBOL $trend $(get_icon "$forecast_icon") $forecast_temp$SYMBOL"
fi
