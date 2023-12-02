#!/usr/bin/env bash

# This script should update any incidental copies of the 
# "single source of truth" version, e.g. in package.json.
# It will be different for each project.

# Fail on first error.
set -e

# Check for correct number of arguments.
if [ $# -ne 1 ]; then
    echo "Usage: $0 <new.distribution.version>"
    exit 1
fi

new_version="$1"
package_json="package.json"

# Check if the package.json file exists
if [ ! -f "$package_json" ]; then
    echo "Error: $package_json does not exist."
    exit 1
fi

version_script=".version=\"$new_version\""
yq -iP $version_script "$package_json" -o json

echo "Updated version to $new_version in $package_json."

plugin_xml="plugin.xml"

# Check if the podspec file exists
if [ ! -f "$plugin_xml" ]; then
    echo "Error: $plugin_xml does not exist."
    exit 1
fi

# Use sed to update the version in the plugin xml file
sed -i "s/<pod name=\"ApptentiveKit\" spec=\"[^\"]*\"/<pod name=\"ApptentiveKit\" spec=\"&gt; $new_version\"/" "$plugin_xml"

echo "Updated version to $new_version in $plugin_xml."

javascript_file="www/Apptentive.js"

# Check if the javascript file exists
if [ ! -f "$javascript_file" ]; then
    echo "Error: $javascript_file does not exist."
    exit 1
fi

# Use sed to update the version in the javascript file
sed -i "s/distributionVersion: \"[^\"]*\"/distributionVersion: \"$new_version\"/" "$javascript_file"

echo "Updated version to $new_version in $javascript_file."
