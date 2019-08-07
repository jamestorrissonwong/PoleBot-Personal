Author: James Wong

%
% *********     Gamepad Control      *********
%
% Use Logitech gamepad for controlling servos, valid for 2 modules using 2
% controllers
% Available Dynamixel model on this example : All models using Protocol 2.0
% This example is designed for using a Dynamixel XH servos, and an USB2DYNAMIXEL.
% (Baudrate : 57600)
%

clear all;
clc;

lib_name = '';

if strcmp(computer, 'PCWIN')
    lib_name = 'dxl_x86_c';
elseif strcmp(computer, 'PCWIN64')
    lib_name = 'dxl_x64_c';
elseif strcmp(computer, 'GLNX86')
    lib_name = 'libdxl_x86_c';
elseif strcmp(computer, 'GLNXA64')
    lib_name = 'libdxl_x64_c';
elseif strcmp(computer, 'MACI64')
    lib_name = 'libdxl_mac_c';
end

% Load Libraries
if ~libisloaded(lib_name)
    [notfound, warnings] = loadlibrary(lib_name, 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h');
end


ADDR_PRO_TORQUE_ENABLE       = 64;         % Control table address is different in Dynamixel model
ADDR_PRO_VELOCITY_LIMIT      = 44;
ADDR_PRO_CURRENT_LIMIT       = 38;

ADDR_PRO_GOAL_POSITION       = 116;
ADDR_PRO_PRESENT_POSITION    = 132;

ADDR_PRO_GOAL_VELOCITY       = 104;
ADDR_PRO_GOAL_CURRENT        = 102;
ADDR_PRO_PRESENT_CURRENT     = 126;

PROTOCOL_VERSION            = 2.0;

DXL_ID                      = 1;
DXL_ID_2                    = 2;
DXL_ID_3                    = 3;
DXL_ID_4                    = 4;
DXL_ID_5                    = 5;
DXL_ID_6                    = 6;
DXL_ID_7                    = 7;
DXL_ID_9                    = 9;
DXL_ID_10                   = 10;

BAUDRATE                    = 57600;
DEVICENAME                  = 'COM5';
DEVICENAME_2                = 'COM7';


TORQUE_ENABLE               = 1;
TORQUE_DISABLE              = 0;


COMM_SUCCESS                = 0;
COMM_TX_FAIL                = -1001;

port_num = portHandler(DEVICENAME);
port_num2 = portHandler(DEVICENAME_2);

packetHandler();

dxl_comm_result = COMM_TX_FAIL;

dxl_error = 0;

if (openPort(port_num))
    fprintf('Succeeded to open the port!\n');
    
else
    unloadlibrary(lib_name);
    fprintf('Failed to open the port!\n');
    input('Press any key to terminate...\n');
    return;
end

if (openPort(port_num_2))
    fprintf('Succeeded to open the port!\n');
    
else
    unloadlibrary(lib_name);
    fprintf('Failed to open the port!\n');
    input('Press any key to terminate...\n');
    return;
end

if (setBaudRate(port_num, BAUDRATE))
    fprintf('Succeeded to change the baudrate!\n');
else
    unloadlibrary(lib_name);
    fprintf('Failed to change the baudrate!\n');
    input('Press any key to terminate...\n');
    return;
end

if (setBaudRate(port_num_2, BAUDRATE))
    fprintf('Succeeded to change the baudrate!\n');
else
    unloadlibrary(lib_name);
    fprintf('Failed to change the baudrate!\n');
    input('Press any key to terminate...\n');
    return;
end

for n = [1,2,3,4,5]
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 11, 1);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 10, 0);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
    
end

for n = [6,7,9,10]
    write1ByteTxRx(port_num_2, PROTOCOL_VERSION, n, 11, 1);
    write1ByteTxRx(port_num_2, PROTOCOL_VERSION, n, 10, 0);
    write1ByteTxRx(port_num_2, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
    
end

joy = vrjoystick(1);
joy2 = vrjoystick(2);

isOn = 0;

while(isOn ~=1)
    isOn = button(joy, 10);
    
    ry = axis(joy, 4);
    ry2 = axis(joy2, 4);
    
    if abs(ry) > 0.12
        
        checkPressed = ry
        
        while abs(checkPressed) > 0.12
            checkPressed = axis(joy, 4)
            
            if checkPressed < 0
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                
            elseif checkPressed > 0
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                
            end
            
            
            dxl_goal_velocity_4 = 100*abs(checkPressed);
            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
            
            
            
            if button(joy, 9) == 1
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                break;
            end
            
            if abs(checkPressed) <= 0.12
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                break;
            end
        end
    end
    
    if abs(ry2) > 0.12
        
        checkPressed = ry2
        
        while abs(checkPressed) > 0.12
            checkPressed = axis(joy2, 4)
            
            if checkPressed < 0
                write1ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                write1ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, 10, 1);
                write1ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                
            elseif checkPressed > 0
                write1ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                write1ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, 10, 0);
                write1ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                
            end
            
            
            dxl_goal_velocity_4 = 100*abs(checkPressed);
            write4ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
            
            
            
            if button(joy, 9) == 1
                write4ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, 0);
                break;
            end
            
            if abs(checkPressed) <= 0.12
                write4ByteTxRx(port_num_2, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, 0);
                break;
            end
        end
    end
end


for n = [1,2,3,4,5]
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 11, 1);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 10, 0);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
    
end

for n = [6,7,9,10]
    write1ByteTxRx(port_num_2, PROTOCOL_VERSION, n, 11, 1);
    write1ByteTxRx(port_num_2, PROTOCOL_VERSION, n, 10, 0);
    write1ByteTxRx(port_num_2, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
    
end

closePort(port_num);
closePort(port_num_2);

unloadlibrary(lib_name);

close all;
clear all;