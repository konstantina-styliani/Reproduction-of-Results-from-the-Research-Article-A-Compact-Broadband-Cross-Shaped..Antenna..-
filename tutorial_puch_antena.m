clear all
clc
L=26e-3
W=35.5e-3;
Uy1=19.5e-3;
Ux1=12e-3;
Ua1=2.1e-3;
Ud1=4.8e-3;
d=13.5e-3;
h=6e-3;

N1=2; %50;
N2=2; %10;
s=antenna.Rectangle('Length',W,'Width',L,'NumPoints',60);
h1=antenna.Rectangle('Length',Ua1,'Width',Uy1,'NumPoints',[N2 N1 N2 N1], ...
    'Center',[-Ux1/2 + Ua1/2 , -L/2 + Ud1 + Uy1/2]);
h2=antenna.Rectangle('Length',Ua1,'Width',Uy1,'NumPoints',[N2 N1 N2 N1], ...
    'Center',[-Ua1/2 + Ux1/2 , -L/2 + Ud1 + Uy1/2]);
h3=antenna.Rectangle('Length',Ux1,'Width',Ua1 ,'NumPoints',[N1 N2 N1 N2], ...
    'Center',[0,-L/2 + Ud1 + Ua1/2]);

Uslot=s-h1-h2-h3
figure
show(Uslot)

Lgp = 71e-3;
Wgp = 52e-3;
p2 = antenna.Rectangle('Length',Lgp,'Width',Wgp);

d1 = dielectric("Air");
slotPatch = pcbStack;
slotPatch.Name = 'U-Slot Patch';
slotPatch.BoardThickness = h;
slotPatch.BoardShape = p2;
slotPatch.Layers = {Uslot,d1,p2};
slotPatch.FeedDiameter = 0.9e-3;
slotPatch.FeedLocations=[0 ,L/2-d ,1 ,3]
show(slotPatch)

figure
mesh(slotPatch,'MaxEdgeLength',.0025,'MinEdgeLength',.001,'GrowthRate',0.7)

freq=linspace(3e9,6e9,200);
s1=sparameters(slotPatch,freq);
s11Fig=figure;
rfplot(s1,1,1)
s11Ax=gca(s11Fig);
hold(s11Ax,'on');

figure
%pattern(slotPatch,3.9e9)
