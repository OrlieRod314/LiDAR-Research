
tic
csvfiles = dir('*.csv');
numfiles = length(csvfiles);
LiDAR = cell(1,numfiles);

for k = 1:numfiles
    LiDAR{k} = dlmread(csvfiles(k).name,',',1,3);
    toc
end

LiDARpc = cell2mat(LiDAR');

%% 
%grab all points associated with different lasers. 
degs = [9, 7, 5, 3, 1, -3, -5, -7, -9];
means = [0, 0, 0, 0, 0, 0, 0, 0, 0];
stds = [0, 0, 0, 0, 0, 0, 0, 0, 0];

for k = 1:length(degs)
    idx = find(LiDARpc(:, 10) == degs(k));
    
    temp = LiDARpc(idx,:); 
    means(k) = mean(temp(:,4));
    stds(k) = std(temp(:,4));
    
end