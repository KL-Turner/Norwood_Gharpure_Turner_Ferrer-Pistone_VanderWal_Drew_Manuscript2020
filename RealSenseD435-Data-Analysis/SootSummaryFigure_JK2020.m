function [] = SootSummaryFigure_JK2020(AnalysisResults)
%________________________________________________________________________________________________________________________
% Written by Kevin L. Turner
% The Pennsylvania State University, Dept. of Biomedical Engineering
% https://github.com/KL-Turner
%________________________________________________________________________________________________________________________
%
% Purpose: create a summary figure showing differences in rearing and distance traveled between treatment conditions
%________________________________________________________________________________________________________________________

%% get file animal treament information
sootDataFile = 'SootExperimentDataSheet.xlsx';
[~,~,allData] = xlsread(sootDataFile);
animalIDs = allData(2:end,1);
colorA = [(51/256),(160/256),(44/256)];   % H2O color
colorB = [(192/256),(0/256),(256/256)];   % Soot2040 color
colorC = [(255/256),(140/256),(0/256)];   % Soot2040F color
%% extract relevant data from results structure
rearingEvents = cell(length(animalIDs),1);
distanceTraveled = cell(length(animalIDs),1);
distancePath = cell(length(animalIDs),1);
for aa = 1:size(animalIDs)
    rearingEvents{aa,1} = AnalysisResults.(animalID).Rearing.rearingEvents;
    rearingTime{aa,1} = AnalysisResults.(animalID).Rearing.rearingTime;
    distanceTraveled{aa,1} = AnalysisResults.(animalID).Distance.distanceTraveled;
    distancePath{aa,1} = AnalysisResults.(animalID).Distance.distancePath;
end
%% separate data by each condition
cc1 = 1; cc2 = 1; cc3 = 1;
for bb = 2:size(allData,1)
    if strcmp(allData{bb,4},'H2O') == true
        waterRearingEvents(cc1,1) = rearingEvents{bb,1};
        waterRearingTime(cc1,1) = rearingTime{bb,1};
        waterDistance(cc1,1) = distanceTraveled{bb,1};
        waterDistancePath{cc1,1} = distancePath{bb,1}; 
        waterSex{cc1,1} = allData{bb,3};
        cc1 = cc1 + 1 ;
    elseif strcmp(allData{bb,4},'Soot2040') == true
        sootRearingEvents(cc2,1) = rearingEvents{bb,1};
        sootRearingTime(cc2,1) = rearingTime{bb,1};
        sootDistance(cc2,1) = distanceTraveled{bb,1};
        sootDistancePath{cc2,1} = distancePath{bb,1}; 
        sootSex{cc2,1} = allData{bb,3};
        cc2 = cc2 + 1;
    elseif strcmp(allData{bb,4},'Soot2040F') == true
        funcSootRearingEvents(cc3,1) = rearingEvents{bb,1};
        funcSootRearingTime(cc3,1) = rearingTime{bb,1};
        funcSootDistance(cc3,1) = distanceTraveled{bb,1};
        funcSootDistancePath{cc3,1} = distancePath{bb,1}; 
        funcSootSex{cc3,1} = allData{bb,3};
        cc3 = cc3 + 1;
    end
end
%% calculate mean and standard error
% water control
waterRearingEvents_mean = mean(waterRearingEvents);
waterRearingEvents_StErr = std(waterRearingEvents)/sqrt(length(waterRearingEvents));
waterRearingTime_mean = mean(waterRearingTime);
waterRearingTime_StErr = std(waterRearingTime)/sqrt(length(waterRearingTime));
waterDistance_mean = mean(waterDistance);
waterDistance_StErr = std(waterDistance)/sqrt(length(waterDistance));
waterDistancePath_mean = mean(cell2mat(waterDistancePath),1);
waterXinds = ones(length(waterRearingEvents),1);
% soot
sootRearingEvents_mean = mean(sootRearingEvents);
sootRearingEvents_StErr = std(sootRearingEvents)/sqrt(length(sootRearingEvents));
sootRearingTime_mean = mean(sootRearingTime);
sootRearingTime_StErr = std(sootRearingTime)/sqrt(length(sootRearingTime));
sootDistance_mean = mean(sootDistance);
sootDistance_StErr = std(sootDistance)/sqrt(length(sootDistance));
sootDistancePath_mean = mean(cell2mat(sootDistancePath),1);
sootXinds = ones(length(sootRearingEvents),1);
% functionalized soot
funcSootRearingEvents_mean = mean(funcSootRearingEvents);
funcSootRearingEvents_StErr = std(funcSootRearingEvents)/sqrt(length(funcSootRearingEvents));
funcSootRearingTime_mean = mean(funcSootRearingTime);
funcSootRearingTime_StErr = std(funcSootRearingTime)/sqrt(length(funcSootRearingTime));
funcSootDistance_mean = mean(funcSootDistance);
funcSootDistance_StErr = std(funcSootDistance)/sqrt(length(funcSootDistance));
funcSootDistancePath_mean = mean(cell2mat(funcSootDistancePath),1);
funcSootXinds = ones(length(funcSootRearingEvents),1);
%% summary figure
% rearing events
figure;
subplot(1,2,1);
for dd = 1:length(waterRearingEvents)
    if strcmp(waterSex{dd,1},'Male') == true
        scatter(waterXinds(dd,1).*1,waterRearingEvents(dd,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorA,'jitter','on','jitterAmount',0.25);
    elseif strcmp(waterSex{dd,1},'Female') == true
        scatter(waterXinds(dd,1).*1,waterRearingEvents(dd,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorA,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e1 = errorbar(1,waterRearingEvents_mean,waterRearingEvents_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorA);
e1.Color = 'black';
for ee = 1:length(sootRearingEvents)
    if strcmp(sootSex{ee,1},'Male') == true
        scatter(sootXinds(ee,1).*2,sootRearingEvents(ee,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
    elseif strcmp(sootSex{ee,1},'Female') == true
        scatter(sootXinds(ee,1).*2,sootRearingEvents(ee,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e2 = errorbar(2,sootRearingEvents_mean,sootRearingEvents_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorB);
e2.Color = 'black';
for ff = 1:length(funcSootRearingEvents)
    if strcmp(funcSootSex{ff,1},'Male') == true
        scatter(funcSootXinds(ff,1).*3,funcSootRearingEvents(ff,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
    elseif strcmp(funcSootSex{ff,1},'Female') == true
        scatter(funcSootXinds(ff,1).*3,funcSootRearingEvents(ff,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e3 = errorbar(3,funcSootRearingEvents_mean,funcSootRearingEvents_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorC);
e3.Color = 'black';
maleScatter = scatter(0,NaN,'s','MarkerEdgeColor','k','MarkerFaceColor','w');
femaleScatter = scatter(0,NaN,'c','MarkerEdgeColor','k','MarkerFaceColor','w');
axis square
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'box','off')
xlim([0,4])
ylabel('Linked rearing events')
ylim([0,350])
legend([e1,e2,e3,maleScatter,femaleScatter],'H2O','Soot2040','Soot2040F','Male','Female')
% rearing time
subplot(1,2,2);
for gg = 1:length(waterRearingTime)
    if strcmp(waterSex{gg,1},'Male') == true
        scatter(waterXinds(gg,1).*1,waterRearingTime(gg,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorA,'jitter','on','jitterAmount',0.25);
    elseif strcmp(waterSex{gg,1},'Female') == true
        scatter(waterXinds(gg,1).*1,waterRearingTime(gg,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorA,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e1 = errorbar(1,waterRearingTime_mean,waterRearingTime_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorA);
e1.Color = 'black';
for hh = 1:length(sootRearingTime)
    if strcmp(sootSex{hh,1},'Male') == true
        scatter(sootXinds(hh,1).*2,sootRearingTime(hh,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
    elseif strcmp(sootSex{hh,1},'Female') == true
        scatter(sootXinds(hh,1).*2,sootRearingTime(hh,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e2 = errorbar(2,sootRearingTime_mean,sootRearingTime_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorB);
e2.Color = 'black';
for ii = 1:length(funcSootRearingTime)
    if strcmp(funcSootSex{ii,1},'Male') == true
        scatter(funcSootXinds(ii,1).*3,funcSootRearingTime(ii,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
    elseif strcmp(funcSootSex{ii,1},'Female') == true
        scatter(funcSootXinds(ii,1).*3,funcSootRearingTime(ii,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e3 = errorbar(3,funcSootRearingTime_mean,funcSootRearingTime_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorC);
e3.Color = 'black';
maleScatter = scatter(0,NaN,'s','MarkerEdgeColor','k','MarkerFaceColor','w');
femaleScatter = scatter(0,NaN,'c','MarkerEdgeColor','k','MarkerFaceColor','w');
axis square
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'box','off')
xlim([0,4])
ylabel('Linked rearing events')
ylim([0,350])
legend([e1,e2,e3,maleScatter,femaleScatter],'H2O','Soot2040','Soot2040F','Male','Female')
%% summary figure
% distance traveled
samplingRate = 15;   % Hz
duration = 20*60*samplingRate;   % min*sec
timeVec = (1:duration)/samplingRate;
figure;
subplot(1,2,1);
% H2O control
for jj = 1:size(waterDistancePath,2)
    plot(timeVec,waterDistancePath{jj,1},'color',colorA,'LineWidth',0.5)
    hold on
end
% Soot2040
for kk = 1:size(waterDistancePath,2)
    plot(timeVec,waterDistancePath{kk,1},'color',colorB,'LineWidth',0.5)
    hold on
end
% Soot2040F
for ll = 1:size(waterDistancePath,2)
    plot(timeVec,waterDistancePath{ll,1},'color',colorC,'LineWidth',0.5)
    hold on
end
% Means
p1 = plot(timeVec,waterDistancePath_mean,'color',colorA,'LineWidth',2);
p2 = plot(timeVec,sootDistancePath_mean,'color',colorB,'LineWidth',2);
p3 = plot(timeVec,funcSootDistancePath_mean,'color',colorC,'LineWidth',2);
axis square
set(gca,'box','off')
xlabel('Time (s)')
ylabel('Distance traveled (m)')
legend([p1,p2,p3],'H2O','Soot2040','Soot2040F')
% distance path
subplot(1,2,2);
for dd = 1:length(waterDistance)
    if strcmp(waterSex{dd,1},'Male') == true
        scatter(waterXinds(dd,1).*1,waterDistance(dd,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorA,'jitter','on','jitterAmount',0.25);
    elseif strcmp(waterSex{dd,1},'Female') == true
        scatter(waterXinds(dd,1).*1,waterDistance(dd,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorA,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e1 = errorbar(1,waterDistance_mean,waterDistance_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorA);
e1.Color = 'black';
for ee = 1:length(sootDistance)
    if strcmp(sootSex{ee,1},'Male') == true
        scatter(sootXinds(ee,1).*2,sootDistance(ee,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
    elseif strcmp(sootSex{ee,1},'Female') == true
        scatter(sootXinds(ee,1).*2,sootDistance(ee,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e2 = errorbar(2,sootDistance_mean,sootDistance_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorB);
e2.Color = 'black';
for ff = 1:length(funcSootDistance)
    if strcmp(funcSootSex{ff,1},'Male') == true
        scatter(funcSootXinds(ff,1).*3,funcSootDistance(ff,1),100,'s','MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
    elseif strcmp(funcSootSex{ff,1},'Female') == true
        scatter(funcSootXinds(ff,1).*3,funcSootDistance(ff,1),100,'c','MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
    end
    hold on
end
e3 = errorbar(3,funcSootDistance_mean,funcSootDistance_StErr,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',colorC);
e3.Color = 'black';
maleScatter = scatter(0,NaN,'s','MarkerEdgeColor','k','MarkerFaceColor','w');
femaleScatter = scatter(0,NaN,'c','MarkerEdgeColor','k','MarkerFaceColor','w');
axis square
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'box','off')
xlim([0,4])
ylabel('Distance traveled (m)')
ylim([0,55])
legend([e1,e2,e3,maleScatter,femaleScatter],'H2O','Soot2040','Soot2040F','Male','Female')

end