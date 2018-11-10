

close all
epsilon = 0.1; % critere d'arret
attenuation = 3; % pas du gradient 1/log(attenuation)

x = -300:2:300;
y = parabole(x);

figure('Name', 'recherche du minimum sur une parabole')
hold on;
plot(x,y);

%x0 = randi(250,1)
x0=250
xcurrent = x0 - 2*x0;
xprec = x0;

plot(x0,parabole(x0),'ok','MarkerSize',20);


while(abs(xprec - xcurrent) > epsilon)
    
    plot(xcurrent,parabole(xcurrent),'ob');
   
    xprec  = xcurrent;
    nu = 1/log(attenuation);
    attenuation = attenuation+1;
    xcurrent = xprec - nu*2*xprec;
    pause(1);
end
plot(xcurrent,parabole(xcurrent),'xr', 'MarkerSize',20);



