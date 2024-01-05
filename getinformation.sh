#!/bin/bash

# Linux Group 9

# Check if provided number of arguments is correct
if [ "$#" -lt 2 ]; then
    # user
    echo "Usage: $0 [U | USER | u | user] <username>"
fi

if [ "$#" -lt 2 ]; then
    # file
    echo "Usage: $0 [F | FILE | P | PATH] <pathname>"
fi

if [ "$#" -lt 2 ]; then
    # host
    echo "Usage: $0 [I |IP | H | HOST]  <hostname|ip>"
    exit 1
fi

# Parse command-line options
option="$1"
username="$2"
pathname="$2"
hostname="$2"
target="$2"

user_id=$(id -u "$username" 2>/dev/null)
group_id=$(id -g "$username" 2>/dev/null)
group_name=$(id -nG "$username" 2>/dev/null)

input="$pathname"
output=$(echo "$input" | sed 's:/$::')

#variable for user
user_owner=$(stat -c '%U' "$output" 2>/dev/null)
group_owner=$(stat -c '%G' "$output" 2>/dev/null)
permissions=$(stat -c "%A" "$output" 2>/dev/null)
user_permissions=${permissions:1:3}
group_permissions=${permissions:4:3}
others_permissions=${permissions:7:3}

#variable for file path
last_modified=$(stat -c "%Y" "$output" 2>/dev/null)
formatted_date=$(date -d "@$last_modified" +"%b %d %Y" 2>/dev/null)
filesize=$(sudo du -sh "$output" 2>/dev/null | awk '{print $1}' )

host_name=$(dig +noall +answer google.de)

home_dir=$(eval echo ~"$username")
get_onlydate=`last -n 1 | awk '{if ($9 != "in") print $4, $5, $6, $7, $8, $9}'`


# Check the option and perform the corresponding action
case "$option" in
    U | USER | u | user)
	
        # Check if the username exists
        if id "$username" &>/dev/null; then
            echo "Username: $username"

	    #get full name using getent and awk
	    full_name=$(getent passwd $username | cut -d: -f5)

	    #extract first 2 words from the full name field
	    two_word=$(echo "$full_name" | awk -F, '{print $1}')

	    # Check if the full name is empty or not
	    if [ -n "$two_word" ] && [[ "$two_word" =~ [a-zA-Z0-9] ]]; then
    	    	echo "Full name : $two_word"
	    else
    	    	echo "Full name : none"

	    fi
	  
	    echo "UID, GID: $user_id, $group_id"

	    #check which groups that user belong to
	    if [ -n "$group_name" ]; then
		echo "Group(s): $group_name"
	    else
		echo "Group(s): none"
	    fi
	   
	    #check home directory
	    echo "Home Dir: $home_dir"

	    #get only date from the last time loggin
	    echo "Last Login: $get_onlydate"
        else
            echo "User '$username' does not exist on the system."
        fi
    	;;
    F | FILE | f | file | P | PATH | p | path)

	# Check if the file or folder path exists
	if [ -e "$pathname" ]; then
    	    echo "Full Pathname: $output"
			echo "Owner: User= $user_owner, Group= $group_owner"
			#echo "File or Folder? "
			if [ -f "$output" ]; then
				echo "File or Folder? file"
			elif [ -d "$output" ]; then
				echo "File or Folder? Folder"
			else
				echo "It's neither a regular file or a directory."
			fi
			echo "Permission: user= $user_permissions, group= $group_permissions, others= $others_permissions"
			echo "Last Modified: $formatted_date"
			echo "Size: $filesize"
	else
    	    echo "File or folder does not exist."
	fi
        ;;
    I | IP |i | ip | H | HOST | h | host)

	# Check if user input host_name or ipaddress
	if [[ "$target" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		ip_address="$target"
		hostname=$(getent hosts "$ip_address" | awk '{print $2}' | head -n 1)
	else
		hostname="$target"
		# Resolve hostname to IP address
		ip_address=$(getent ahostsv4 "$hostname" | awk '{print $1}' | head -n 1)
	fi

	# Validate if the provided hostname exists
	if [ -n "$ip_address" ]; then
		# Get organization information using whois command
		whois_info=$(whois "$ip_address")

		# Extract and display organization information
		organization=$(echo "$whois_info" | grep -i "Organization:" | awk -F: '{print $2}' | sed 's/^[[:space:]]*//')
		country=$(echo "$whois_info" | grep -i "Country:" | awk -F: '{print $2}' | sed 's/^[[:space:]]*//')

		# Display information
		echo "IP Address: $ip_address"
		echo "Hostname: $hostname"

		# Check reachability
		if ping -c 4 "$hostname" &>/dev/null; then
			echo "Reachable: Yes"
		else
			echo "Reachable: No"
		fi

		# Get default gateway
		gateway=$(ip route show | grep default | awk '{print $3}')
		interface=$(ip route show | grep default | awk '{print $5}')

		# Display information
		echo "Route/Gateway: $gateway dev $interface"
		echo "Organization: $organization"
		echo "Country: $country"
	else
		echo "Invalid hostname or IP address: $target"
	fi
		;;
    *)
        echo -e "Invalid option.\nChoose option: \n[U | USER]\n[F | FILE | P | PATH]\n[I | IP | H | HOST]"
        exit 1
        ;;
esac

#by_yimeng
