# FPGA-Based-Design-for-DHT11-Temperature-and-Humidity-Detection
本项目是基于FPGA技术，实现DHT11温湿度检测技术设计的系统，在
Quartus II 13.0 开发环境中编写 Verilog语言实现系统软件搭建，包含了驱动数
码管显示、DHT11采集温湿度经过均值滤波处理后的数据并通过按键切换显
示、驱动蜂鸣器节奏发声、TFT_LCD屏幕显示字符，同时调用IP核输出驱动
TFT_LCD屏幕的特定工作时钟频率和比较器，将比较器设置的阈值和检测的环
境温湿度作比较实现报警和显示湿度过高或温度过高字符功能。
