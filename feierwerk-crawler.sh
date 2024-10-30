#!/bin/bash
export XIDEL=/home/bierchitekt/bin/xidel
current_dir=$(pwd)
result=$(pwd)/feierwerk-konzerte.html

echo "<table>
  <tr>
    <th>Datum</th>
    <th>Band</th>
    <th>Genre</th>
    <th>Details</th>
  </tr>" > "$result"

wget -r -l 1 https://www.feierwerk.de/konzert-kulturprogramm/kkp

cd www.feierwerk.de/konzert-kulturprogramm/ || exit 1


find . -type f -name "*kkp*" -print0 | while IFS= read -r -d '' file; do
  # Tue etwas mit jeder gefundenen Datei
#  echo "Gefundene Datei: $file"

 for i in $(seq 1 20); do
  IN=$(/home/bierchitekt/bin/xidel -s $file -e  "/html/body/div[1]/div/div[1]/div/div[2]/div[7]/div[1]/div[$i]" | xargs)
  IFS='|';
  arrIN=($IN);
  unset IFS;
  datum=${arrIN[0]}
  details=${arrIN[2]}
  IFS='»';
  arrIN=($details)

  tourname=${arrIN[0]}

  IFS='[';
  arrIN=(${arrIN[1]})

  artist=${arrIN[0]}
  if [ ${#arrIN[@]} -eq 0 ]; then
    unset IFS;
      continue
  fi

  genre=${arrIN[1]}
  unset IFS;
  if [[ $genre == *"Malerei"* ]]; then
    continue
  fi

  echo "<tr>" >> "$result"
  echo "<td>$datum</td>">> "$result"
  echo "<td>$artist</a></td>" >> "$result"

  echo "<td>$genre</td>">> "$result"
  echo "<td>$tourname</td>" >> "$result"
  echo "</tr>">> "$result"
done

done
echo "</table>" >> "$result"
cd $current_dir
rm -rf www.feierwerk.de/
