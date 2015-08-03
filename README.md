# pe_dependency
分析软件里所有PE文件(exe,dll)的依赖关系，并生成依赖图

## 使用方法
1. 安装graphviz2.38[http://www.graphviz.org/Download_windows.php](http://www.graphviz.org/Download_windows.php)到D盘program files
2. 安装VS2010到到D盘program files
```batch
powershell .\dependency.ps1 -sw_path '软件的路径'
```
比如说我要分析腾讯TM，那么`powershell .\dependency.ps1 -sw_path 'D:\Program Files\Tencent\TM'`就OK啦

## 注意
1. 如果graphviz/VS2010没装在D盘，那么修改`dependency.ps1`的$vs_path和$graph_dot为实际的路径即可
2. 脚本在运行过程中会拷贝`mspdb100.dll`到VS\VC\BIN目录下，最后才删除。如果脚本异常终止了，请手动删除`mspdb100.dll`，不然会导致C1902

## 效果图
分析了一下腾讯TM
![](https://github.com/CodeJuan/pe_dependency/raw/master/dependency_graph11.png)


点击图片可以放大
