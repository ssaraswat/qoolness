filename=$1
touch "$filename"
mv "$filename" `echo "$filename"|sed 's/ /_/g'`
