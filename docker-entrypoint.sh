#!/bin/sh

# Vars
INSTALL_DIR=/usr/share/tranquility
CONFIG_FILE=${INSTALL_DIR}/conf/tranquility/server.json

# Process any env vars
jq_exp=''
for var in `env | grep -E '^TRANQUILITY_PROPERTIES_'`; do
  if [ -n "$jq_exp" ]; then
    jq_exp="${jq_exp} | "
  fi
  key=`echo "$var" \
    | cut -d'=' -f1 \
    | sed -e 's/TRANQUILITY_PROPERTIES_//' \
    | tr '[:upper:]' '[:lower:]' \
    | tr '_' '.'`
  val=`echo "$var" | sed -e 's/^[^=]\+=//'`
  jq_exp="${jq_exp}.properties[\"$key\"] = \"$val\""
done

echo "VAR: $jq_exp"

# If we created a substitution string, apply it to the config
if [ -n "$jq_exp" ]; then
  tmpf=$(mktemp)
  jq "$jq_exp" $CONFIG_FILE > "$tmpf"
  mv -f "$tmpf" "$CONFIG_FILE"
fi

cat $CONFIG_FILE
#echo ${INSTALL_DIR}/bin/tranquility server -configFile ${CONFIG_FILE}
