clear all
clc
freq_S11 = linspace(4e9,8e9,15);
freq_AR = linspace(4.5e9,7.5e9,90);
L=22e-3;
W=16e-3;
a=2e-3;
b=2.5e-3;
c=2e-3;
d=2e-3;
e=3.001e-3;
g=0.5e-3;
G=11e-3;
h=1e-3;
lf=1e-3;
m=2e-3;
n=8e-3;
p=1e-3;
s=8e-3;
t=5.5e-3;
wf=3e-3;
L1=L-lf;
Er=4.4;
tand=2e-2;

N1=2; %50;
N2=2; %10;
k=antenna.Rectangle('Length',W,'Width',L,'NumPoints',60);
%H ΜΙΚΡΟΤΑΙΝΙΑ :
h1=antenna.Rectangle('Length',wf,'Width',L1,'NumPoints',60,'Center',[-n-wf/2+W/2 ,-L/2+L1/2]);
h2=antenna.Rectangle('Length',(2*d+e),'Width',c,'NumPoints',60,'Center',[W/2-n-wf/2 ,-L/2+G+c/2]);

microstrip=h1+h2 
show(microstrip);

%TA ΟΡΘΟΓΩΝΙΑ ΤΟΥ GROUND:
g1=antenna.Rectangle('Length',W,'Width',G,'NumPoints',[N2 N1 N2 N1], ...
    'Center',[0 ,-L/2+G/2]);
g2=antenna.Rectangle('Length',(2*p +m),'Width',s,'NumPoints',[N2 N1 N2 N1], ...
    'Center',[+W/2-(p+m/2) , -L/2+G+s/2]);
slot_cut_cross=antenna.Rectangle('Length',e,'Width',a,'NumPoints',[N1 N2 N1 N2], ...
    'Center',[-n-wf/2+W/2 , -L/2+G-a/2]);
slot_cut_horiz=antenna.Rectangle('Length',b,'Width',g,'NumPoints',[N1 N2 N1 N2], ...
    'Center',[W/2-n-wf-b/2, -L/2+G-a+g/2]);
slot_cut_vertic=antenna.Rectangle('Length',m,'Width',t,'NumPoints',[N2 N1 N2 N1], ...
    'Center',[W/2-((2*p)+m)/2 , -L/2+G+(s-t)+t/2]);

ground=g1+g2-slot_cut_cross-slot_cut_horiz-slot_cut_vertic;

d1=dielectric('Name',"FR4",'EpsilonR',Er,'LossTangent',tand,'Thickness',h);

%Ant.V
compact_planar = pcbStack;
compact_planar.Name = 'Ant.V';
compact_planar.BoardThickness = h;
compact_planar.BoardShape = k;
compact_planar.Layers = {microstrip,d1,ground};
compact_planar.FeedLocations = [W/2-n-wf/2 , -L/2+wf+p , 1 ,3];
compact_planar.FeedDiameter = 1.5e-3;
figure(1)
show(compact_planar);
view(2);
title("Ant.V");
light; lighting gouraud; camlight;

%Ant.I
AntI=pcbStack;
AntI.Name='Ant.I';
AntI.BoardThickness=h;
AntI.BoardShape=k;
AntI.Layers={h1,d1,g1};
AntI.FeedLocations= [W/2-n-wf/2 , -L/2+wf+p , 1 ,3];
AntI.FeedDiameter = 1.5e-3;
figure(2)
show(AntI);
view(2);
title("Ant.I");
light; lighting gouraud; camlight;



%Ant.II
AntII=pcbStack;
AntII.Name='Ant.II';
AntII.BoardThickness=h;
AntII.BoardShape=k;
AntII.Layers={h1,d1,g1+g2};
AntII.FeedLocations= [W/2-n-wf/2 , -L/2+wf+p , 1 ,3];
AntII.FeedDiameter = 1.5e-3;
figure(3)
show(AntII)
view(2);
title("Ant.II")
light; lighting gouraud; camlight;

%AntIII
AntIII=pcbStack;
AntIII.Name='Ant.III';
AntIII.BoardThickness=h;
AntIII.BoardShape=k;
AntIII.Layers={h1,d1,g1+g2-slot_cut_horiz};
AntIII.FeedLocations= [W/2-n-wf/2 , -L/2+wf+p , 1 ,3];
AntIII.FeedDiameter = 1.5e-3;
figure(4)
show(AntIII);
view(2);
title("Ant.III");
light; lighting gouraud; camlight;

%Ant.IV

AntIV=pcbStack;
AntIV.Name='Ant.IV';
AntIV.BoardThickness=h;
AntIV.BoardShape=k;
AntIV.Layers={microstrip,d1,g1+g2-slot_cut_cross-slot_cut_horiz};
AntIV.FeedLocations= [W/2-n-wf/2 , -L/2+wf+p , 1 ,3];
AntIV.FeedDiameter = 1.5e-3;
figure(5)
show(AntIV)
view(2);
title("Ant.IV")
light; lighting gouraud; camlight;

figure(6)
current(compact_planar,6e9);

figure(7)

colors = {'r','g','b','c','k'};
mesh(AntI,"MaxEdgeLength",.0058,'MinEdgeLength',.0015,'GrowthRate',0.5);
mesh(AntII,"MaxEdgeLength",.0067,'MinEdgeLength',.0015,'GrowthRate',0.5)
mesh(AntIII,"MaxEdgeLength",.0067,'MinEdgeLength',.00025,'GrowthRate',0.5)
mesh(AntIV,"MaxEdgeLength",.005,'MinEdgeLength',.00025,'GrowthRate',0.5)
mesh(compact_planar,"MaxEdgeLength",.005,'MinEdgeLength',.00025,'GrowthRate',0.5)

s11Fig = figure(8);
hold on
for i=1:5
    i=3
    ant = {AntI,AntII,AntIII,AntIV,compact_planar};
    s = sparameters(ant{i},freq_S11);
    hi= rfplot(s,1,1);
    hi.Color = colors{i};
end
legend('Ant.I','Ant.II','Ant.III','Ant.IV','Ant.V')
xlabel('Frequency (GHz)');
ylabel('S_{11} (db)');
hold off

AxialRatioFig = figure(9);
hold on
for j=1:5
    axialRatio(ant{j},freq_AR,0,0);
    end
legend('Ant.I','Ant.II','Ant.III','Ant.IV','Ant.V')
xlabel('Frequency (GHz)');
ylabel('Axial Ratio (dB)');
hold off













