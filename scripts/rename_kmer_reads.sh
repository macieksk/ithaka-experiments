awk 'BEGIN {RS = ">" ; FS = "\n" ; ORS = ""} $2 {print ">S:"$2"|C:"$1"\n"$2"\n"}' $*
