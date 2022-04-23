

# Colors used in printing
Green="\033[0;32m"
Blue="\033[0;34m"
Red="\033[0;31m"
NC="\033[0m" # No Color


# use -e flag in print functions to allow backslash escape 
print_succeed() {
    echo -e "- * -  ${Green}${1}${NC}"
}

print_status() {
    echo -e "- * -  ${Blue}${1}${NC}"
}

print_fail() {
    echo -e "- * -  ${Red}${1}${NC}"
}

print_indicate() {
    echo -e "- * -  ${Bold}${1}${NC}"
}

CheckStr() {
    [ ! -z "$1" ]
}

CheckCommandExist() {
    # return true if the command exist

    CheckStr "$(command -v $1)"
}

isFileExist() {
    [ -f $1 ]
}

isDirExist() {
    [ -d "$1" ]
}