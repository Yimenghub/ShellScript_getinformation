# This script is can be use to get any information in linux system such as:
1. get user information
2. get file/folder informatin
3. get information about IP address/hostname

# usage: 
1. Navigate to to directory that contain our script file named: "getinformatin.sh"
2. Set file permission to our script file by using command: "chmod +x getinformation.sh" then execute it
3. We have 3 differents options, You can execute our script file by choose one of our option: 
    $ getinformation.sh [U|USER] <username>
    $ getinformation.sh [F|FILE |P|PATH] <pathname>
    $ getinformation.sh [I|IP |H|HOST] <hostname|ip>

# here is example:
# just type like this to execute our script file:
    -- to get user information:
    ./getinformation.sh user john | ./getinformatin.sh USER john

    -- to get file/folder information:
    ./getinformation.sh path /etc/passwd | ./getinformation.sh PATH /etc/passwd

    -- to get IP address/hostname information:
    ./getinformation.sh host 1.1.1.1 | ./getinformation.sh IP 1.1.1.1
   