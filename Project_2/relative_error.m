function val = relative_error ( z )
%Calculates the relative error given a thickness value z

outer_volume = 0;
% If the length of H is not divisible by the thickness
% the upper limit is taken for the outer shell
% so more material is included, waiting for manual sand
limit = ceil((1-z)/z);
% The upper sum is taken, so more material is included
% waiting for manual sand
for i=0:z:limit*z
    % The equation of x in terms of y is
    % x = sqrt(y)
    % W=3, so the horizontal length of the faceplate at this specific
    % point is 3-2*(sqrt(y))
    length = 3-2*(sqrt(i));
    outer_volume = outer_volume + length*z*3;
end

inner_volume = 0;
% If the length of H is not divisible by the thickness
% the lower limit is taken for the inner shell
% so less material is excluded, waiting for manual sand
limit = floor(0.9/z);
% The lower sum is taken, so less material is excluded
% waiting for manual sand
for i=z:z:limit*z
    % The equation of x in terms of y is
    % x = sqrt(0.4*y)
    % W=2, so the horizontal length of the faceplate at this specific
    % point is 2-2*(sqrt(0.4*y))
    length = 2-2*(sqrt(0.4*i));
    inner_volume = inner_volume + length*z*2.9;
end

% The density of Titanium is 4506kg/m^3
mass = 4506*(outer_volume-inner_volume);
relative_error = (outer_volume-inner_volume-1.868)/1.868;

val = [mass z relative_error];