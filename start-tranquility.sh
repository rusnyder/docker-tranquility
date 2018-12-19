#!/bin/sh

set -eo pipefail

# Vars
INSTALL_DIR=/usr/share/tranquility
CONF=''

# If a config file was specified, we'll start the server with
# that configuration pre-loaded
if [ -n "$TRANQUILITY_CONFIG_FILE" ]; then
  # Additional env vars prefixed with "TRANQUILITY_PROPERTIES_"
  # can be used to override connection properties from the provided
  # config file
  jq_exp=''
  for var in $(env | grep -E '^TRANQUILITY_PROPERTIES_'); do
    if [ -n "$jq_exp" ]; then
      jq_exp="${jq_exp} | "
    fi
    key="$(echo "$var" \
      | cut -d'=' -f1 \
      | sed -e 's/TRANQUILITY_PROPERTIES_//' \
      | tr '[:upper:]' '[:lower:]' \
      | tr '_' '.')"
    val="$(echo "$var" | sed -e 's/^[^=]\+=//')"
    jq_exp="${jq_exp}.properties[\"$key\"] = \"$val\""
  done

  # If we created a substitution string, apply it to the config
  if [ -n "$jq_exp" ]; then
    tmpf=$(mktemp)
    jq "$jq_exp" "$TRANQUILITY_CONFIG_FILE" > "$tmpf"
    TRANQUILITY_CONFIG_FILE="$tmpf"
  fi

  # Finally, define the config string to append to the executable
  CONF="-configFile $TRANQUILITY_CONFIG_FILE"
  echo "Running with config: $(jq --compact-output . < "$TRANQUILITY_CONFIG_FILE")"
fi

"${INSTALL_DIR}/bin/tranquility" server "$CONF"
