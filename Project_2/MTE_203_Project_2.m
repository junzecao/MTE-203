clear all

count = 1;
% Start from 0.0005m (0.5mm), increment by 0.0005 (0.5mm), and go to 0.01m (1cm)
for i=0.0005:0.0005:0.01
    val(count,:) = relative_error(i);
    count = count+1;
end
