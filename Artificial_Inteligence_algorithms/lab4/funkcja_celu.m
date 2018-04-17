function out = funkcja_celu( in_x , in_y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

out = in_x.^2 + in_y.^2 - 20*(cos(pi*in_x) + cos(pi*in_y) -2 ) ; 
end

