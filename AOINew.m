% clear all
close all
% clc
% 
% 
% cd('D:\Orlando Work\AOI Experiment\AOI Experiment\Data')
% directory = dir;
names = ["Black 0 Degrees", "Black 30 Degrees", "Black 70 Degrees", "Retro-Reflective 0 Degrees", "Retro-Reflective 30 Degrees", "Retro-Reflective 70 Degrees", "White 0 Degrees", "White 30 Degrees", "White 70 Degrees"];
% tic
% numexp = length(directory);
% allData = cell(numexp-2,1);
% %
% %% Initial parameters
% degs = [-15, -13, -11, -9, -7, -5, -3, -1, 1, 3, 5, 7, 9, 11, 13, 15];
% means = zeros(numexp-2, length(degs)+1);
% means(:,1) = [0, 30, 70, 0, 30, 70, 0, 30, 70];
% stds = means;
% %
% 
% for kk = 3 : numexp
%     %% Change directory
%     cd(strcat('D:\Orlando Work\AOI Experiment\AOI Experiment\Data\',directory(kk).name));
%     %
%     %% Read in all CSV files as LiDARpc
%     csvfiles = dir('*.csv');
%     numfiles = length(csvfiles);
%     LiDAR = cell(1,numfiles);
%     for k = 1:numfiles
%         LiDAR{k} = dlmread(csvfiles(k).name,',',1,3);
%         toc
%     end
%     LiDARpc = cell2mat(LiDAR');
%     LiDARpc = LiDARpc(:,1:4);
%     LiDARpc(:,5:7) = 0;
%     [az,el,rng] = cart2sph(LiDARpc(:,1),LiDARpc(:,2),LiDARpc(:,3));
%     LiDARpc(:,5) = rad2deg(az);
%     LiDARpc(:,6) = rad2deg(el);
%     LiDARpc(:,7) = rng;
%     allData{kk - 2} = LiDARpc;
%     % end build LiDARpc
% end
%% First figure with 2 subplots
for kk = [1 4 7]
    %
    temp = allData{kk,1};
    for k = 1:length(degs)
        idx = find(temp(:, 6) == degs(k));
        subtemp = temp(idx,:);
        means(kk,k+1) = mean(subtemp(:,4));
        stds(kk,k+1) = std(subtemp(:,4));
    end
    %
    means(isnan(means(:,:))) = 1;
    stds(isnan(stds(:,:))) = 1;
    %
    cmap = colormap('jet'); % jet
    cmap = resample(cmap, round(max(means(kk,2:17))*1000), size(cmap, 1));
    cmap(cmap>1)=1;cmap(cmap<0)=0;
    %
    %
    figure
    
    for k = 2:length(means)
        idx = find(temp(:, 6) == degs(k-1));
        if isempty(idx)
            continue
        end
        subtemp = temp(idx,:);
        % subtemp(subtemp(:,6) == 1)=361;
        subplot(1, 2, 1);
        plot(subtemp(:,5),subtemp(:,6),'k.','Linewidth', 1,'Color',cmap(round(means(kk,k)*1000),:)) % az vs el
        hold on
        set(gca,'YLim',[-17 17]);
        ylabel('Beam Elevation (deg)','FontSize',10);
        xlabel('Azimuth (deg)','FontSize',10);
        subplot(1, 2, 2);
        plot(subtemp(1, 6),means(kk, k),'k.','MarkerSize', 15,'Color',cmap(round(means(kk,k)*1000),:)) % el vs int
        hold on
        set(gca,'XLim',[-17 17],'YLim',[min(means(kk,3:16))-5 max(means(kk,2:17)+5)]);
        ylabel('Intensity (0 - 255)','FontSize',10)
        xlabel('Beam Elevation (deg)','FontSize',10)
        title(names(kk));
    end
    %
end
for kk = [2 3 5 6 8 9]
    temp = allData{kk,1};
    for k = 1:length(degs)
        idx = find(temp(:, 6) == degs(k));
        subtemp = temp(idx,:);
        means(kk,k+1) = mean(subtemp(:,4));
        stds(kk,k+1) = std(subtemp(:,4));
    end
    %
    means(isnan(means(:,:))) = 1;
    stds(isnan(stds(:,:))) = 1;
end
%% Second figure
names = ["Black", "Black 30 Degrees", "Black 70 Degrees", "Retro-Reflective", "Retro-Reflective 30 Degrees", "Retro-Reflective 70 Degrees", "White", "White 30 Degrees", "White 70 Degrees"];

for kk = [1 4 7]
    figure
    plot(means(kk:kk+2,1),means(kk:kk+2,10),'b.','MarkerSize', 15); % AOI vs. int
    title(names(kk));
    ylabel('Intensity (0 - 255)','FontSize',10)
    xlabel('AOI (deg)','FontSize',10)
    set(gca,'XLim',[-5 75],'YLim',[min(means(kk:kk+2,10))-5 max(means(kk:kk+2,10)+5)]); 
end
%% Histograms
names = ["Black 0 Degrees", "Black 30 Degrees", "Black 70 Degrees", "Retro-Reflective 0 Degrees", "Retro-Reflective 30 Degrees", "Retro-Reflective 70 Degrees", "White 0 Degrees", "White 30 Degrees", "White 70 Degrees"];


for kk = 1:length(allData)
    temp = allData{kk,1};
    idx = find(temp(:, 6) == 1);
    subtemp = temp(idx,:);
    figure
    histogram(subtemp(:,4),'BinWidth',0.2)
    title(string(names(kk)));
%
end
    
