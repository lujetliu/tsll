#!/usr/bin/env bash
# shellcheck disable=SC1003
#

parse_yaml() {
    local yaml_file=$1
    local prefix=$2
    local s
    local w
    local fs

    s='[[:space:]]*'
    w='[a-zA-Z0-9_.-]*'
    fs="$(echo @ | tr @ '\034')"

    (
        sed -e '/- [^\“]'"[^\']"'.*: /s|\([ ]*\)- \([[:space:]]*\)|\1-\'$'\n''  \1\2|g' |
            sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/[[:space:]]*$//g;' \
                -e 's/\$/\\\$/g' \
                -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
                -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
                -e "s|^\($s\)\($w\)${s}[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |
            awk -F"$fs" '{
            indent = length($1)/2;
            if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
            vname[indent] = $2;
            for (i in vname) {if (i > indent) {delete vname[i]}}
                if (length($3) > 0) {
                    vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                    printf("%s%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, conj[indent-1], $3);
                }
            }' |
            sed -e 's/_=/+=/g' |
            awk 'BEGIN {
                FS="=";
                OFS="="
            }
            /(-|\.).*=/ {
                gsub("-|\\.", "_", $1)
            }
            { print }'
    ) <"$yaml_file"
}

unset_variables() {
    # Pulls out the variable names and unsets them.
    #shellcheck disable=SC2048,SC2206 #Permit variables without quotes
    local variable_string=($*)
    unset variables
    variables=()
    for variable in "${variable_string[@]}"; do
        tmpvar=$(echo "$variable" | grep '=' | sed 's/=.*//' | sed 's/+.*//')
        variables+=("$tmpvar")
    done
    for variable in "${variables[@]}"; do
        if [ -n "$variable" ]; then
            unset "$variable"
        fi
    done
}

create_variables() {
    local yaml_file="$1"
    local prefix="$2"
    local yaml_string
    yaml_string="$(parse_yaml "$yaml_file" "$prefix")"
    unset_variables "${yaml_string}"
    eval "${yaml_string}"
}

# parse_yaml "./docker-compose.yaml" "yaml_"
create_variables "./docker-compose.yaml" "yaml_"

CREATE_TAILSCALE="docker run -h $yaml_services_tailscale_hostname " 

# cap_add
# ca0=${yaml_services_tailscale_cap_add[0]}
# ca1=${yaml_services_tailscale_cap_add[1]}
for i in ${yaml_services_tailscale_cap_add[@]};do
	CREATE_TAILSCALE="${CREATE_TAILSCALE} --cap-add $i "
done


# privileged
privi=${yaml_services_tailscale_privileged}
if [ $privi = "true" ]; then
	CREATE_TAILSCALE="${CREATE_TAILSCALE} --privileged "
fi

# env_file
envf=${yaml_services_tailscale_env_file}
if [ -f "$envf" ];then
	CREATE_TAILSCALE="${CREATE_TAILSCALE} --env-file $envf"
fi

# ports
# CREATE_TAILSCALE="${CREATE_TAILSCALE} -p "
for i in ${yaml_services_tailscale_ports[@]};do
	CREATE_TAILSCALE="${CREATE_TAILSCALE} -p $i "
done

cpath=$(pwd ) # use absolute path
for i in ${yaml_services_tailscale_volumes[@]};do
	v=$(echo $i |  sed -e 's/^["]*//g' -e 's/["]*$//g')
	# check is current path
	if [[ $v == .* ]];then
		v=$(echo $v | sed -e "s/^\.//g")
		v=$cpath$v
	fi
	CREATE_TAILSCALE="${CREATE_TAILSCALE} -v $v "
done

# name


# network
# CREATE_TAILSCALE="${CREATE_TAILSCALE}"
hostname=${yaml_services_tailscale_hostname}
hostname=$(echo $hostname | sed 's/[ ]*//g')
network_name="${hostname}_default"

# create a network
docker network create $network_name

CREATE_TAILSCALE="${CREATE_TAILSCALE} --network $network_name "

# name
tailscale_name="${hostname}-tailscale-1"
CREATE_TAILSCALE="${CREATE_TAILSCALE} --name $tailscale_name "

# image
image=${yaml_services_tailscale_image}
CREATE_TAILSCALE="${CREATE_TAILSCALE} -d $image "

# command
tailscale_cmd=${yaml_services_tailscale_command}
if [ ! -z "$tailscale_cmd" ];then
	CREATE_TAILSCALE="${CREATE_TAILSCALE} $tailscale_cmd "
fi


eval $CREATE_TAILSCALE


#------------------------------------------------------------aither
CREATE_AITHER="docker run "

name=${yaml_services_aither_container_name}
if [ ! -z "$name" ];then
	CREATE_AITHER="${CREATE_AITHER} --name $name "
fi

# privileged
privi=${yaml_services_aither_privileged}
if [ $privi = "true" ]; then
	CREATE_AITHER="${CREATE_AITHER} --privileged "
fi

# envs 
for i in ${yaml_services_aither_environment[@]};do
	CREATE_AITHER="${CREATE_AITHER} -e $i "
done

# user
user=${yaml_services_aither_user}
CREATE_AITHER="${CREATE_AITHER} -u $user "

tty=${yaml_services_aither_tty}
if [ $tty = "true" ]; then
	CREATE_AITHER="${CREATE_AITHER} -t "
fi


# stdin=${yaml_services_aither_stdin_open}
# if [ $stdin = "true" ]; then
# 	CREATE_AITHER="${CREATE_AITHER} -a STDOUT "
# fi

# volumes
cpath=$(pwd ) # use absolute path
for i in ${yaml_services_aither_volumes[@]};do
	v=$(echo $i |  sed -e 's/^["]*//g' -e 's/["]*$//g')
	# check is current path
	if [[ $v == .* ]];then
		v=$(echo $v | sed -e "s/^\.//g")
		v=$cpath$v
	fi
	CREATE_AITHER="${CREATE_AITHER} -v $v "
done

for i in ${yaml_services_aither_ports[@]};do
	CREATE_AITHER="${CREATE_AITHER} -p $i "
done

# network
nwk=${yaml_services_aither_network_mode}
if [ ! -z "$nwk" ];then
	nwk=${nwk##service:}
	CREATE_AITHER="${CREATE_AITHER} --net container:$tailscale_name "
fi


# image
# image=${yaml_services_aither_image}
CREATE_AITHER="${CREATE_AITHER} -d enokiinc/aither "

aither_cmd=${yaml_services_aither_command}
if [ ! -z "$aither_cmd" ];then
	CREATE_AITHER="${CREATE_AITHER} $aither_cmd "
fi

eval $CREATE_AITHER

sleep 1

docker exec  $tailscale_name  tailscale up --authkey=$TAILSCALE_AUTH_KEY

