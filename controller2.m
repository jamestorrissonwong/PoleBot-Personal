% Author: James Wong

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

vertical = [0,0];
horizontal = [0,0];

PROTOCOL_VERSION            = 2.0;

DXL_ID                      = 6;
DXL_ID_2                    = 7;
DXL_ID_3                    = 9;
DXL_ID_4                    = 10;


BAUDRATE                    = 57600;
DEVICENAME                  = 'COM7';

TORQUE_ENABLE               = 1;
TORQUE_DISABLE              = 0;


COMM_SUCCESS                = 0;
COMM_TX_FAIL                = -1001;

port_num = portHandler(DEVICENAME);

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


if (setBaudRate(port_num, BAUDRATE))
    fprintf('Succeeded to change the baudrate!\n');3
else
    unloadlibrary(lib_name);
    fprintf('Failed to change the baudrate!\n');
    input('Press any key to terminate...\n');
    return;
end



for n = [6,7,9,10]
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 11, 1);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 10, 0);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
    
end


joy = vrjoystick(1);

isOn = 0;

while(isOn ~=1)
    isOn = button(joy, 10);
    
    
    rx = axis(joy, 3);
    ry = axis(joy, 4);
    lx = axis(joy, 1);
    ly = axis(joy, 2);
    
    
    
    if abs(rx) > 0.12
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 11, 1);
        
        if rx < 0
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 10, 1);
        elseif rx > 0
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 10, 0);
        end
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        
        checkPressed = axis(joy, 3)
        
        if abs(checkPressed) > 0.12
            while 1
                checkPressed = axis(joy, 3)
                
                if rx < 0
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 10, 1);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                    
                elseif rx > 0
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 10, 0);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                    
                end
                
                while abs(checkPressed) > 0.12
                    dxl_goal_velocity_3 = 40*abs(checkPressed);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_3);
                    
                    checkPressed = axis(joy, 3)
                    
                    if button(joy, 9) == 1
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                    if abs(checkPressed) <= 0.12
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                end
                
                if abs(checkPressed) <= 0.12
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, 0);
                    break;
                end
            end
            
        end
        
    end
    
    if abs(ry) > 0.12
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 11, 1);
        
        if ry < 0
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
        elseif ry > 0
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
        end
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        
        checkPressed = axis(joy, 4)
        
        if abs(checkPressed) > 0.12
            while 1
                checkPressed = axis(joy, 4)
                
                if ry < 0
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                    
                elseif ry > 0
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                    
                end
                
                while abs(checkPressed) > 0.12
                    dxl_goal_velocity_4 = 100*abs(checkPressed);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                    
                    checkPressed = axis(joy, 4)
                    
                    if button(joy, 9) == 1
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                    if abs(checkPressed) <= 0.12
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                end
                
                if abs(checkPressed) <= 0.12
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                    break;
                end
            end
            
            
        end
        
        
    end
    
    
    % Moves gripper to closed position conitunously
    if button(joy, 6) == 1
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 11, 1);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 10, 0);
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 11, 1);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 10, 1);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        checkPressed = button(joy, 6) == 1
        
        while checkPressed == 1
            dxl_goal_velocity = 100;
            dxl_goal_velocity_2 = 100;
            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
            
            dxl_present_current = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_CURRENT)
            dxl_present_current_2 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_CURRENT)
            
            checkPressed = button(joy, 6)
            
            if button(joy, 9) == 1
                break;
            end
            
            if checkPressed == 0
                dxl_goal_velocity = 0;
                dxl_goal_velocity_2 = 0;
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                break;
            end
            
        end
        
        
        
        % Moves gripper to open position conitunously
    elseif button(joy, 5) == 1
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 10, 1);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 11, 1);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 11, 1);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 10, 0);
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        checkPressed = button(joy, 5)
        
        while checkPressed == 1
            dxl_goal_velocity = 100;
            dxl_goal_velocity_2 = 100;
            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
            
            dxl_present_current = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_CURRENT)
            dxl_present_current_2 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_CURRENT)
            
            checkPressed = button(joy, 5)
            
            if button(joy, 9) == 1
                break;
            end
            
            if checkPressed == 0
                dxl_goal_velocity = 0;
                dxl_goal_velocity_2 = 0;
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                break;
            end
        end
    end
    
    if button(joy, 7) == 1
        
        for n = [6,7]
            write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 11, 3);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        end
        
        
        write4ByteTxRx(port_num, PROTOCOL_VERSION, 1, ADDR_PRO_GOAL_POSITION, vertical(1);
        write4ByteTxRx(port_num, PROTOCOL_VERSION, 2, ADDR_PRO_GOAL_POSITION, vertical(2);
    end
    
    
    if button(joy, 8) == 1
        for n = [6,7]
            write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 11, 3);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        end
        
        
        write4ByteTxRx(port_num, PROTOCOL_VERSION, 1, ADDR_PRO_GOAL_POSITION, horizontal(1);
        write4ByteTxRx(port_num, PROTOCOL_VERSION, 2, ADDR_PRO_GOAL_POSITION, horizontal(2);
    end
    
end



for n = [6,7,9,10]
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 11, 1);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 10, 0);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
    
end

closePort(port_num);

unloadlibrary(lib_name);

close all;
clear all;