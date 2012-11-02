function params = get_photometer_params( varargin )

%----   Initialize output
params = [];

% Extract if nested cell (HACK)
if length( varargin ) == 1 && iscell( varargin )
    args = varargin{1};
else
    args = varargin;
end
nargs = length( args );

%----   Defaults
SCALE_FACTOR    = 16;
SECS_BW_SAMPLES = 1;
FONT_SIZE       = 24;
TEXT_STYLE      = 1; % bold
MANUAL_ADVANCE  = 0;
DISPLAY_VALUE   = 1;
PHOTOMETER      = 'il1700';
SHOW_PATCHES    = 1;

%----   If nargs > 1 then extract
if nargs > 1
    %----   Loop to extract args from input
    for i = 1:nargs-1
        param_type = lower( args{i} );
        param_val  = lower( args{i+1} );
        switch param_type
            case 'photometer'
                params.photometer = param_val;
            case 'scale_factor'
                if ~isnumeric( param_val )
                    param_val = str2double( param_val );
                end
                params.scale_factor = param_val;
            case 'secs_bw_samples'
                if ~isnumeric( param_val )
                    param_val = str2double( param_val );
                end
                params.secs_bw_samples = param_val;
            case 'font_size'
                if ~isnumeric( param_val )
                    param_val = str2double( param_val );
                end
                params.font_size = param_val;
            case 'text_style'
                if ~isnumeric( param_val )
                    param_val = str2double( param_val );
                end
                params.text_style = param_val;
            case 'manual_advance'
                if ~isnumeric( param_val )
                    param_val = str2double( param_val );
                end
                params.manual_advance = param_val;
            case 'display_value'
                if ~isnumeric( param_val )
                    param_val = str2double( param_val );
                end
                params.display_value = param_val;
            case 'show_patches'
                if ~isnumeric( param_val )
                    param_val = str2double( param_val );
                end
                params.show_patches = param_val;
            otherwise
                disp(sprintf('[%s]: Error in parameter values. One or more skipped.', mfilename) );
                break;
        end % switch
    end % for
end

%----   Now, make sure values are assigned for all critical parameters
if ~isfield( params, 'photometer' ) || isempty( params.photometer )
    params.photometer = PHOTOMETER;
end

if ~isfield( params,'scale_factor' ) || isempty( params.scale_factor )
    params.scale_factor = SCALE_FACTOR;
end

if ~isfield( params, 'secs_bw_samples' ) || isempty( params.secs_bw_samples )
    params.secs_bw_samples = SECS_BW_SAMPLES;
end

if ~isfield( params,'secs_bw_samples' ) || isempty( params.secs_bw_samples )
    params.secs_bw_samples = SECS_BW_SAMPLES;
end

if ~isfield( params, 'font_size' ) || isempty( params.font_size )
    params.font_size = FONT_SIZE;
end

if ~isfield( params,'text_style' ) || isempty( params.text_style )
    params.text_style = TEXT_STYLE;
end

if ~isfield( params, 'manual_advance' ) || isempty( params.manual_advance )
    params.manual_advance = MANUAL_ADVANCE;
end

if ~isfield( params,'display_value' ) || isempty( params.display_value )
    params.display_value = DISPLAY_VALUE;
end

if ~isfield( params, 'show_patches' ) || isempty( params.show_patches )
    params.show_patches = SHOW_PATCHES;
end

%----   Determine computer platform
comp = lower( computer() );
params.comp = comp(1:3);

return
%--------------------------------------------------------------------------
