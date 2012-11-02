function [ varargout ] = photometer( varargin )

%----   History
%   081223 rog wrote code fragement for later more generalized program...

%----   Extract arguments from input
for i = 1:nargin-1
    % Extract type, value pair
    param_type = varargin{i};
    switch param_type
        case {'open', 'close', 'read', 'readl', 'readln'}
            if isstruct( varargin{i+1} )
                params = varargin{i+1};
                params.curr_command = param_type;
            end
        otherwise
            disp(sprintf('[%s]: Improper input arguments.', mfilename ) );
            return;
    end
end