[��װ]
1���ڿ���̨�����ö�Ӧ���͵Ĵ������������
2����װǰȷ��������Ե�SERVER��CLIENT���������ǽ�رա�root�û��ɵ�½����̨���������ӻ��ţ�
3�������߰��ϴ���/homeĿ¼
4��ִ���������װ���Թ���
    cd /home/scripts/
    sh install.sh
	��װ���̻�������¹��̣�
	1���ռ�������Ϣ
	=========>getting info ...
	2����������
	=========>base config
	3��ѡ��װ
	Please choose : 
    [1] Netperf/qperf install.
    [2] fio install.
    [3] Geekbench3 install.
    [4] all install.
    please choose:[1|2|3|4]

	ѡ����ʵ�ѡ�ͽ��а�װ���ɡ�
	
	
5����װnetperf/qperf�������������������ʾ��ס���밴Ctrl + C����
Starting netserver with host 'IN(6)ADDR_ANY' port '12865' and family AF_UNSPEC

6����װ�ɹ������������ʾ��
===>!!!!!![NOTICE] : Please confirm that firewall is OFF and permit_root_login is on before running test

[����]

ִ���������

sh run.sh

Please choose your test : 
[1] Netperf test.
[2] fio test.
[3] Geekbench3 test.
[4] all 3 test above
please choose:[1|2|3|4]

[����鿴]

ԭʼ�������Ŀ¼��  ~/scripts/result/raw

������Ľ�������Բ鿴���ѭ��ִ�еĽ�����ڲ鿴����ָ���ȶ��ԡ�

Geekbench3�����~/scripts/result/geekbench.csv
netperf�����~/scripts/result/net.csv
fio�����~/scripts/result/result_<dev>_<depth>.csv








