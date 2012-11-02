function [ cd, clut_index ] = measure_monitor_gamma( varargin )
% measure_monitor_gamma -- measures cd/m^2 for monitor
%
% [ cd, clut_index ] = measure_monitor_gamma( )

%----   Dependencies
%
%       Macintosh:
%           Calls SerialComm.m, included in Psychophysics Toolbox.  In most cases,
%           a USB/Serial hardware converter and the appropriate drive will be
%           required.  The Keyspan Serial Port (www.keyspan.com) works.
%
%       PC/Win
%           Calls the Matlab built-in serial.m routine.
%           Requires serial struct of format:
%           s = serial('COM1', 'BaudRate', 1200, 'Parity', 8, 'StopBit',
%           'n');


%----   History
%   070608 rog wrote.
%   081223 rog modified documentation.  Need to add user specified inputs

%----   Defaults
SCALE_FACTOR    = 16;
SECS_BW_SAMPLES = 1;
FONT_SIZE       = 24;
TEXT_STYLE      = 1; % bold
MANUAL_ADVANCE  = 0;
DISPLAY_VALUE   = 1;
PHOTOMETER      = 'il1700';

%----   Initialize outputs
cd          = zeros(SCALE_FACTOR,1);
clut_index  = zeros( SCALE_FACTOR, 1 );

%----   Get parameter values from varargin
params = getParams( varargin );

%----   Open photometer
[ photometer_status, photometer_error ] = il1700('open');
if photometer_status
    fprintf( photometer_error );
    fprintf('/n');
    return;
else
    %----   Close photometer
    [ photometer_status, photometer_error ] = il1700('close');
    if photometer_status
        fprintf( photometer_error );
        fprintf('/n');
        return;
    end

    %----   Try/catch block for screen commands
    try
        %----   Open Screen
        AssertOpenGL;
        screens=Screen('Screens');
        screenNumber=max(screens);

        % Find the color values which correspond to white and black.
        white=WhiteIndex(screenNumber);
        black=BlackIndex(screenNumber);
        gray=(white+black)/2;
        if round(gray)==white
            gray=black;
        end

        %----   Generate clut indices
        clut_index  = linspace( black, white, SCALE_FACTOR )';

        %----   Open window with black color
        w=Screen('OpenWindow',screenNumber, 0,[],32,2);
        Screen('FillRect',w, black);
        Screen('TextFont', w, 'Courier New');
        Screen('TextSize', w, FONT_SIZE);
        Screen('TextStyle', w, TEXT_STYLE );
        Screen('Flip', w);

        %-----  Provide user instructions and start calibration
        Screen('DrawText', w, 'Attach detector flush to screen. Hit any key to begin', 10, 100, white );
        Screen('Flip', w);
        KbWait;
        while KbCheck; end;

        %----   Loop on clut index, measure luminance
        for m = 1:SCALE_FACTOR

            %----   Fill window with current gray scale value
            curr_gray = clut_index( m );

            %----   Write gray value to screen
            Screen('FillRect', w, curr_gray);
            curr_contr_diff = curr_gray - gray;
            if curr_contr_diff < 0
                text_color = white;
            else
                text_color = black;
            end

            Screen('DrawText', w, [ 'Gray value = ' num2str( curr_gray ) ], 100, 100, text_color );
            Screen('Flip', w);

            %----   Wait for screen to change and photometer to settle
            [ photometer_status, photometer_error ] = il1700('open');
            if photometer_status
                fprintf( photometer_error );
                fprintf('/n');
                break;
            end

            %----   If manual advance mode, hit key to capture value
            if MANUAL_ADVANCE
                Screen('DrawText', w, 'Hit key to capture reading.', 100, 200, text_color );
                Screen('Flip', w);
                KbWait;
                while KbCheck; end;
            else
                WaitSecs( SECS_BW_SAMPLES );
            end

            %----   Get luminance value
            [ photometer_status, photometer_error, value ] = il1700('readline');
            if photometer_status
                fprintf( photometer_error );
                fprintf('/n');
                break;
            else
                cd(m) = value;
            end % if photometer_status

            if DISPLAY_VALUE
                Screen('DrawText', w, [ 'Lum (cd/m2) = ' num2str( value ) ], 100, 300, text_color );
                Screen('Flip', w);
                WaitSecs(1);
            end

            %----   Close connection
            [ photometer_status, photometer_error ] = il1700('close');
            if photometer_status
                fprintf( photometer_error );
                fprintf('/n');
                break;
            end

        end % for m

        %----   Clear screen
        Screen('CloseAll');

    catch
        il1700('close');
        rethrow( lasterror );
        Screen('CloseAll');
    end % try/catch

end % if photometer_status


%--------------------------------------------------------------------------
function params = getParams( varargin )

%----   Initialize output
params = [];

%----   If nargs < 2, skip extraction
nargs = nargin;
if nargs < 2
    return;
end

%----   Loop to extract args from input
for i = 1:nargs-1
    param_type = lower( varargin{i} );
    param_val  = lower( varargin{i+1} );
    switch param_type
        case 'photometer'
            params.photometer = param_val;
        case 'scale_factor'
            if isnumeric( str2double( param_val ) )
                params.scale_factor = str2double( param_val );
            end
        case 'secs_bw_samples'
            if isnumeric( str2double( param_val ) )
                params.secs_bw_samples = str2double( param_val );
            end
        case 'font_size'
            if isnumeric( str2double( param_val ) )
                params.font_size = str2double( param_val );
            end
        case 'text_style'
            if isnumeric( str2double( param_val ) )
                params.text_style = str2double( param_val );
            end
        case 'manual_advance'
            if isnumeric( str2double( param_val ) )
                params.manual_advance = str2double( param_val );
            end
        case 'display_value'
            if isnumeric(str2double( param_val ) )
                params.display_value = str2double( param_val );
            end
        case 'show_patches'
            if isnumeric(str2double( param_val ) )
                params.show_patches = str2doubl( params_val );
            end
        otherwise
            disp(sprintf('[%s]: Error in parameter values. One or more skipped.', mfilename) );
            break;
    end % switch
end % for

return
%--------------------------------------------------------------------------
