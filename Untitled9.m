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
    fprintf('Succeeded to change the baudrate!\n');
else
    unloadlibrary(lib_name);
    fprintf('Failed to change the baudrate!\n');
    input('Press any key to terminate...\n');
    return;
end

for n = [1,2,3,4,5,6,7,9,10]
    
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 11, 3);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, 10, 0);
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
    
end

joy = vrjoystick(1);

isOn = 0;
currentState = 4;

limits1 = [0,4096];
limits2 = [0,4096];
limits3 = [0,4096];
limits5 = [0,4096];
limits6 = [0,4096];
limits7 = [0,4096];
limits10 = [0,4096];


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
        
    elseif button(joy, 4) == 1
        currentState = 4;
        
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
    
    if currentState == 4
        
        
        for n = [1,2,3,4,5,6,7,9,10]
            
            write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
            
        end
        
        if button(joy, 5) == 1
            
            limits1(1) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 1, ADDR_PRO_PRESENT_POSITION);
            limits2(1) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 2, ADDR_PRO_PRESENT_POSITION);
            
        elseif button(joy, 6) == 1
            
            limits6(1) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 6, ADDR_PRO_PRESENT_POSITION);
            limits7(1) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 7, ADDR_PRO_PRESENT_POSITION);
            
        elseif button(joy, 7) == 1
            
            limits1(2) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 1, ADDR_PRO_PRESENT_POSITION);
            limits2(2) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 2, ADDR_PRO_PRESENT_POSITION);
            
        elseif button(joy, 8) == 1
            
            limits6(2) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 6, ADDR_PRO_PRESENT_POSITION);
            limits7(2) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 7, ADDR_PRO_PRESENT_POSITION);
            
        elseif pov(joy, 1) < 45 && pov(joy, 1) > 315
            
            limits4(2) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 4, ADDR_PRO_PRESENT_POSITION);
            
        elseif pov(joy, 1) < 135 && pov(joy, 1) > 45
            
            limits9(2) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 9, ADDR_PRO_PRESENT_POSITION);
            
        elseif pov(joy, 1) < 225 && pov(joy, 1) > 135
            
            limits4(1) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 4, ADDR_PRO_PRESENT_POSITION);
            
        elseif pov(joy, 1) < 315 && pov(joy, 1) > 225
            
            limits9(1) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 9, ADDR_PRO_PRESENT_POSITION);
            
        elseif button(joy, 11) == 1
            
            limits5(1) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 5, ADDR_PRO_PRESENT_POSITION);
            
        elseif button(joy, 12) == 1
            
            limits5(2) = read4ByteTxRx(port_num, PROTOCOL_VERSION, 5, ADDR_PRO_PRESENT_POSITION);
            
        end
        
        
    else
        
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
            
            
            checkPressed = axis(joy, 1);
            
            if abs(checkPressed) > 0.12
                while 1
                    checkPressed = axis(joy, 1);
                    
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
                        
                        checkPressed = axis(joy, 1);
                        
                        if button(joy, 9) == 1
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, 0);
                            break;
                        end
                        
                        if abs(checkPressed) <= 0.12
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, 0);
                            break;
                        end
                        
                        pos = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_PRESENT_POSITION);
                        
                        if pos > limits5(2) || pos < limits5(1)
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, 0);
                            break;
                            
                        end
                        
                        dxl_goal_velocity_5 = 30*abs(checkPressed);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_5, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_5);
                        
                        
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
                
                checkPressed = axis(joy, 2);
                
                if abs(checkPressed) > 0.12
                    while 1
                        checkPressed = axis(joy, 2);
                        
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
                            dxl_goal_velocity_4 = 30*abs(checkPressed);
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                            
                            
                            checkPressed = axis(joy, 2);
                            
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
                
                checkPressed = axis(joy, 4);
                
                if abs(checkPressed) > 0.12
                    while 1
                        checkPressed = axis(joy, 4);
                        
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
                            dxl_goal_velocity_4 = 30*abs(checkPressed);
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                            write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_10, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                            
                            
                            checkPressed = axis(joy, 4);
                            
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
                
                checkPressed = button(joy, 6) == 1;
                
                dxl_goal_velocity = 40;
                dxl_goal_velocity_2 = 40;
                dxl_goal_velocity_6 = 40;
                dxl_goal_velocity_7 = 40;
                
                while checkPressed == 1
                    
                    pos = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
                    pos2 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_POSITION);
                    pos6 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_PRESENT_POSITION);
                    pos7 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_PRESENT_POSITION);
                    
                    if pos > limits1(2) || pos < limits1(1)
                        dxl_goal_velocity = 0;
                        
                    end
                    
                    if pos2 > limits2(2) || pos < limits2(1)
                        dxl_goal_velocity_2 = 0;
                        
                    end
                    
                    if pos6 > limits6(2) || pos < limits6(1)
                        dxl_goal_velocity_6 = 0;
                        
                    end
                    
                    if pos7 > limits7(2) || pos < limits7(1)
                        dxl_goal_velocity_7 = 0;
                        
                    end
                    
                    
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_6);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_7);
                    
                    
                    checkPressed = button(joy, 6);
                    
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
                
                checkPressed = button(joy, 5);
                
                dxl_goal_velocity = 40;
                dxl_goal_velocity_2 = 40;
                dxl_goal_velocity_6 = 40;
                dxl_goal_velocity_7 = 40;
                
                while checkPressed == 1
                    
    
                    checkPressed = button(joy, 5);
                    
                    if button(joy, 9) == 1
                        break;
                    end
                    
                    if checkPressed == 0
                        dxl_goal_velocity = 0;
                        dxl_goal_velocity_2 = 0;
                        dxl_goal_velocity_6 = 0;
                        dxl_goal_velocity_7 = 0;
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_6);
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_7);
                        break;
                    end
                    
                    pos = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
                    pos2 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_PRESENT_POSITION);
                    pos6 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_PRESENT_POSITION);
                    pos7 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_PRESENT_POSITION);
                    
                    if pos > limits1(2) || pos < limits1(1)
                        dxl_goal_velocity = 0;
                        
                    end
                    
                    if pos2 > limits2(2) || pos < limits2(1)
                        dxl_goal_velocity_2 = 0;
                        
                    end
                    
                    if pos6 > limits6(2) || pos < limits6(1)
                        dxl_goal_velocity_6 = 0;
                        
                    end
                    
                    if pos7 > limits7(2) || pos < limits7(1)
                        dxl_goal_velocity_7 = 0;
                        
                    end
                    
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_2);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_6, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_6);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_7, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_7);
                    
                end
                
            end
        end
        
        if currentState ==1 || currentState ==2
            
            if abs(rx) > 0.12
                
                checkPressed = rx;
                
                while abs(checkPressed) > 0.12
                    
                    if rx < 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 10, 1);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    elseif rx > 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, 10, 0);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    end
                    
                    
                    pos3 = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_PRESENT_POSITION);
                    checkPressed = axis(joy, 3);
                    
                    if button(joy, 9) == 1
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                    if pos3 > limits3(2) || pos3 < limits3(1)
                        write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, 0);
                        break;
                    end
                    
                end
                
                if abs(checkPressed) <= 0.12
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, 0);
                    break;
                end
                
                dxl_goal_velocity_3 = 40*abs(checkPressed);
                write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_3);
                
                
            end
            
            if abs(ry) > 0.12
                
                checkPressed = ry;
                
                while abs(checkPressed) > 0.12
                    checkPressed = axis(joy, 4);
                    
                    if ry < 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 1);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    elseif ry > 0
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, 10, 0);
                        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
                        
                    end
                    
                    dxl_goal_velocity_4 = 100*abs(checkPressed);
                    write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_PRO_GOAL_VELOCITY, dxl_goal_velocity_4);
                    
                    checkPressed = axis(joy, 4);
                    
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
            
            
        end
    end
end


for n = [1,2,3,4,5,6,7,9,10]
    write1ByteTxRx(port_num, PROTOCOL_VERSION, n, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
end
dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);

closePort(port_num);

unloadlibrary(lib_name);

close all;
clear all;
