module Average_Filter
#(
	parameter AVE_DATA_NUM = 5'd8,
	parameter AVE_DATA_BIT = 5'd3
)
(
	input  wire sys_rst_n,
	input wire sys_clk,
	input wire [19:0]din,
	output wire [19:0]dout
);

reg [19:0] data_reg [AVE_DATA_NUM-1:0];
reg [7:0]  temp_i;
reg [19:0] sum;

assign dout = sum >> AVE_DATA_BIT; //右移3 等效为÷8

always @ (posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
	for (temp_i=0; temp_i<AVE_DATA_NUM; temp_i=temp_i+1)
		data_reg[temp_i] <= 'd0;
else
begin
	data_reg[0] <= din;
	for (temp_i=0; temp_i<AVE_DATA_NUM-1; temp_i=temp_i+1)
		data_reg[temp_i+1] <= data_reg[temp_i];
end

always @ (posedge sys_clk or negedge sys_rst_n)
if (!sys_rst_n)
	sum <= 'd0;
else
	sum <= sum + din - data_reg[AVE_DATA_NUM-1]; //将最老的数据换为最新的输入数据
	
endmodule