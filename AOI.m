clear all
close all
clc


cd('D:\Orlando Work\AOI Experiment\AOI Experiment\Data')
directory = dir;
tic
numexp = length(directory);
allData = cell(numexp,1);
%
%% Initial parameters
degs = [-15, -13, -11, -9, -7, -5, -3, -1, 1, 3, 5, 7, 9, 11, 13, 15];
means = zeros(numexp-2, length(degs)+1);
means(:,1) = [0, 30, 70, 0, 30, 70, 0, 30, 70];
stds = means;
%

for kk = 3 : numexp
    %% Change directory
    cd(strcat('D:\Orlando Work\AOI Experiment\AOI Experiment\Data\',directory(kk).name));
    %
    %% Read in all CSV files as LiDARpc
    csvfiles = dir('*.csv');
    numfiles = length(csvfiles);
    LiDAR = cell(1,numfiles);
    for k = 1:numfiles
        LiDAR{k} = dlmread(csvfiles(k).name,',',1,3);
        toc
    end
    LiDARpc = cell2mat(LiDAR');
    for a = 1:length(LiDARpc)
        while LiDARpc(a,6) > 360
            LiDARpc(a,6) = LiDARpc(a,6) - 360;
        end

    end
    allData{kk - 2} = LiDARpc;
    % end build LiDARpc
 %%
    for k = 1:length(degs)
        idx = find(LiDARpc(:, 10) == degs(k));
        temp = LiDARpc(idx,:);
        means(kk-2,k+1) = mean(temp(:,4));
        stds(kk-2,k+1) = std(temp(:,4));
    end
    %
     %%
    cmap = colormap('jet'); % jet
    cmap = resample(cmap, round(max(means(kk-2,:))*1000), size(cmap, 1));
    cmap(cmap>1)=1;cmap(cmap<0)=0;
    %
    %%
    figure
    subplot(1, 2, 1);
    hold on
    for k = 2:length(means)
        idx = find(LiDARpc(:, 10) == degs(k-1));
        temp = LiDARpc(idx,:);
        temp(temp(:,6) == 1)=361;
        plot(temp(:,6),temp(:,10),'k.','Linewidth', 1,'Color',cmap(round(means(kk-2,k)*1000),:))
        set(gca,'XLim',[355 365],'YLim',[-17 17]);
    end
    subplot(1, 2, 2);
    hold on
    for k = 2:length(means)
        idx = find(LiDARpc(:, 10) == degs(k-1));
        temp = LiDARpc(idx,:);
        plot(temp(:,10),means(kk-2, k),'k.','Linewidth', 1,'Color',cmap(round(means(kk-2,k)*1000),:))
        set(gca,'XLim',[-5 5],'YLim',[-3 3]);
    end
end