#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

cd "$(dirname "$0")"

declare -r POWER_SUPPLY_DIR=${PB_DUOBATTERY_POWER_SUPPLY_DIR:-/sys/class/power_supply}
declare -r BAT_NAMES=(${PB_DUOBATTERY_NAMES:-BAT0 BAT1})
declare -r BAT_ICONS=(${PB_DUOBATTERY_ICONS:-    })
declare -r BAT_FULL_AT=${PB_DUOBATTERY_FULL_AT:-99}
declare -r BAT_LOW_AT=${PB_DUOBATTERY_LOW_AT:-5}
declare -r BAT_LOW_COLOR=${PB_DUOBATTERY_LOW_COLOR:-''}
# for status
declare -r BAT_STATUS_CHARGING="Charging"
declare -r BAT_STATUS_DISCHARGING="Discharging"
declare -r BAT_STATUS_NOT_CHARGING="Not charging"
declare -r BAT_STATUS_NA=n/a
# for capacity label
declare -r BAT_CAPACITY_NA=n/a
declare -r BAT_CAPACITY_FULL=Full
declare -r BAT_CAPACITY_UNIT=%
declare -r BAT_CAPACITY_PLUS=+
# for time label
declare -r BAT_TIME_LEFT_NA=--:--
# for power label
declare -r BAT_POWER_UNIT=W
declare -r BAT_CHARGE_SIGN=∿
declare -r BAT_DISCHARGE_SIGN=𝌁
declare -r BAT_AC_SIGN=󱒀

main() {
    # Initial variables
    local -a ALL_CHARGE_STOP_THRESHOLD=() # %
    local -a ALL_CAPACITY=()
    local -a ALL_ENERGY_FULL=()
    local -a ALL_ENERGY_NOW=()
    local -a ALL_STATUS=()      # Discharging/Charging/Not charging

    local -i TOT_CAPACITY=0     # %
    local -i TOT_ENERGY_FULL=0  # µWh
    local -i TOT_ENERGY_NOW=0   # µWh
    local -i TOT_POWER_NOW=0    # µW

    # Load battery states
    for bat_name in ${BAT_NAMES[@]}; do
        local bat_dir="$POWER_SUPPLY_DIR/$bat_name"
        loadbat "$bat_dir"
    done

    TOT_CAPACITY=$((${TOT_ENERGY_NOW}00 / $TOT_ENERGY_FULL))

    # Generate result label
    local BAT_LABEL=''
    append_icon $TOT_CAPACITY
    append_capacity
    append_time_left
    append_power_now

    echo $BAT_LABEL
}

append_icon() {
    local icon

    if [[ $TOT_CAPACITY -le $BAT_LOW_AT ]]; then
       if [[ -z "$BAT_LOW_COLOR" ]]; then
           icon=${BAT_ICONS[0]}
       else
           icon="%{F$BAT_LOW_COLOR}${BAT_ICONS[0]}%{F-}"
       fi
    else
        local -r steps=$((${#BAT_ICONS[@]} - 2))
        for (( i=1; i<=$steps; i++ )); do
            if [[ $TOT_CAPACITY -lt $(( $BAT_LOW_AT + $i * (100 - $BAT_LOW_AT) / $steps)) ]]; then
                icon=${BAT_ICONS[$i]}
                break
            fi
        done
        [[ $TOT_CAPACITY -lt $BAT_FULL_AT ]] || icon=${BAT_ICONS[-1]}
    fi

    BAT_LABEL+=$icon
}

append_capacity() {
    local capacity_label=' '
    for (( i=0; i<${#ALL_CAPACITY[@]}; i++ )); do
        [[ $i -eq 0 ]] || capacity_label+=$BAT_CAPACITY_PLUS
        local capacity=${ALL_CAPACITY[$i]}
        if [[ $capacity == $BAT_CAPACITY_NA ]]; then
            capacity_label+=$capacity
        elif [[ $capacity -ge $BAT_FULL_AT ]]; then
            capacity_label+=$BAT_CAPACITY_FULL
        else
            if [[ $capacity -le $BAT_LOW_AT && -n "$BAT_LOW_COLOR" ]]; then
                capacity_label+="%{F$BAT_LOW_COLOR}$capacity$BAT_CAPACITY_UNIT%{F-}"
            else
                capacity_label+=$capacity$BAT_CAPACITY_UNIT
            fi
        fi
    done
    BAT_LABEL+=$capacity_label
}

append_time_left() {
    local time_label=' '
    if [[ $TOT_POWER_NOW -gt 0 ]]; then
        local time_left # s, battery life or time to charge full
        case ${ALL_STATUS[@]} in
            *$BAT_STATUS_CHARGING*) # time to charge full
                local -i eff_energy_full=0
                for (( i=0; i<${#ALL_ENERGY_FULL[@]}; i++ )); do
                    eff_energy_full+=$((${ALL_ENERGY_FULL[$i]} * ${ALL_CHARGE_STOP_THRESHOLD[$i]} / 100))
                done
                time_left=$((3600 * ($eff_energy_full - $TOT_ENERGY_NOW) / $TOT_POWER_NOW))
                ;;&
            *$BAT_STATUS_DISCHARGING*) # battery life
                time_left=$((3600 * $TOT_ENERGY_NOW / $TOT_POWER_NOW))
                ;;&
            *$BAT_STATUS_CHARGING*|*$BAT_STATUS_DISCHARGING*)
                local time
                TZ=UTC printf -v time '%(%-H:%M)T' $time_left
                time_label+=$time
                ;;
            *)
                time_label+=$BAT_TIME_LEFT_NA
                ;;
        esac
    else
        time_label+=$BAT_TIME_LEFT_NA
    fi
    BAT_LABEL+=$time_label
}

append_power_now() {
    local power_label
    case ${ALL_STATUS[@]} in
        *$BAT_STATUS_CHARGING*)
            power_label=$BAT_CHARGE_SIGN
            ;;&
        *$BAT_STATUS_DISCHARGING*)
            power_label=$BAT_DISCHARGE_SIGN
            ;;&
        *$BAT_STATUS_CHARGING*|*$BAT_STATUS_DISCHARGING*)
            local -r power=$(bc <<< "scale=1; $TOT_POWER_NOW / 1000000")
            power_label+=${power:0:3}$BAT_POWER_UNIT
            ;;
        *)
            power_label=$BAT_AC_SIGN
            ;;
    esac
    BAT_LABEL+=$power_label
}

# alarm 1055000
# charge_stop_threshold 50
#
# POWER_SUPPLY_NAME=BAT1
# POWER_SUPPLY_TYPE=Battery
# ✓ POWER_SUPPLY_STATUS=Discharging|Charging|Not charging
# ✓ POWER_SUPPLY_PRESENT=1
# POWER_SUPPLY_TECHNOLOGY=Li-ion
# POWER_SUPPLY_CYCLE_COUNT=0
# POWER_SUPPLY_VOLTAGE_MIN_DESIGN=10800000
# POWER_SUPPLY_VOLTAGE_NOW=10937000
# ✓ POWER_SUPPLY_POWER_NOW=4987000
# POWER_SUPPLY_ENERGY_FULL_DESIGN=47520000
# ✓ POWER_SUPPLY_ENERGY_FULL=40950000
# ✓ POWER_SUPPLY_ENERGY_NOW=20100000
# ✓ POWER_SUPPLY_CAPACITY=49
# POWER_SUPPLY_CAPACITY_LEVEL=Normal
# POWER_SUPPLY_MODEL_NAME=45N1736
# POWER_SUPPLY_MANUFACTURER=SMP
# POWER_SUPPLY_SERIAL_NUMBER=  569

loadbat() {
    local charge_stop_threshold=100 \
          capacity=$BAT_CAPACITY_NA \
          energy_full=0 \
          energy_now=0 \
          status=$BAT_STATUS_NA

    if [[ -d "$1" ]]; then
        local -r bat_dir="$1"
        local -r present=$(< $bat_dir/present)
        if [[ $present -eq 1 ]]; then
            charge_stop_threshold=$(< $bat_dir/charge_stop_threshold)
            capacity=$(< $bat_dir/capacity)
            energy_full=$(< $bat_dir/energy_full)
            energy_now=$(< $bat_dir/energy_now)
            status=$(< $bat_dir/status)

            TOT_ENERGY_FULL+=energy_full
            TOT_ENERGY_NOW+=energy_now

            if [[ $status != $BAT_STATUS_NOT_CHARGING ]]; then
                TOT_POWER_NOW=$(< $bat_dir/power_now)
            fi
        fi
    fi

    ALL_CHARGE_STOP_THRESHOLD+=($charge_stop_threshold)
    ALL_CAPACITY+=($capacity)
    ALL_ENERGY_FULL+=($energy_full)
    ALL_ENERGY_NOW+=($energy_now)
    ALL_STATUS+=($status)
}

main "$@"
