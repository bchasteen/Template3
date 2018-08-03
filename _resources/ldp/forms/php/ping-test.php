<?php

function ping($host,$port=80,$timeout=1000000)
{
        $fsock = fsockopen($host, $port, $errno, $errstr, $timeout);
        if ( ! $fsock )
        {
                return "FALSE";
        }
        else
        {
                return "TRUE";
        }
}

$a = ping("http://209.212.159.209", 7518);

echo $a;

?>
