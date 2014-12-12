
global_config = {

configs = '127.0.0.1:54333',

apps = {


-- 下面是一个service配置，既有frontend也有backend。service的backend需要连接到所有cache.
{gid='S0',frontend={port='127.0.0.1:54360',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},
		
{gid='S1',frontend={port='127.0.0.1:54361',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},
		
{gid='S2',frontend={port='127.0.0.1:54362',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},
		
{gid='S3',frontend={port='127.0.0.1:54363',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},
		
{gid='S4',frontend={port='127.0.0.1:54364',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},
		
{gid='S5',frontend={port='127.0.0.1:54365',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},
		
{gid='S6',frontend={port='127.0.0.1:54366',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},
		
{gid='S7',frontend={port='127.0.0.1:54367',max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8},
		backend={max_connection=16,read_buffer=512*1024,write_buffer=512*1024,connect_all_lowlayer = 'yes'}},

-- 下面是一个gate配置，既有frontend也有backend。gate的backend连接到指定的app
{gid='G0',frontend={port='127.0.0.1:54388',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S0'}},
		
{gid='G1',frontend={port='127.0.0.1:54389',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S1'}},
		
{gid='G2',frontend={port='127.0.0.1:54390',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S2'}},
		
{gid='G3',frontend={port='127.0.0.1:54391',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S3'}},
		
{gid='G4',frontend={port='127.0.0.1:54392',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S4'}},
		
{gid='G5',frontend={port='127.0.0.1:54393',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S5'}},
		
{gid='G6',frontend={port='127.0.0.1:54394',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S6'}},
		
{gid='G7',frontend={port='127.0.0.1:54395',max_connection=10*1024,read_buffer=8*1024,write_buffer=8*1024},
		backend={max_connection=8,read_buffer=1024*1024*8,write_buffer=1024*1024*8,connect_destiny='S7'}},
		

}

}--global_config end


