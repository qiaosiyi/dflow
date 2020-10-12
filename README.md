# dflow

DFLOW工程的硬件模块。

DFLOW工程有三个任务，

- 1）提取5元祖信息获取其HASH结果，更新RAM存储。

- 2）添加交换机ID 以及测量时间戳。

- 3）利用探测包，带走RAM中存储的数据。

工程的数据总线输入输出均为AXI-Stream，数据位宽256bits。可直接安插在数据通路总线之间。

普通数据包只做DFLOW的核心算法（1），探测数据包需要做数据平面的修改（2）（3）。

python文件生成5元祖参数，可以填写入硬件文件，目前默认探测包为：SIP:10.9.8.222 DIP:10.9.8.7 SPORT:54321 DPORT:54321 PROTOCOL:17(UDP)

PAYLOAD:{8'hFF,16'h0000}*10, 16'h0001, 128'h0, 32'h0, 64'h0.

{ID, △time}*10, address, 5tuple(32'h SIP, 32'h DIP, 16'h SPORT, 16'h DPORT, 8'h P, 24'h0),counter, volume.
