#
1)访问https://github.com/new 来Create a new repository

# performance
首次提交
2)初始化空目录
    echo "# performance" >> README.md
    git init
    git config --global user.name "XXX"
    git config --global user.email "XXX"
    git add README.md
    git commit -m "first commit"
    git remote add origin https://github.com/chenwin/performance.git
    git push -u origin master

提交目录，把新目录cp到项目根路径下
3）添加文件或目录到服务器
    git add .
    git commit -m 'vm-iops'
    git config --global user.name "XXX"
    git config --global user.email "XXX"
    git push -u origin master
    
    删除
    git rm -r UnixBench

# diskbench最新版
https://github.com/bentu86/diskbench
