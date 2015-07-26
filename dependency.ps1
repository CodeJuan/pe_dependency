Param(
   [Parameter(Mandatory=$True)]
   [string]$sw_path
)

######
$vs_path="D:\Program Files\Microsoft Visual Studio 10.0"
$graph_dot="D:\Program Files\Graphviz2.38\bin\dot.exe"


#####
$dumpbin="$vs_path\VC\bin\dumpbin.exe"
$vc_bin="$vs_path\VC\bin\"
$files="files.txt"

$script:pe_list = [string[]]@()
$graphtxt="graph.txt"
$deptxt="dependency.txt"
###

function append($str)
{
    $str | out-file $script:graphtxt -append -encoding ASCII
}

# get pe files
$get_pe_cmd = "dir /S /B /a-d-h-s `"$sw_path`" | findstr /I `".dll .exe`" > $files"
cmd /c "$get_pe_cmd"

# copy mspdb100 to vc_bin
copy-item "$vs_path\Common7\IDE\mspdb100.dll" "$vc_bin" -Force 

# pe filename to pe_list
GC ".\$files" | ForEach-Object {
    $line = $_
    if ($line.length -eq 0)
    {
        continue
    }
    $lastidx = $line.lastindexof("\")+1
    $pename = $line.substring($lastidx, $line.length-$lastidx)
    $pename = $pename.tolower()
    $pename = $pename.replace(".","_")
    $pename = $pename.replace("-","_")
    $script:pe_list += $pename
}

# write the header of dot
"digraph G {" | out-file $script:graphtxt -encoding ASCII
append "rankdir=BT;"

# dependency
GC ".\$files" | ForEach-Object {
    $line = $_
    if ($line.length -eq 0)
    {
        continue
    }
    $lastidx = $line.lastindexof("\")+1
    $pename = $line.substring($lastidx, $line.length-$lastidx)
    $pename = $pename.tolower()
    $pename = $pename.replace(".","_")
    $pename = $pename.replace("-","_")
    
    append "`"$pename`"[shape=box,fontname=consolas];"
    append "`"$pename`"->{"
    
    write-host analyzing $pename
    
    $dump_cmd = "`"$dumpbin`" /dependents `"$line`" | findstr /I .dll | findstr /I /vi `"dump of file`" > $deptxt"
    cmd /c "`"$dump_cmd`""
    
    GC $deptxt | ForEach-Object {
        $depen = $_
        $depen = $depen.tolower()
        $depen = $depen.replace("    ", "")
        $depen = $depen.replace(".","_")
        $depen = $depen.replace("-","_")
        $bFound = 0
        for ($i = 0; $i -lt $script:pe_list.length; $i++ )
        {
            $peinlist = $script:pe_list[$i]
            $cmp = $peinlist.compareto($depen)
            if ($cmp -eq 0)
            {
                $bFound = 1
            }
        }
        if ($bFound -eq 1)
        {
            append "`"$depen`";"
        }
    }
    append "};"
}
append "}"

# draw graph
$draw = "`"$graph_dot`" $graphtxt -Tpng  > dependency_graph.png" 
write-host $draw
cmd /c "$draw"