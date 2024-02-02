#!/bin/bash
echo loading variables and functions...
#This is to prevent people from not editting the launcher script and saying that it doesn't work. Change this variable to TRUE after looking this over and making required changes.
edited_script=FALSE
#Change this to TRUE if you are moving the launch script itself.
moved_script=FALSE
#Change this to TRUE if you have Java properly installed on your system, it is java 8 or 11, and have your environment variables modified.
java_properly_installed=FALSE
#Change this to TRUE if you're like me and wanted to have your file layout be the one I showed in the Discord (only use if you are insane).
funny_file_layout=FALSE

#Define important variables here, such as the location of your Java install (leave blank if you have java in your environment variables), the location of your Pixurvival install, and RAM. If using the default port (7777), leave server_port alone.
java_install=
pixurvival_install=
game_ram=2048M
server_ram=2048M
server_port=7777
#Used for when funny_file_layout is TRUE
jar_folder=jar/
#If you store content packs elsewhere that isn't the working directory/pixurvival installation directory, use this to specify that path, otherwise leave as default.
content_pack_path=contentPacks/


#Do not touch anything below this line!!
java_exec=bin/java
pixurvival_game=pixurvival.jar
pixurvival_server=server.jar
pixurvival_editor=content-pack-editor.jar

#Checks to apply options, to catch errors before they happen, and create funny launch function.
#There likely are better ways of doing this, but I estimate that I will be finished with this by like 2 or 3 AM, so my brain power will be too limited to see them. Will go over it when I'm fully functional.

#move to pixurvival install if script is in separate directory
if [[ $moved_script == TRUE ]]
then
    cd $pixurvival_install
fi

#enable java (if properly installed)
if [[ $java_properly_installed == TRUE ]]
then
    local_java=java
else
    local_java=$java_install$java_exec
fi

#enable funny file system
if [[ $funny_file_layout == TRUE ]]
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
    echo "# Seraph's Pixurvival Launch Script v1.1                               #"
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
    read -p "########################################################################"
    main_menu
}

echo checking sanity...
#Perform numerous checks
#Check to make sure people looked over their options and editted the script properly before launching.
if [[ $edited_script == FALSE ]]
then
    read -p Please open the script in your text editor of choice and modify it as instructed, then restart this script.
    kill -9 $PPID
fi

#There probably is a better way to do this, but here we go, the if chain is real this morning
#Checks if the game, server, and content pack editor jars exist in the directory
if [[ -e $pixurvival_game ]]
then
    return
else
    read -p Please check if you set the pixurvival installation path, if a typo was made, or if the game jar exists.
    kill -9 $PPID
fi

if [[ -e $pixurvival_server ]]
then
    return
else
    read -p Please check if you set the pixurvival installation path, if a typo was made, or if the server jar exists.
    kill -9 $PPID
fi

if [[ -e $pixurvival_editor ]]
then
    return
else
    read -p Please check if you set the pixurvival installation path, if a typo was made, or if the content pack editor jar exists.
    kill -9 $PPID
fi

#There probably is a better way to do this, but here we go
#Checks if the java file is a file that actually exists (will make it check if it is actually a proper java executable soon)
if [[ $java_properly_installed == FALSE ]]
then
    if [[ -x $local_java ]]
    then
        return
    else
        read -p Please check the java path you have set, to see if it actually exists or a typo was made.
        kill -9 $PPID
    fi
fi

#initialize
echo ready
main_menu
