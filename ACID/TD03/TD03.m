load('VTSaumonBar.mat')
sizeVTSaumon = size(VTSaumon, 1)
sizeVTBar = size(VTBar, 1)

histogram(VTSaumon, sizeVTSaumon);
histogram(VTBar, sizeVTBar);



nbIter = 1;
sizeTrain = 100;
for i=1:nbIter
    %Extraction of training samples
    TrainSaumonIndex = randperm(sizeVTSaumon, sizeTrain);
    TrainBarIndex = randperm(sizeVTBar,sizeTrain);
    
    TrainSaumon = VTSaumon(TrainSaumonIndex);
    TrainBar = VTBar(TrainBarIndex);
    
    % Treatment 
    muSaumonTrain = mean(TrainSaumon);
    sigmaSaumonTrain = sqrt(var(TrainSaumon));
    
    muBarTrain = mean(TrainBar);
    sigmaBarTrain = sqrt(var(TrainBar));
    
    % Assigning data for Test
    TestBar = VTBar;
    TestSaumon = VTSaumon;
    % Testing section
    ResBar = Myclassify(TestBar,muBarTrain,sigmaBarTrain,muSaumonTrain,sigmaSaumonTrain)
    ResSaumon = Myclassify(TestSaumon,muBarTrain,sigmaBarTrain, muSaumonTrain,sigmaSaumonTrain)
    
    % Error recovery
    nbBarErreur = size(ResBar,1)-sum(ResBar)
    nbSaumonErreur = sum(ResSaumon)
    
    
end;

function errorList = Myclassify(Sample,muBarTrain,sigmaBarTrain,muSaumonTrain,sigmaSaumonTrain)
    errorList = zeros(size(Sample,1),1);
    for i = 1:1:size(Sample)
        probX_withBar = (1/sigmaBarTrain * sqrt(pi*2)) * (exp(-0.5 * ((Sample(i)*muBarTrain)/sigmaBarTrain).^2));
        probX_withSaumon = (1/sigmaSaumonTrain * sqrt(pi*2)) * (exp(-0.5 * ((Sample(i)*muSaumonTrain)/sigmaSaumonTrain).^2));
        if probX_withBar > probX_withSaumon 
            errorList(i) = 1;
        end
    end
end

function histogram(VT, sizeVT)
    for i = 1:1:sizeVT
        VT(i);
    end
end

