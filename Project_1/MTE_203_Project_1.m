%MTE 203 Project 1
%Junze Cao
%20618673
%J56cao@edu.uwaterloo.ca

clear
warning('off','all')

%% Part 1
%1
%Plot surface
%Use symbolic where possible
syms x y
z(x,y) = 0.01*(3*x-1)^2*(2*y-1)^2*exp(-0.5*x^2-1/3*y^2) + 2;
figure
ezsurf(z,[-3 3 -3 3])
xlabel('x-axis(m)')
ylabel('y-axis(m)')
zlabel('z-axis(m)')
title('Terrain map')
h = colorbar;
ylabel(h, 'height(m)')

%2
%Plot contour
[X,Y] = meshgrid(linspace(-3,3,61));
Z = 0.01*(3*X-1).^2.*(2*Y-1).^2.*exp(-0.5*X.^2-1/3*Y.^2) + 2;
figure
%Use 8 contour levels
[c,h] = contour(X,Y,Z,8);
h.LevelList = round(h.LevelList,2);
clabel(c,h)
xlabel('x-axis(m)')
ylabel('y-axis(m)')
title('Contour plot');
h = colorbar;
ylabel(h, 'height(m)')

%3
%See the word document please

%4
f_x = simplify(diff(z,x));
f_y = simplify(diff(z,y));
f_x_x = simplify(diff(f_x,x));
f_y_y = simplify(diff(f_y,y));
f_x_y = simplify(diff(f_x,y));

S = solve([f_x == 0, f_y == 0],[x,y]);
%table = {'Point number','x','y','f(x,y)','A','B','C','D = B^2 - AC'};
table = [];
count = 1;
max_index = 0;
max_value = 0;
for i=1:length(S.x)
    if(abs(S.x(i))>3 || abs(S.y(i))>3)
        continue
    end
    table(count,1) = count;
    table(count,2) = S.x(i);
    table(count,3) = S.y(i);
    table(count,4) = subs(z,[x,y],[S.x(i),S.y(i)]);
    if(table(count,4) > max_value)
        max_index = count;
        max_value = table(count,4);
    end
    table(count,5) = subs(f_x_x,[x,y],[S.x(i),S.y(i)]);
    table(count,6) = subs(f_x_y,[x,y],[S.x(i),S.y(i)]);
    table(count,7) = subs(f_y_y,[x,y],[S.x(i),S.y(i)]);
    table(count,8) = table(count,6)^2 - table(count,5)*table(count,7);
    count = count+1;
end

%% Part 2
%1
radiation = 35 - exp(0.05*x - 0.1*y + z) - (0.1*z)^2;
radiation_highest_point = double(subs(radiation,[x,y,z],table(3,2:4)));
disp(radiation_highest_point)

%2
radiation_point = double(subs(radiation,[x,y,z],[2,-1,subs(z,[x,y],[2,-1])]));
disp(radiation_point)

%3
%Because the equation is based on a specific point, the variables are
%named differently, using _3 as a suffix
syms t_3
x_3(t_3) = t_3;
y_3(t_3) = t_3-3;
z_3(t_3) = 0.01*(3*x_3-1)^2*(2*y_3-1)^2*exp(-0.5*x_3^2-1/3*y_3^2) + 2;
radiation_3(t_3) = 35 - exp(0.05*x_3 - 0.1*y_3 + z_3) - (0.1*z_3)^2;
radiation_t_3 = diff(radiation_3,t_3);
figure
ezplot(radiation_3,[0 3]);
xlabel('x-axis(m)')
ylabel('Radiation(Sv/hr)')
title('Radiation along y=x-3 projected onto x-axis')
radiation_t_point_3 = double(subs(radiation_t_3,t_3,2));
disp(radiation_t_point_3)

%4
%C is the new colormap
C = 35 - exp(0.05*X - 0.1*Y + Z) - (0.1*Z).^2;
figure
surf(X,Y,Z,C)
xlabel('x-axis(m)')
ylabel('y-axis(m)')
zlabel('z-axis(m)')
title('Terrain map (colormap based on radiation levels)')
h = colorbar;
ylabel(h, 'radiation(Sv/hr)')

%5
%radiation is already a function of x and y only
G = radiation;
disp(G)
figure
ezsurf(G,[-3 3 -3 3])
xlabel('x-axis(m)')
ylabel('y-axis(m)')
zlabel('radiation(Sv/hr)')
title('Radiation level across terrain')
h = colorbar;
ylabel(h, 'radiation(Sv/hr)')

%6
%Now make z a sym instead of a symfum
clear x y z
syms x y z lamda
radiation(x,y,z) = 35 - exp(0.05*x - 0.1*y + z) - 0.01*z^2;
radiation = simplify(radiation);
L(x,y,z,lamda) = radiation - lamda*(-z + 0.01*(3*x-1)^2*(2*y-1)^2*exp(-0.5*x^2-1/3*y^2) + 2);
L = simplify(L);
L_dx = simplify(diff(L,x));
L_dy = simplify(diff(L,y));
L_dz = simplify(diff(L,z));
L_dlamda = vpa(simplify(diff(L,lamda)));

solution = fsolve(@vectorTransform,[-1.17 -1.68 0 0]);
disp(solution)
