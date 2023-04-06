# packages2json
Bash script that converts a apt Packages file to json

## Usage
``` 
# For example use the Garden Linux packages file for today binary-amd64
curl -s https://repo.gardenlinux.io/gardenlinux/dists/today/main/binary-amd64/Packages > Packages
./packages2json.sh Packages
``` 
