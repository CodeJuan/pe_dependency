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

# get pe files
$get_pe_cmd = "dir /S /B /a-d-h-s `"$sw_path`" | findstr /I `".dll .exe`" > $files"
cmd /c "$get_pe_cmd"

# copy mspdb100 to vc_bin
copy-item "$vs_path\Common7\IDE\mspdb100.dll" "$vc_bin" -Force 

# draw graph
$draw = "`"$graph_dot`"  -Tpng graph.txt > graph.png" 
cmd /c "$draw"