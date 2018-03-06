function p = optionhist(varargin)
%OPTIONHIST Generates a two-mode histogram interactively.
%   P = MANUALHIST generates a two-mode histogram using
%   TWOMODEGAUSS(m1, sig1, m2, sig2, A1, A2, k).  m1 and m2 are the
%   means of the two modes and must be in the range [0,1].  sig1 and
%   sig2 are the standard deviations of the two modes.  A1 and A2 are
%   amplitude values, and k is an offset value that raised the
%   "floor" of histogram.  The number of elements in the histogram
%   vector P is 256 and sum(P) is normalized to 1.  MANUALHIST
%   returns the last histogram computed.
%
%   A good set of starting values is: (0.15, 0.05, 0.75, 0.05, 1,
%   0.07, 0.002).

%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.7 $  $Date: 2003/10/13 00:49:57 $


if length(varargin) == 0    % If only one argument it must be p
    % Compute a default histogram in case the user quits before
    % estimating at least one histogram.
    p = twomodegauss(0.15, 0.05, 0.75, 0.05, 1, 0.07, 0.002);
elseif length(varargin) == 7
    m1 = varargin{1};
    sig1 = varargin{2};
    m2 = varargin{3};
    sig2 = varargin{4};
    A1 = varargin{5};
    A2 = varargin{6};
    k = varargin{7};
    % Convert the input string to a vector of numerical values and
    p = twomodegauss(m1, sig1, m2, sig2, A1, A2, k);
else
    error('Incorrect number of inputs');
end



