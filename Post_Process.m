maindir = dir();
mainpath = maindir(6).folder;
for j = 6:9 
cd(strcat(mainpath,'\',maindir(j).name));
run('LiDARcsv2matlab.m')
display(maindir(j).name)
mean(LiDAR(:,4))
std(LiDAR(:,4))
figure
plot3(LiDAR(1:1000,1),LiDAR(1:1000,2),LiDAR(1:1000,3),'r.')
axis equal
figure
subplot(1,2,1)
histogram(LiDAR(:,4))
subplot(1,2,2)
qqplot(LiDAR(:,4))
clear LiDAR
end


