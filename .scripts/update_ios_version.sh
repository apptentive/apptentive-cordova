#!/usr/bin/env bash

# Fail on first error.
set -e

# Check for correct number of arguments.
if [ $# -ne 1 ]; then
    echo "Usage: $0 <new.ApptentiveKit.version>"
    exit 1
fi

plugin_xml="plugin.xml"
new_version="$1"

# Check if the plugin.xml exists
if [ ! -f "$plugin_xml" ]; then
    echo "Error: $plugin_xml does not exist."
    exit 1
fi

# Use sed to update the version in the plugin xml file
sed -i "s/<pod name=\"ApptentiveKit\" spec=\"[^\"]*\"/<pod name=\"ApptentiveKit\" spec=\"~\&gt\; $new_version\"/" "$plugin_xml"

echo "Updated iOS ApptentiveKit version to $new_version in $plugin_xml."
