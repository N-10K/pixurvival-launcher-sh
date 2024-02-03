#!/bin/bash
echo loading variables and functions...

#Variables that are defined in config.json, if you want to know what they do and how to use them, read guide.txt
edited_config=$( jq -r ".edited_config" "config.json" )
java_properly_installed=$( jq -r ".java_properly_installed" "config.json" )
alternate_jar_storage=$( jq -r ".alternate_jar_storage" "config.json" )

#Important vars
#Define in config.json
java_install=$( jq -r ".java_install" "config.json" )
game_ram=$( jq -r ".game_ram" "config.json" )
server_ram=$( jq -r ".server_ram" "config.json" )
server_port=$( jq -r ".server_port" "config.json" )
jar_folder=$( jq -r ".jar_folder" "config.json" )
content_pack_path=$( jq -r ".content_pack_path" "config.json" )


#Do not touch anything below this line!!
java_exec=bin/java
pixurvival_game=pixurvival.jar
pixurvival_server=server.jar
pixurvival_editor=content-pack-editor.jar

#Checks to apply options, to catch errors before they happen, and create funny launch function.
#There likely are better ways of doing this, but I estimate that I will be finished with this by like 2 or 3 AM, so my brain power will be too limited to see them. Will go over it when I'm fully functional.

#DISABLED FOR NOW
#move to pixurvival install if script is in separate directory
#if [[ $moved_script == TRUE ]]
#then
#    cd $pixurvival_install
#fi

#enable java (if properly installed)
if [[ $java_properly_installed == true ]]
then
    local_java=java
else
    local_java=$java_install$java_exec
fi

#enable funny file system
if [[ $alternate_jar_storage == true ]]
then
    pixurvival_game=$jar_folder"pixurvival.jar"
    pixurvival_server=$jar_folder"server.jar"
    pixurvival_editor=$jar_folder"content-pack-editor.jar"
fi

#The funny selection
player_selection () {
    clear && clear
    case $playerinput in
        1)
            echo launching game...
            eval $local_java -jar -Xmx$game_ram $pixurvival_game contentPackDirectory=$content_pack_path
            ;;
        2)
            echo launching content pack editor...
            eval $local_java -jar -Xmx$game_ram $pixurvival_editor contentPackDirectory=$content_pack_path
            ;;
        3)
            echo launching server...
            eval $local_java -jar -Xmx$server_ram $jar_location$pixurvival_server port=$server_port contentPackDirectory=$content_pack_path
            ;;
        4)
            patch_notes
            ;;
        5)
            kill -9 $PPID
            ;;
        *)
            echo launching game...
            eval $local_java -jar -Xmx$game_ram $jar_location$pixurvival_game contentPackDirectory=$content_pack_path
            ;;
    esac
    main_menu
}

main_menu () {
    clear && clear
    #The display and input
    echo "########################################################################"
    echo "# Seraph's Pixurvival Launch Script v1.2                               #"
    echo "# Please type the number for what you would like to launch             #"
    echo "#                                                                      #"
    echo "# 1. Game                                                              #"
    echo "# 2. Content Pack Editor                                               #"
    echo "# 3. Server                                                            #"
    echo "# 4. Patch Notes                                                       #"
    echo "#                                                                      #"
    echo "# 5. Close                                                             #"
    echo "########################################################################"
    read playerinput
    player_selection $playerinput
}

patch_notes () {
    clear && clear
    echo "########################################################################"
    echo "# Seraph's Pixurvival Launch Script v1.0                               #"
    echo "# -initial release                                                     #"
    echo "#                                                                      #"
    echo "# Seraph's Pixurvival Launch Script v1.1                               #"
    echo "# Added:                                                               #"
    echo "#   -variable for custom content pack directory                        #"
    echo "#   -silly little loading message at start                             #"
    echo "#   -clearing terminal text to make it appear \"clean\"                  #"
    echo "#   -added a close launcher option and made it so when game closes it  #"
    echo "#    goes back to the main menu                                        #"
    echo "#   -added check if java executable is a proper executable             #"
    echo "#   -added check if pixurvival jars exist                              #"
    echo "#   -patch notes menu                                                  #"
    echo "#   -renamed pixurvival_launch function to player_selection            #"
    echo "#                                                                      #"
    echo "# Seraph's Pixurvival Launch Script v1.1.1                             #"
    echo "# Fixed:                                                               #"
    echo "#   -stopped sanity checks from only begging the player and not        #"
    echo "#    providing details about the check                                 #"
    echo "# Changed:                                                             #"
    echo "#   -extended patch notes                                              #"
    echo "#                                                                      #"
    echo "# Seraph's Pixurvival Launch Script v1.2                               #"
    echo "# Added:                                                               #"
    echo "#   -config file                                                       #"
    echo "#   -guide for config file and installation                            #"
    echo "# Changed:                                                             #"
    echo "#   -a lot of variable names                                           #"
    echo "# Removed:                                                             #"
    echo "#   -ability to move launcher anywhere on computer                     #"
    read -p "########################################################################"
    main_menu
}

echo checking sanity...
#Perform numerous checks
#checks if config file exists
if [[ -e config.json ]]
then
    echo config found
else
    read -p "Could not find config.json"
    kill -9 $PPID
fi

#Check to make sure people looked over their options and editted the script properly before launching.
if [[ $edited_config == false ]]
then
    read -p "Please open the config in launcher_files in your text editor of choice and modify it as instructed, then restart this script."
    kill -9 $PPID
else
    echo config edited
fi

#There probably is a better way to do this, but here we go, the if chain is real this morning
#Checks if the game, server, and content pack editor jars exist in the directory
if [[ -e $pixurvival_game ]]
then
    echo game found
else
    read -p "Please check if a typo was made, or if the game jar exists."
    kill -9 $PPID
fi

if [[ -e $pixurvival_server ]]
then
    echo server found
else
    read -p "Please check if a typo was made, or if the server jar exists."
    kill -9 $PPID
fi

if [[ -e $pixurvival_editor ]]
then
    echo editor found
else
    read -p "Please check if a typo was made, or if the content pack editor jar exists."
    kill -9 $PPID
fi

#There probably is a better way to do this, but here we go
#Checks if the java file is a file that actually exists (will make it check if it is actually a proper java executable soon)
if [[ $java_properly_installed == FALSE ]]
then
    if [[ -x $local_java ]]
    then
        echo java found
    else
        read -p "Please check the java path you have set, to see if it actually exists or a typo was made."
        kill -9 $PPID
    fi
fi

#initialize
echo ready
main_menu
