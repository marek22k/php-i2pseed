<?php

$i2pjar     = "?";
$signerid   = "?";

exec("wget http://127.0.0.1:7657/createreseed -O i2pseeds.zip -q");
exec("java -cp " . $i2pjar . " net.i2p.crypto.SU3File sign i2pseeds.zip i2pseeds.su3 ../private/private-2s.ks $(date '+%s') " . $signerid . " -c RESEED -f ZIP < ../private/private-2s.pw");

?>

