module dht11
(
input wire sys_clk , //系统时钟，频率50MHz
input wire sys_rst_n , //复位信号，低电平有效
input wire key_in , //按键信号

inout wire dht11 , //数据总线

output wire stcp , //输出数据存储寄时钟
output wire shcp , //移位寄存器的时钟输入
 output wire ds , //串行数据输入
 output wire oe ,//输出使能信号
output wire beep ,
output wire [15:0] rgb_tft , //TFT显示数据
output wire hsync , //TFT行同步信号
output wire vsync , //TFT场同步信号
output wire tft_clk , //TFT像素时钟
output wire tft_de , //TFT数据使能
output wire tft_bl //TFT背光信号
 );

 ////
 //\* Parameter and Internal Signal \//
 ////

 //wire define
 
 wire [19:0] data_out;
 wire [19:0] data_out_d;
 
 wire [19:0] data_out_1; //需要显示的数据
 
 wire [19:0] data_out_2; 
 wire [19:0] data_out_3; //需要显示的数据
 wire [19:0] data_out_4;
 
 wire data_flag_1;
 wire key_flag; //按键消抖后输出信号
 wire sign ; //输出符号
 wire ageb_sig ;
 wire ageb_sig_1 ;
 wire ageb_sig_2 ;
 wire rst_n ;
 wire areset ;
 wire inclk0 ;
 wire c0 ;
 wire locked ;
  assign rst_n = (sys_rst_n & ageb_sig);
  assign rst_n1 = (sys_rst_n & locked & ageb_sig);
  assign ageb_sig = (ageb_sig_1 | ageb_sig_2);
 ////
 //\* Main Code \//
 ////

 //-------------dht11_ctrl_inst--------------
 dht11_ctrl dht11_ctrl_inst
 (
 .sys_clk (sys_clk ), //系统时钟，频率50MHz
 .sys_rst_n (sys_rst_n), //复位信号，低电平有效
 .key_flag (key_flag ), //按键消抖后标志信号

 .dht11 (dht11 ), //控制总线
 .data_out (data_out ),
 .data_out_1 (data_out_1 ), //输出显示的数据
 .data_out_2 (data_out_2 ),
 .data_flag_1 (data_flag_1),
 .sign (sign ) //输出符号
 );



 //-------------key_fifter_inst--------------
 key_filter key_filter_inst
 (
 .sys_clk (sys_clk ), //系统时钟50MHz
 .sys_rst_n (sys_rst_n), //全局复位
 .key_in (key_in ), //按键输入信号

 .key_flag (key_flag ) //按键消抖后输出信号

 );

Average_Filter Average_Filter_inst
 (
 .sys_clk (sys_clk ), //系统时钟，频率50MHz
 .sys_rst_n (sys_rst_n), //复位信号，低有效
 .din ( data_out_1 ),
 .dout ( data_out_3 )
);

Average_Filter Average_Filter1_inst
 (
 .sys_clk (sys_clk ), //系统时钟，频率50MHz
 .sys_rst_n (sys_rst_n), //复位信号，低有效
 .din ( data_out_2 ),
 .dout ( data_out_4 )
);

Average_Filter Average_Filter2_inst
 (
 .sys_clk (sys_clk ), //系统时钟，频率50MHz
 .sys_rst_n (sys_rst_n), //复位信号，低有效
 .din ( data_out ),
 .dout ( data_out_d )
);



 //-------------seg_595_dynamic_inst--------------
 seg_595_dynamic seg_595_dynamic_inst
 (
 .sys_clk (sys_clk ), //系统时钟，频率50MHz
 .sys_rst_n (sys_rst_n), //复位信号，低有效
 .data (data_out_d ), //数码管要显示的值
 .point (6'b000010), //小数点显示,高电平有效
 .seg_en (1'b1 ), //数码管使能信号，高电平有效
 .sign (sign ), //符号位，高电平显示负号

 .stcp (stcp ), //输出数据存储寄时钟
 .shcp (shcp ), //移位寄存器的时钟输入
 .ds (ds ), //串行数据输入
 .oe (oe ) //输出使能信号

 );
 
 
 
 comparator	comparator_inst 
 (
	.clock ( sys_clk ),
	.dataa ( data_out_4[11:0] ),
	
	.ageb ( ageb_sig_1 )
);
 
  comparator1	comparator1_inst 
 (
	.clock ( sys_clk ),
	.dataa ( data_out_3[11:0] ),
	
	.ageb ( ageb_sig_2 )
);

 clk_gen clk_gen_inst
 (
   .areset (~sys_rst_n ), //输入复位信号,高电平有效,1bit
   .inclk0 (sys_clk ), //输入50MHz晶振时钟,1bit
   .c0 (tft_clk_9m ), //输出TFT工作时钟,频率9MHz,1bit

   .locked (locked ) //输出pll locked信号,1bit
 );


 tft_char tft_char_inst
 (
    .sys_clk ( sys_clk ) , 
    .sys_rst_n ( rst_n1 ),
    .ageb_sig1 (data_flag_1),
    .ageb_sig2  (data_flag_1),
    .rgb_tft (rgb_tft ), //TFT显示数据
    .hsync (hsync ), //TFT行同步信号
    .vsync (vsync ), //TFT场同步信号
    .tft_clk (tft_clk ), //TFT像素时钟
    .tft_de (tft_de ), //TFT数据使能
    .tft_bl (tft_bl ) //TFT背光信号

 );

 
 beep beep_inst
 (
  .sys_clk ( sys_clk ) , //系统时钟,频率50MHz
  .sys_rst_n ( rst_n ), //系统复位，低有效

  .beep ( beep )//输出蜂鸣器控制信号
 );
 
 endmodule