#!/bin/bash
cat inputfiles/* > infile
currentword=""
while read line; do
  for word in $line; do
    previousword=$currentword
    currentword=$word
    echo $previousword $currentword >> tempwordfile
   done
done < infile

echo "Words written to wordfile. Removing duplicates and weird chars ..."
grep -o '[a-zA-Z0-9.,; ]*' tempwordfile | sort | uniq > wordfile
echo "Wordfile sorted. Removing single words ..."
sed -i -r '/^\s*\S+\s*$/d' wordfile
# First line, too. It is empty.
sed -i -e "1d" wordfile

echo "Creating outfile now."

numberoflines=$(wc -l <wordfile)

titlepart1=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
titlepart2=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
titlepart3=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
titlepart4=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
title="$(echo ${titlepart1^} ${titlepart2^} ${titlepart3^} ${titlepart4^})"
echo "$title"
printf "$title\n" > outfile
printf "by Gauntlet O. Manatee and $(hostname)\n" >> outfile
printf "\n" >> outfile
printf "NaNoGenMo 2018\n" >> outfile
printf "\n" >> outfile

chapter=1
while [ $chapter -lt 51 ]; do
  headlinepart1=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
  headlinepart2=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
  headlinepart3=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
  headlinepart4=$(head -$(( ( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
  headline="$(echo ${headlinepart1^} ${headlinepart2^} ${headlinepart3^} ${headlinepart4^})"
  printf "\n\nChapter $chapter: $headline\n" >> outfile
  echo "Writing chapter $chapter ..."
  printf "\n" >> outfile
  wordcount=1
    while true; do
      firstword=$(head -$((( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
      firstword=${firstword^}
      secondword=$(grep ^"$firstword " wordfile | shuf -n 1 | cut -d" " -f2)
      if [ -z $secondword ] ; then
        firstword=$(head -$((( RANDOM % $numberoflines )  + 1 )) wordfile | tail -1 | cut -d" " -f2)
      else
        firstword=$secondword
      fi
      let wordcount++
      echo $wordcount
      newline="$newline $firstword"
      if [[ $secondword = *. ]]; then
        if [ $wordcount -gt 1000 ]; then
          echo "$newline" >> outfile
          break
        else
          echo "$newline" >> outfile
          newline=""
        fi
      fi
    done
  echo "Chapter $chapter written"
  let chapter++
done

# remove leading whitespace and make sure every line starts with uppercase
sed -i -e 's/^[ \t]*//' outfile
sed  -i -e 's/^\(.\)/\U\1/' outfile

echo "All chapters written."
totalwords=$(wc -w <outfile)
echo "$totalwords words in total."
