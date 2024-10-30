#!/bin/bash
export XIDEL=/home/bierchitekt/bin/xidel
result=$(pwd)/zenith-konzerte.html

echo "<table>
  <tr>
    <th>Datum</th>
    <th>Band</th>
    <th>Details</th>
  </tr>" > "$result"

wget https://muenchen.motorworld.de/ -O zenith.html

for i in $(seq 1 99); do
  artist=$(/home/bierchitekt/bin/xidel -s zenith.html -e "/html/body/main/div/div/div[5]/div/div/div[1]/div/div/div[$i]/a/div/div[2]/div/div[1]/div/h1")
  if [[ $artist == "" ]]; then
    continue
  fi
  datum=$(/home/bierchitekt/bin/xidel -s zenith.html -e "/html/body/main/div/div/div[5]/div/div/div[1]/div/div/div[$i]/a/div/div[3]/div/div/div")

  details=$(/home/bierchitekt/bin/xidel -s zenith.html -e "/html/body/main/div/div/div[5]/div/div/div[1]/div/div/div[$i]/a/div/div[2]/div/div[2]/div")

  link=$(/home/bierchitekt/bin/xidel -s zenith.html -e "/html/body/main/div/div/div[5]/div/div/div[1]/div/div/div[$i]/a/@href")
  echo "<tr>" >> "$result"
  echo "<td>$datum</td>">> "$result"
  echo "<td><a href=$link>$artist</a></td>" >> "$result"

  echo "<td>$details</a></td>" >> "$result"
  echo "</tr>">> "$result"
done
echo "</table>" >> "$result"

rm zenith.html

