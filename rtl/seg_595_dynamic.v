module seg_595_dynamic
(
input wire sys_clk , //系统时钟，频率50MHz
input wire sys_rst_n , //复位信号，低有效
input wire [19:0] data , //数码管要显示的值
input wire [5:0] point , //小数点显示,高电平有效
input wire seg_en , //数码管使能信号，高电平有效
input wire sign , //符号位，高电平显示负号

 output wire stcp , //输出数据存储寄时钟
 output wire shcp , //移位寄存器的时钟输入
 output wire ds , //串行数据输入
 output wire oe //输出使能信号

 );

 ////
 //\* Parameter And Internal Signal \//
 ////

 //wire define
 wire [5:0] sel; //数码管位选信号
 wire [7:0] seg; //数码管段选信号

 ////
 //\* Main Code \//
 ////

 seg_dynamic seg_dynamic_inst
 (
 .sys_clk (sys_clk ), //系统时钟，频率50MHz
 .sys_rst_n (sys_rst_n), //复位信号，低有效
 .data (data ), //数码管要显示的值
 .point (point ), //小数点显示,高电平有效
 .seg_en (seg_en ), //数码管使能信号，高电平有效
 .sign (sign ), //符号位，高电平显示负号

 .sel (sel ), //数码管位选信号
 .seg (seg ) //数码管段选信号

 );

 hc595_ctrl hc595_ctrl_inst
 (
 .sys_clk (sys_clk ), //系统时钟，频率50MHz
 .sys_rst_n (sys_rst_n), //复位信号，低有效
 .sel (sel ), //数码管位选信号
 .seg (seg ), //数码管段选信号

 .stcp (stcp ), //输出数据存储寄时钟
 .shcp (shcp ), //移位寄存器的时钟输入
 .ds (ds ), //串行数据输入
 .oe (oe )

 );

 endmodule