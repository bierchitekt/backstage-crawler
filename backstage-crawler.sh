#!/bin/bash
export XIDEL=/home/bierchitekt/bin/xidel

echo "<table>
  <tr>
    <th>Datum</th>
    <th>Band</th>
    <th>Genre</th>
    <th>Preis</th>
  </tr>" > result.html

for page in $(seq 1 27);
do
  echo "getting page number $page"

  wget -q https://backstage.eu/veranstaltungen/live.html?p="$page" -O file.html

    for i in $(seq 1 10);
    do
        title=$($XIDEL -s file.html -e "/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/strong/a" | xargs)
        link=$($XIDEL -s file.html -e "/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/strong/a/@href") 
        datum=$($XIDEL -s file.html -e "/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/h6[5]/strong[1]")
        genre=$($XIDEL -s file.html -e "/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/div[2]" | xargs | sed s/"Learn More"// |xargs)


        wget -q "$link" -O detailpage.html

        price=$($XIDEL -s detailpage.html -e /html/body/div[2]/main/div[2]/div/div[1]/div[2]/div/h6/a/span[2]) # preis
        {
          echo  "<tr>"
          echo "<td>$datum</td>"
          echo "<td><a href=$link>$title</a></td>"

          echo "<td>$genre</td>"
          echo "<td>$price</td>"
          echo "</tr>"
        } >> result.html
    done

done
echo "</table>" >> result.html
rm file.html detailpage.html
