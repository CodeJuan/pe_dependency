# pe_dependency
分析软件里所有PE文件(exe,dll)的依赖关系，并生成依赖图

## 使用方法
1. 安装graphviz2.38[http://www.graphviz.org/Download_windows.php](http://www.graphviz.org/Download_windows.php)到D盘program files
2. 安装VS2010到到D盘program files
```batch
powershell dependency.ps1 -sw_path "软件的路径"
```
比如说我要分析腾讯TM，那么`powershell dependency.ps1 -sw_path "D:\Program Files\Tencent\TM"`就OK啦