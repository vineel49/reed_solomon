% convert decimal to binary - block length of 8 only
% written by Vineel Kumar Veludandi

function [output] = Con_Dec_bin8(input)

temp_array = zeros(8,length(input));

temp_array(1,:) = mod(input,2);
temp1 = floor(input/2);
temp_array(2,:) = mod(temp1,2);
temp2 = floor(temp1/2);
temp_array(3,:) = mod(temp2,2);
temp3 = floor(temp2/2);
temp_array(4,:) = mod(temp3,2);
temp4 = floor(temp3/2);
temp_array(5,:) = mod(temp4,2);
temp5 = floor(temp4/2);
temp_array(6,:) = mod(temp5,2);
temp6 = floor(temp5/2);
temp_array(7,:) = mod(temp6,2);
temp7 = floor(temp6/2);
temp_array(8,:) = mod(temp7,2);

temp_array = temp_array(end:-1:1,:);
output = transpose(temp_array(:));

end