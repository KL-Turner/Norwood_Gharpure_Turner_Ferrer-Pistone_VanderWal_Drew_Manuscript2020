function [AnalysisResults] = TrackAnimalHeight_JK2020(animalID,saveFigs,rootFolder,AnalysisResults)
%________________________________________________________________________________________________________________________
% Written by Kevin L. Turner
% The Pennsylvania State University, Dept. of Biomedical Engineering
% https://github.com/KL-Turner
%________________________________________________________________________________________________________________________
%
% Purpse: track height of the mouse using the depth stack
%________________________________________________________________________________________________________________________

dataLocation = [rootFolder '/' animalID '/'];
cd(dataLocation)
% find and load SupplementalData.mat struct
suppDataFileStruct = dir('*_SupplementalData.mat');
suppDataFile = {suppDataFileStruct.name}';
suppDataFileID = char(suppDataFile);
load(suppDataFileID,'-mat');
% find and load ProcDepthStack.mat struct
procStackFileStruct = dir('*_ProcDepthStack.mat');
procStackDataFile = {procStackFileStruct.name}';
procStackDataFileID = char(procStackDataFile);
load(procStackDataFileID,'-mat');
% go through each frame and extract the height of the mouse
caxis = SuppData.caxis;
maxVal = caxis(2);
rawHeight = zeros(size(procDepthStack,3),1);
avgHeight = zeros(size(procDepthStack,3),1);
avg20Height = zeros(size(procDepthStack,3),1);
for a = 1:size(procDepthStack,3)
    depthImg = procDepthStack(:,:,a);
    maxInds = depthImg == maxVal;
    depthImg(maxInds) = NaN;
    rawHeight(a,1) = min(depthImg(:));   
    validPix = imcomplement(isnan(depthImg));
    pixelVec = depthImg(validPix);
    ascendPixelVals = sort(pixelVec(:),'ascend');
    avgHeight(a,1) = mean(pixelVec);   
    twentyPercentile = ascendPixelVals(1:ceil(length(ascendPixelVals)*0.2));
    avg20Height(a,1) = mean(twentyPercentile);
end
AnalysisResults.(animalID).Rearing.rawHeight = fliplr(100*rawHeight);
AnalysisResults.(animalID).Rearing.avgHeight = fliplr(100*avgHeight);
AnalysisResults.(animalID).Rearing.avg20Height = fliplr(100*avg20Height);
% determine number of rearing events
threshHeight = 3;   % cm
mouseHeight = AnalysisResults.(animalID).Rearing.avg20Height';
X = ~isnan(mouseHeight);
Y = cumsum(X - diff([1,X])/2);
adjustedHeight = interp1(1:nnz(X),mouseHeight(X),Y);
if sum(isnan(adjustedHeight)) > 0
    nanInds = isnan(adjustedHeight);
    nonnanInds = ~isnan(adjustedHeight);
    realVals = adjustedHeight(nonnanInds);
    tempDescendPixelVals = sort(realVals(:),'descend');
    tempBaseline = mean(tempDescendPixelVals(1:ceil(length(realVals)*0.3)));
    adjustedHeight(nanInds) = tempBaseline;
end
descendPixelVals = sort(adjustedHeight(:),'descend');
baseline = mean(descendPixelVals(1:ceil(length(adjustedHeight)*0.3)));
positiveVals = adjustedHeight <= (baseline - threshHeight);
changes = diff(positiveVals);
AnalysisResults.(animalID).Rearing.rearingEvents = sum(ismember(changes,1));
% show summary figure
if strcmp(saveFigs,'y') == true
    animalIDrep = strrep(animalID,'_',' ');
    animalHeight = figure;
    sgtitle([animalIDrep ' rearing events'])
    % comparison of different height thresholds
    subplot(2,1,1)
    plot((1:length(rawHeight))/SuppData.samplingRate,fliplr(100*rawHeight),'color',colors_JK2020('sapphire'))
    hold on
    plot((1:length(avgHeight))/SuppData.samplingRate,fliplr(100*avgHeight),'color',colors_JK2020('dark candy apple red'))
    plot((1:length(avg20Height))/SuppData.samplingRate,fliplr(100*avg20Height),'color',colors_JK2020('vegas gold'))
    set(gca,'YDir','reverse')
    title('Animal''s distance from camera')
    ylabel('Distance (cm)')
    xlabel('~Time (sec)')
    legend('Min pixel value','Mean of all valid pixels','Mean of bottom 20% of valid pixels')
    set(gca,'box','off')
    % number of rearing events based on calculated baseline and chosen elevation threshold
    subplot(2,1,2)
    negativeVals = adjustedHeight > (baseline - threshHeight);
    yVals = zeros(length(positiveVals),1);
    yVals(positiveVals) = min(AnalysisResults.(animalID).Rearing.avg20Height) - 1;
    yVals(negativeVals) = NaN;
    p1 = [baseline,1];
    p2 = [baseline,1200];
    p3 = [baseline - threshHeight,1];
    p4 = [baseline - threshHeight,1200];
    plot((1:length(adjustedHeight))/SuppData.samplingRate,adjustedHeight,'color',colors_JK2020('vegas gold'))
    hold on
    scatter((1:length(yVals))/SuppData.samplingRate,yVals,'MarkerEdgeColor','k','MarkerFaceColor',colors_JK2020('electric purple'))
    plot([p1(2),p2(2)],[p1(1),p2(1)],'color','k','LineWidth',2)
    plot([p3(2),p4(2)],[p3(1),p4(1)],'color',colors_JK2020('electric purple'),'LineWidth',2)
    set(gca,'YDir','reverse')
    ylabel('Distance (cm)')
    xlabel('~Time (sec)')
    legend('Mean of bottom 20% of valid pixels','Positive events')
    set(gca,'box','off')
    % save figure
    [pathstr,~,~] = fileparts(cd);
    dirpath = [pathstr '/' animalID '/Figures/'];
    if ~exist(dirpath,'dir')
        mkdir(dirpath);
    end
    savefig(animalHeight,[dirpath animalID '_RearingHeight']);
    close(animalHeight)
end
% save results
cd(rootFolder)
save('AnalysisResults.mat','AnalysisResults')

end