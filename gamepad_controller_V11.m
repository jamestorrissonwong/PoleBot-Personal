% Author: James Wong

%
% *********     Gamepad Control      *********
%
% Use Logitech gamepad for controlling servos, valid for 2 modules
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
BAUDRATE                    = 57600;
DEVICENAME                  = 'COM5';


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

write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 11, 3);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 10, 0);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 11, 3);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 10, 0);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 11, 3);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 10, 0);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 11, 3);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, 11, 3);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, 10, 0);


write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);


joy = vrjoystick(1);

isOn = 0;
currentState = 1;


while(isOn ~=1)
    isOn = button(joy, 10);
    
    if button(joy, 1) == 1
        currentState = 1;
        DXL_ID                      = 1;
        DXL_ID_2                    = 2;
        DXL_ID_3                    = 3;
        DXL_ID_4                    = 4;
        DXL_ID_5                    = 5;
    elseif button(joy, 2) == 1
        currentState = 2;
        DXL_ID                      = 6;
        DXL_ID_2                    = 7;
        DXL_ID_3                    = 9;
        DXL_ID_4                    = 10;
        DXL_ID_5                    = 5;
        
        
    elseif button(joy, 3) == 1
        currentState = 3;
        DXL_ID                      = 1;
        DXL_ID_2                    = 2;
        DXL_ID_3                    = 3;
        DXL_ID_4                    = 4;
        DXL_ID_5                    = 5;
        
        DXL_ID_6                      = 6;
        DXL_ID_7                      = 7;
        DXL_ID_9                      = 9;
        DXL_ID_10                     = 10;
    end
    
    rx = axis(joy, 3);
    ry = axis(joy, 4);
    lx = axis(joy, 1);
    ly = axis(joy, 2);
    
    if abs(lx) > 0.12
        
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, 11, 1);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        if lx < 0
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, 10, 1);
        elseif lx > 0
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, 10, 0);
        end
        
        
        checkPressed = axis(joy, 1)
        
        if abs(checkPressed) > 0.12
            while 1
                checkPressed = axis(joy, 1)
                
                if lx < 0
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, 10, 1);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                    
                elseif lx > 0
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, 10, 0);
                    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                    
                end
                
                while abs(checkPressed) > 0.12
                    dxl_goal_velocity_5 = 100*abs(checkPressed);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_5);
                    
                    checkPressed = axis(joy, 1)
                    
                    if button(joy, 9) == 1
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                    if abs(checkPressed) <= 0.12
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                end
                
                if abs(checkPressed) <= 0.12
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, 0);
                    break;
                end
            end
            
        end
        
    end
    
    if currentState == 3
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_9, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
        
        if abs(ly) > 0.12
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 11, 1);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 11, 1);
            
            if ly < 0
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 0);
            elseif ly > 0
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 1);
            end
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            checkPressed = axis(joy, 2)
            
            if abs(checkPressed) > 0.12
                while 1
                    checkPressed = axis(joy, 2)
                    
                    if ly < 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                         write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 0);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    elseif ly > 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 1);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    end
                    
                    while abs(checkPressed) > 0.12
                        dxl_goal_velocity_4 = 100*abs(checkPressed);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                        
                        
                        checkPressed = axis(joy, 2)
                        
                        if button(joy, 9) == 1
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                            break;
                        end
                        
                        if abs(checkPressed) <= 0.12
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, 0);
                            
                            break;
                        end
                        
                    end
                    
                    if abs(checkPressed) <= 0.12
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                end
                
                
                
                
            end
            
            
            
        end
        
        if abs(ry) > 0.12
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 11, 1);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 11, 1);
            
            if ry < 0
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 1);
            elseif ry > 0
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 0);
            end
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            checkPressed = axis(joy, 4)
            
            if abs(checkPressed) > 0.12
                while 1
                    checkPressed = axis(joy, 4)
                    
                    if ry < 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 1);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    elseif ry > 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, 10, 0);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    end
                    
                    while abs(checkPressed) > 0.12
                        dxl_goal_velocity_4 = 100*abs(checkPressed);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                        
                        
                        checkPressed = axis(joy, 4)
                        
                        if button(joy, 9) == 1
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                            break;
                        end
                        
                        if abs(checkPressed) <= 0.12
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, 0);
                            
                            break;
                        end
                        
                    end
                    
                    if abs(checkPressed) <= 0.12
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, 0);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, 0);
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
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, 10, 0);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, 10, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            checkPressed = button(joy, 6) == 1
            
            while checkPressed == 1
                dxl_goal_velocity = 100;
                dxl_goal_velocity_2 = 100;
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                
                
                dxl_present_current = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_CURRENT)
                dxl_present_current_2 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_CURRENT)
                dxl_present_current_3 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_PRESENT_CURRENT)
                dxl_present_current_4 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_PRESENT_CURRENT)
                
                checkPressed = button(joy, 6)
                
                if button(joy, 9) == 1
                    break;
                end
                
                if checkPressed == 0
                    dxl_goal_velocity = 0;
                    dxl_goal_velocity_2 = 0;
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
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
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, 10, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, 10, 0);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            checkPressed = button(joy, 5)
            
            while checkPressed == 1
                dxl_goal_velocity = 100;
                dxl_goal_velocity_2 = 100;
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                
                dxl_present_current = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_CURRENT)
                dxl_present_current_2 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_CURRENT)
                dxl_present_current_3 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_PRESENT_CURRENT)
                dxl_present_current_4 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_PRESENT_CURRENT)
                
                checkPressed = button(joy, 5)
                
                if button(joy, 9) == 1
                    break;
                end
                
                if checkPressed == 0
                    dxl_goal_velocity = 0;
                    dxl_goal_velocity_2 = 0;
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                    break;
                end
                
            end
            
        end
    end
    
    
    
    
    if currentState ==1 || currentState ==2
        
        
        
        
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
        
        % Moves gripper to closed position
        if button(joy, 8) == 1
            
            isMoving = 0;
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 10, 0);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 10, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            
            while 1
                %checks current
                dxl_present_current = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_CURRENT)
                dxl_present_current_2 = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_CURRENT)
                
                % Read present position
                dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
                dxl_present_position_2 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_POSITION);
                dxl_present_position_3 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_PRESENT_POSITION);
                dxl_present_position_4 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_PRESENT_POSITION);
                
                
                
                if button(joy, 9) == 1
                    break;
                end
                
                if (dxl_present_current < 50 || dxl_present_current > 60000 ) && (dxl_present_current_2 < 50  || dxl_present_current_2 > 60000)
                    if isMoving == 0
                        isMoving = 1;
                        dxl_goal_velocity = 50;
                        dxl_goal_velocity_2 = 50;
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                    end
                else
                    dxl_goal_velocity = 0
                    dxl_goal_velocity_2 = 0
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                    break;
                end
                
            end
            
            
            % Moves gripper to open position
        elseif button(joy, 7) == 1
            
            lastVals = [-1];
            lastVals2 = [-1];
            isMoving = 0;
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, 10, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 11, 1);
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, 10, 0);
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
            
            while 1
                
                % Read present position
                dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
                dxl_present_position_2 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_POSITION);
                dxl_present_position_3 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_PRESENT_POSITION);
                dxl_present_position_4 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_PRESENT_POSITION);
                
                dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
                dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
                fprintf('%s\n', 'read');
                if dxl_comm_result ~= COMM_SUCCESS
                    fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
                elseif dxl_error ~= 0
                    fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
                end
                
                if button(joy, 9) == 1
                    break;
                end
                
                if length(lastVals) < 5
                    lastVals = [lastVals dxl_present_position]
                    
                    
                    dxl_goal_velocity = 50;
                    
                    
                else
                    lastVals = [lastVals(2:end) dxl_present_position]
                    
                    d1 = abs(lastVals(1)-lastVals(2))
                    d2 = abs(lastVals(2)-lastVals(3))
                    d3 = abs(lastVals(3)-lastVals(4))
                    d4 = abs(lastVals(4)-lastVals(5))
                    d5 = abs(lastVals(5)-lastVals(1))
                    
                    if d1 < 10 && d2 < 10 && d3 < 10 && d4 < 10 && d5 < 10
                        dxl_goal_velocity = 0;
                    else
                        if isMoving == 0
                            isMoving = 1
                            dxl_goal_velocity = 50;
                        end
                    end
                    
                end
                
                if length(lastVals2) < 5
                    lastVals2 = [lastVals2 dxl_present_position_2]
                    
                    
                    dxl_goal_velocity_2 = 50;
                    
                    
                else
                    lastVals = [lastVals(2:end) dxl_present_position]
                    
                    d1 = abs(lastVals(1)-lastVals(2))
                    d2 = abs(lastVals(2)-lastVals(3))
                    d3 = abs(lastVals(3)-lastVals(4))
                    d4 = abs(lastVals(4)-lastVals(5))
                    d5 = abs(lastVals(5)-lastVals(1))
                    
                    if d1 < 10 && d2 < 10 && d3 < 10 && d4 < 10 && d5 < 10
                        dxl_goal_velocity_2 = 0;
                    else
                        if isMoving == 0
                            isMoving = 1
                            dxl_goal_velocity_2 = 50;
                        end
                        
                    end
                end
                
                if dxl_goal_velocity == 0 && dxl_goal_velocity_2 == 0
                    break
                else
                    
                    dxl_goal_position_3 = dxl_present_position_3;
                    dxl_goal_position_4 = dxl_present_position_4;
                    
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_POSITION, dxl_goal_position_3);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_POSITION, dxl_goal_position_4);
                end
            end
            
            
            
            % Moves gripper to closed position conitunously
        elseif button(joy, 6) == 1
            
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
    end
end

write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);

closePort(port_num);

unloadlibrary(lib_name);

close all;
clear all;

