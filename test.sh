#!/bin/bash

#wget https://backstage.eu/veranstaltungen/live.html?p=1 -O file.html
  echo "<table>
  <tr>
    <th>Datum</th>
    <th>Band</th>
    <th>Genre</th>
    <th>Preis</th>
  </tr>" > result.html

for page in $(seq 1 29);
do
  wget -q https://backstage.eu/veranstaltungen/live.html?p=$page -O file.html

    for i in $(seq 1 10);
    do
        title=$(./xidel -s file.html -e /html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/strong/a) # bandname
        link=$(./xidel -s file.html -e "/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/strong/a/@href") # bandname
        datum=$(./xidel -s file.html -e /html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/h6[5]/strong[1]) # datum
        genre=$(./xidel -s file.html -e /html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[$i]/div/div[2]/div[2] | xargs | sed s/"Learn More"//) # genre


        wget -q $link -O detailpage.html

        price=$(./xidel -s detailpage.html -e /html/body/div[2]/main/div[2]/div/div[1]/div[2]/div/h6/a/span[2]) # preis
        echo "<tr>" >> result.html
        echo "<td>$datum</td>" >> result.html
        echo "<td><a href=$link>$title</td>" >> result.html

        echo "<td>$genre</td>" >> result.html
        echo "<td>$price</td>" >> result.html
        echo "</tr>" >> result.html
        #echo $datum,$title,$genre
    done

done
echo "</tr></table>" >> result.html



#/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[1]/div/div[2]/strong/a # bandname
#/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[1]/div/div[2]/h6[5]/strong[1] # datum
#/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[1]/div/div[2]/div[2] # genre

#/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[2]/div/div[2]/strong/a
#/html/body/div[2]/main/div[2]/div[1]/div[4]/div[2]/ol/li[10]/div/div[2]/strong/a
