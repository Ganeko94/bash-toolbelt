#!/bin/bash

isSilent="0"

silent=""

while getopts "s" opt; do
  case $opt in
    s) isSilent=1 ;;    # Option -s: silent
  esac
done

if [ $isSilent -eq "1" ]
then
  silent="--silent -o /dev/null"
fi

# URL del endpoint
#url="http://localhost:9000/metrics"
url="http://localhost:9000/oam/api/v1.0/tenants"
# TODO: Unify with the endpoint above
login_url="http://localhost:9000/oam/api/v1.0/login"
login_data="{\"username\": \"nemergent\",\"password\": \"NemergentSolutions2017\"}"
OAM_SESSION_COOKIE="OAM_SESSION=$(curl --silent -o /dev/null -X POST -c - -H "Content-Type: application/json" -d "$login_data" "$login_url" | awk '$6 == "OAM_SESSION" {print $7}')"
echo "$OAM_SESSION_COOKIE"
echo "$silent"

# Datos para el POST (Obtenidos desde el portapapeles)
data=$(xclip -o -selection clipboard)

# Dividir el contenido por líneas y guardarlo en un array
IFS=$'\n' read -rd '' -a values <<< "$data"

# Realizar las llamadas POST de manera secuencial
for value in "${values[@]}";
do
  # TODO: Based on the type of request, change the curl request
  #curl --silent -o /dev/null -X POST -H "Content-Type: application/json" -w "Code: %{response_code} - ErrorMsg: %{errormsg} - Value: $value\n" -d "$value" --cookie "$OAM_SESSION_COOKIE" "$url"
  curl $silent -X POST -H "Content-Type: application/json" -w "Code: %{response_code} - ErrorMsg: %{errormsg} - Value: $value\n" -d "$value" --cookie "$OAM_SESSION_COOKIE" "$url"
  #curl --silent -o /dev/null -w "Code: %{response_code} - Value: $value\n" "$url"
done

