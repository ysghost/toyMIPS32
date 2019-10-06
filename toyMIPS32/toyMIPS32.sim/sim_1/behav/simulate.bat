@echo off
set xv_path=D:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim OpenMIPS_min_sopc_tb_behav -key {Behavioral:sim_1:Functional:OpenMIPS_min_sopc_tb} -tclbatch OpenMIPS_min_sopc_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
