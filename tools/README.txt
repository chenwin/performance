[安装]
1、在控制台创建好对应类型的待测试虚拟机；
2、安装前确保网络测试的SERVER和CLIENT虚拟机防火墙关闭、root用户可登陆、两台虚拟机间添加互信；
3、将工具包上传到/home目录
4、执行如下命令安装测试工具
    cd /home/scripts/
    sh install.sh
	安装过程会包括如下过程：
	1）收集配置信息
	=========>getting info ...
	2）基础配置
	=========>base config
	3）选择安装
	Please choose : 
    [1] Netperf/qperf install.
    [2] fio install.
    [3] Geekbench3 install.
    [4] all install.
    please choose:[1|2|3|4]

	选择合适的选型进行安装即可。
	
	
5、安装netperf/qperf过程中如果出现如下提示后卡住，请按Ctrl + C跳过
Starting netserver with host 'IN(6)ADDR_ANY' port '12865' and family AF_UNSPEC

6、安装成功后会有如下提示：
===>!!!!!![NOTICE] : Please confirm that firewall is OFF and permit_root_login is on before running test

[运行]

执行如下命令：

sh run.sh

Please choose your test : 
[1] Netperf test.
[2] fio test.
[3] Geekbench3 test.
[4] all 3 test above
please choose:[1|2|3|4]

[结果查看]

原始结果保存目录：  ~/scripts/result/raw

解析后的结果：可以查看多次循环执行的结果用于查看性能指标稳定性。

Geekbench3结果：~/scripts/result/geekbench.csv
netperf结果：~/scripts/result/net.csv
fio结果：~/scripts/result/result_<dev>_<depth>.csv








