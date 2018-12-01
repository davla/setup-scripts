#!/usr/bin/env bash

# This script serves the purpose of making some self-made bash scripts and C
# files available as CLI commands. This is achieved by copying them to
# directories found in the PATH variable; C files are actually not copied, but
# compiled to binaries placed in such directories.
#
# The files available for copying are located in Support/bin. Files in the
# `user` subfolder will be available for non-root users, while files in the
# `root` subfolder will be available to root only. It is possible to
# copy/compile all the files or just some, by providing their names as CLI
# arguments.

# Aguments:
#   - $@: Names of bash scripts/C files to be copied/compiled.

#####################################################
#
#                   Variables
#
#####################################################

# Base directory where custom commands are located
CMD_DIR='Support/bin'

# Subdirectories of CMD_DIR where root and user commands are respectively
ROOT_CMD_SUBDIR='root'
USER_CMD_SUBDIR='user'

# Full path of root and user commands respectively
ROOT_CMD_DIR="$CMD_DIR/$ROOT_CMD_SUBDIR"
USER_CMD_DIR="$CMD_DIR/$USER_CMD_SUBDIR"

# Destination directories of root and user commands respectively
ROOT_BIN_PATH='/usr/local/sbin'
USER_BIN_PATH='/usr/local/bin'

#####################################################
#
#                   Functions
#
#####################################################

# This function compiles a C file to an executable with the same name, but
# extension-less in the destination directory. The SUID bit is also set on the
# executable, since there are little reasons to use C other than accessing the
# low level Unix C API for root tasks.
#
# Arguments:
#   $1: C source file.
#   $2: Destination directory.
function compile-c {
    local SOURCE="$1"
    local DEST_DIR="$2"

    local EXEC_NAME
    EXEC_NAME=$(basename "$SOURCE" .c)
    local EXEC_PATH="$DEST_DIR/$EXEC_NAME"

    gcc "$SOURCE" -o "$EXEC_PATH"
    chmod u+s "$EXEC_PATH"
    echo "$EXEC_NAME.c compiled and SUID bit set"
}

# This function copies a file in a destination directory.
#
# Arguments
#   $1: Source file.
#   $2: Destination directory.
function copy-file {
    local SOURCE="$1"
    local DEST_DIR="$2"

    local FILE_NAME
    FILE_NAME="$(basename "$1")"

    cp "$FILE" "$DEST_DIR/$FILE_NAME"
    echo "$FILE_NAME copied"
}

# This function processes all the files in a directory, by passing them to
# process-file, using the same destination directory for all of them.
#
# Arguments:
#   - $1: The source directory.
#   - $2: The destination directory.
function process-dir {
    local SOURCE="$1"
    local DEST="$2"

    # -exec would not work since process-file is not in PATH
    find "$SOURCE" -maxdepth 1 -type f -o -type l | process-file "$DEST"

    echo "Done with files in $SOURCE -> $DEST"
}

# This filter processes files. This means that:
#     - they are compiled if they are C files.
#     - they are copied if they are bash/python script or symbolic links.
#     - they are skipped if they are anything else.
# The output of the processing is the same directory for all the files.
#
# Arguments:
#   - $1: The destination directory.
function process-file {
    local DEST_DIR="$1"

    while read FILE; do
        case $(file -b "$FILE" | awk '{print tolower($1)}') in
            'c')
                compile-c "$FILE" "$DEST_DIR"
                ;;

            'bourne-again'|'python'|'symbolic')
                copy-file "$FILE" "$DEST_DIR"
                ;;

            *)
                echo >&2 "$FILE is neither a C source, nor a bash/python " \
                    "script, neither a symbolic link"
                continue
                ;;
        esac
    done
}

#####################################################
#
#                   Privileges
#
#####################################################

# Checking for root privileges: if don't have them, recalling this script with
# sudo
if [[ $EUID -ne 0 ]]; then
    echo 'This script needs to be run as root'
    sudo bash "$0" "$@"
    exit 0
fi

#####################################################
#
#               Processing files
#
#####################################################

# Files are given from the command line
if [[ $# -gt 0 ]]; then
    for FILE in "$@"; do
        FILE_PATH=$(find "$CMD_DIR" -name "$FILE")

        if [[ "$FILE_PATH" == */$USER_CMD_SUBDIR/* ]]; then
            DEST_PATH="$USER_BIN_PATH"

        elif [[ "$FILE_PATH" == */$ROOT_CMD_SUBDIR/* ]]; then
            DEST_PATH="$ROOT_BIN_PATH"

        elif [[ -z "$FILE_PATH" ]]; then
            echo >&2 "$FILE not found!"
            continue

        else
            # Some other error, hopefully an error message has already been
            # printed
            continue
        fi

        process-file "$DEST_PATH" <<<"$FILE_PATH"
    done

# All script in store are processed
else

    # Root
    [[ -d "$ROOT_CMD_DIR" ]] \
        && process-dir "$ROOT_CMD_DIR" "$ROOT_BIN_PATH" \
        || echo >&2 "$ROOT_CMD_DIR is not a directory: skipping root " \
            'executables'

    # User
    [[ -d "$USER_CMD_DIR" ]] \
        && process-dir "$USER_CMD_DIR" "$USER_BIN_PATH" \
        || echo >&2 "$USER_CMD_DIR is not a directory: skipping user " \
            'executables'
fi
