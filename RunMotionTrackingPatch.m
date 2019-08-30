function [] = RunMotionTrackingPatch(supplementalFile)


binStackDirectory = dir('*BinDepthStack.mat');
binStackFiles = {binStackDirectory.name}';
binStackFile = char(binStackFiles);

disp('Tracking object motion...'); disp(' ')
resultsFile = [supplementalFile(1:end-20) 'Results.mat'];
load(binStackFile)
load(supplementalFile)
load(resultsFile)

distanceTraveled = 0;
distancePath = zeros(1,length(binDepthStack));
for x = 1:length(binDepthStack)
    if x == length(binDepthStack)
        break
    else
        imageA = binDepthStack(:,:,x);
        [yA,xA] = ndgrid(1:size(imageA,1), 1:size(imageA,2));
        centroidA = mean([xA(logical(imageA)), yA(logical(imageA))]);
        
        imageB = binDepthStack(:,:,x+1);
        [yB,xB] = ndgrid(1:size(imageB,1), 1:size(imageB,2));
        centroidB = mean([xB(logical(imageB)), yB(logical(imageB))]);
        
        centroidCoord = [centroidB; centroidA];
        distance = pdist(centroidCoord, 'euclidean');
        if isnan(distance) == true
            distance = 0;
        end
        distanceTraveled = distanceTraveled+distance;
        distancePath(1,x) = distanceTraveled;
    end
end

figure;
plot((1:length(distancePath))/15, distancePath)
title('Distance traveled')
ylabel('Pixels')
xlabel('~Time (sec)')

Results.distanceTraveled = distanceTraveled;
Results.distancePath = distancePath;
save(resultsFile, 'Results')

end
