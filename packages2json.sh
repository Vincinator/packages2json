#!/bin/bash

packages_file=$1

multis_keywords=(
  Provides
  Depends
  Tag
  Conflicts
  Breaks
  Replaces
  Suggests
  Enhances
)

singles_keywords=(
  Pritoriy
  Section
  Installed-Size
  Maintainer
  Architecture 
  Source
  Version
  MD5Sum
  SHA1
  SHA256
  SHA512
  Description
  Description-Md5
  Multi-Arch
  Homepage
 )


nr_pkgs=0
echo "["
while read line; do
  IFS=': ' read -r key value <<< "$line"
  if [[ $line == Package:* ]]; then
    if [[ $nr_pkgs -gt 0 ]]; then
      echo ","
    fi
    let "nr_pkgs++"
    echo "{"
    #value=$(trim "$value")
    echo "\"$key\": \"$value\""
    continue
  elif [[ -z $line ]]; then
    echo "}"
    continue
  else 

    
    #process_single "$key" "$value"
    for keyword in "${singles_keywords[@]}"; do
      if [[ $line == "$keyword:"* ]]; then
        let "nr_attr++"
        # previous item was obviously not the last attribute
        echo ","
        value="${value//\"/\'}"
        echo "\"$key\": \"$value\""
        break
      fi
    done
    #process_single "$key" "$value"
    for keyword in "${multis_keywords[@]}"; do
      if [[ $line == "$keyword:"* ]]; then
        # previous item was obviously not the last attribute
        echo ","
        echo "\"$key\":"
        value=$(echo "$value," | tr -d '[:space:]')
        readarray -td, FIELDS <<<"$value"
        unset 'FIELDS[-1]';
        echo "["
        nr_items=0
        for item in "${FIELDS[@]}"; do
          if [[ $nr_items -gt 0 ]]; then
            echo ","
          fi
          let "nr_items++"
          echo -e "\t\t\"$item\""  
        done
        echo "]"
        break
      fi
    done
  fi

done < $packages_file


echo "]"
