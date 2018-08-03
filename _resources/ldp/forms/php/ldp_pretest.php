<?php
echo "<p>Testing json_encode() and xmlrpc_decode():<br/>";
if (function_exists("json_encode"))
{
    echo "json_encode() enabled";
}
else
{
    echo "json_encode() NOT enabled";

}
//var_dump(function_exists("json_encode"));
echo "<br/>";

if (function_exists("xmlrpc_decode"))
{
    echo "xmlrpc_decode() enabled";
}
else
{
    echo "xmlrpc_decode() NOT enabled";

}

if (function_exists("curl_init"))
{
    echo "curl_init() enabled";
}
else
{
    echo "curl_init() NOT enabled";

}

echo "</p>";
?>