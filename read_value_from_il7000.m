function serialData = read_value_from_il7000( port_num )

%---    Initialize constants
DEFAULT_CONFIG  = '1200,n,8,1'; % for IL1700
PORT_NUMBER     = 1;
TIME_BW_OPEN    = .5;
TIMEOUT_SECS    = 2;

%----   Argument checking
if nargin ~= 1 || isempty( port_num )
    port_num = PORT_NUMBER;
end

%----   Try to open, close port
% try
%     SerialComm('open', port_num, DEFAULT_CONFIG );
%     SerialComm('close', port_num);
%     WaitSecs( TIME_BW_OPEN );
% catch
%     rethrow( lasterr );
% end

%----   If successful, then reopen and get data
try
    %----   Open port then wait to read
    SerialComm('open', port_num, DEFAULT_CONFIG );
    WaitSecs( TIME_BW_OPEN );

    %----   Read line from serial port
    serialData = SerialComm('readl', port_num );
    
    %----   If no data yet, loop until data read or time out
    start_secs = GetSecs;
    while isempty( serialData )
        if ( start_secs + TIMEOUT_SECS ) < GetSecs
            fprint('Timed out\n');
            break;
        else
            serialData = serialComm('readl', portNumber );
        end
    end

    %----   Close port
    SerialComm('close', port_num );
    
    
    %----   If read value, convert to double
    if ~isempty( serialData )
        serialValue = str2double( serialData );
    end

catch
    SerialComm('close', port_num );
    rethrow( lasterr );
end

return

%--------------------------------------------------------------------------


