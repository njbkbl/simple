



exo1_to_exo3()
exo4()



function exo1_to_exo3()
    load('VTSaumonBar.mat');
    %displayCurveSet(VTBar,VTSaumon);

    sizeVTBar = size(VTBar,1);
    sizeVTSaumon = size(VTSaumon,1);

    nbIter = 100;
    sizeTrain = 100;

    vectorErrorsMAP = zeros(nbIter, 2);
    vectorErrorsMLE = zeros(nbIter, 2);
    vectorErrorsRISK = zeros(nbIter, 2);

    pBar = sizeVTBar / (sizeVTBar + sizeVTSaumon);


    for ligneActuelle=1:nbIter
        %INDICES_ENTRAINEMENT
        indicesSaumon = randperm(sizeVTSaumon, sizeTrain);
        indicesBar = randperm(sizeVTBar, sizeTrain);
        %EX_ENSEMBLE_ENTRAINEMENT
        TrainSaumon = VTSaumon(indicesSaumon);
        TrainBar = VTBar(indicesBar);

        %ENTRAINEMENT
        vectorSaumonMuSigma = getMuAndSigma(TrainSaumon);
        vectorBarMuSigma = getMuAndSigma(TrainBar);

        %TEST
        TestBar = removeIntersection(indicesBar, VTBar);
        TestSaumon = removeIntersection(indicesSaumon, VTSaumon);


        ResBarMLE = MyclassifyMLE(TestBar, vectorBarMuSigma, vectorSaumonMuSigma);
        ResSaumonMLE = MyclassifyMLE(TestSaumon, vectorBarMuSigma, vectorSaumonMuSigma);

        ResBarMAP = MyclassifyMAP(TestBar, vectorBarMuSigma, vectorSaumonMuSigma, pBar);
        ResSaumonMAP = MyclassifyMAP(TestSaumon, vectorBarMuSigma, vectorSaumonMuSigma, pBar);

        ResBarRISK = MyclassifyRISK(TestBar, vectorBarMuSigma, vectorSaumonMuSigma, pBar);
        ResSaumonRISK = MyclassifyRISK(TestSaumon, vectorBarMuSigma, vectorSaumonMuSigma, pBar);

        %RECUP_ERREURS
        vectorErrorsMLE = calcVectorErrors(vectorErrorsMLE, ligneActuelle , ResBarMLE,ResSaumonMLE);  
        vectorErrorsMAP = calcVectorErrors(vectorErrorsMAP, ligneActuelle , ResBarMAP,ResSaumonMAP);  
        vectorErrorsRISK = calcVectorErrors(vectorErrorsRISK, ligneActuelle , ResBarRISK,ResSaumonRISK);  

    end;


    %displayCurveErrors(nbIter,vectorErrorsMLE,'MLE')
    %displayCurveErrors(nbIter,vectorErrorsMAP,'MAP')
    %displayCurveErrors(nbIter,vectorErrorsRISK,'RISK')

    displayResultClassification(nbIter, size(TestBar,1), size(TestSaumon,1), vectorErrorsMLE, vectorErrorsMAP, vectorErrorsRISK)

end

function exo4()
    load('VTSaumonBar2.mat');
    nbIter = 100;
    sizeTrain = 100;
    sizeVTBar = size(VTBar,1);
    sizeVTSaumon = size(VTSaumon,1);
       

    vectorErrorsNDim = zeros(nbIter, 2);
    
    pBar = sizeVTBar / (sizeVTBar + sizeVTSaumon);

    
    for ligneActuelle = 1:nbIter
        %INDICES_ENTRAINEMENT
        indicesSaumon = randperm(sizeVTSaumon, sizeTrain);
        indicesBar = randperm(sizeVTBar, sizeTrain);
        %EX_ENSEMBLE_ENTRAINEMENT
        saumonTrain = calcTrainEnsemble(VTSaumon, indicesSaumon, sizeTrain);
        barTrain = calcTrainEnsemble(VTBar, indicesBar, sizeTrain);

        %TEST
        TestSaumon = removeIntersection(indicesSaumon, VTSaumon);
        TestBar = removeIntersection(indicesBar, VTBar);    

        %ENTRAINEMENT
        vectorMuSaumon = calcVectorMu(saumonTrain);
        vectorMuBar = calcVectorMu(barTrain);

        %CALC COV MATRIX
        covMatrixSaumon = cov(TestSaumon);
        covMatrixBar = cov(TestBar);

        ResSaumon = MyClassifyNDimension(TestSaumon, vectorMuSaumon, vectorMuBar, covMatrixBar , covMatrixSaumon, pBar);
        ResBar = MyClassifyNDimension(TestBar, vectorMuSaumon, vectorMuBar, covMatrixBar, covMatrixSaumon, pBar);

        %RECUP_ERREURS
        vectorErrorsNDim = calcVectorErrors(vectorErrorsNDim, ligneActuelle , ResBar, ResSaumon); 
    end

    
    %displayCurveErrors(nbIter,vectorErrorsNDim,'NDIM')
    displayRestultClassificationNDim(vectorErrorsNDim,nbIter,size(TestBar,1), size(TestSaumon,1))



end


%% Functions annexes Exo 1 to 3

function vector = removeIntersection (TrainIndices, TestVector)
    tmp= TestVector;
    tmp(TrainIndices,:)=[];
    vector = tmp;
end
    
function res = MyclassifyMLE (TestPopulation, vectorBarMS, vectorSaumonMS)
    res = zeros(size(TestPopulation, 1), 1);
    for index = 1:size(TestPopulation)
        if maximumDeVraissemblance(vectorBarMS(1), vectorBarMS(2), TestPopulation(index)) > maximumDeVraissemblance(vectorSaumonMS(1), vectorSaumonMS(2), TestPopulation(index))
            res(index) = 1;
        end
    end
end

function prob = maximumDeVraissemblance (mu, sigma, taille)
    prob = (1/(sigma*sqrt(2*pi))) * exp((-0.5)*((taille - mu) / sigma).^2);
end

function res = MyclassifyMAP (TestPopulation, vectorBarMS, vectorSaumonMS, probClasseBar)
    res = zeros(size(TestPopulation, 1), 1);
    for index = 1:size(TestPopulation)
        if maximumAPosteriori(vectorBarMS(1), vectorBarMS(2), TestPopulation(index), probClasseBar) > maximumAPosteriori(vectorSaumonMS(1), vectorSaumonMS(2), TestPopulation(index), 1 - probClasseBar)
            res(index) = 1;
        end
    end
end

function prob = maximumAPosteriori (mu, sigma, taille, probClasse)
    prob = maximumDeVraissemblance(mu, sigma, taille) .* probClasse;
end

function res = MyclassifyRISK (TestPopulation, vectorBarMS, vectorSaumonMS, probClasseBar)
    res = zeros(size(TestPopulation, 1), 1);
    for index = 1:size(TestPopulation)
        MLEBar = maximumDeVraissemblance(vectorBarMS(1), vectorBarMS(2), TestPopulation(index));
        MLESaumon = maximumDeVraissemblance(vectorSaumonMS(1), vectorSaumonMS(2), TestPopulation(index));
        if (MLEBar / MLESaumon) > (2 / 1) * ((1 - probClasseBar) / probClasseBar)
            res(index) = 1;
        end
    end
end

function vector = getMuAndSigma (dataTrain)
    vector = [mean(dataTrain), sqrt(var(dataTrain))];
end

function ve = calcVectorErrors(vectorErrors,ligneActuelle, ResBar,ResSaumon)     
    vectorErrors(ligneActuelle, 1) = size(ResBar,1)-sum(ResBar);
    vectorErrors(ligneActuelle, 2) = sum(ResSaumon);
    ve = vectorErrors;
end

function displayCurveSet(VTBar,VTSaumon)
    hold on;
    histogram(VTBar);
    histogram(VTSaumon);
    title('Histogram VTBar et VTSaumon')
    legend('VTBar','VTSaumon')
    hold off;
end

function displayCurveErrors(nbIter,vectorErrors,type)
    hold on
    plot (1:1:nbIter, vectorErrors(:,1))
    plot (1:1:nbIter, vectorErrors(:,2))
    str = sprintf('Nb erreurs pour %d itérations (%s)', nbIter,type);
    title(str)
    legend('Bar','Saumon')
    hold off
end

function displayResultClassification(nbIter,sizeTestBar,sizeTestSaumon,vectorErrorsMLE,vectorErrorsMAP,vectorErrorsRISK)
    
    pourcentageErreurBarMLE = mean(vectorErrorsMLE(:,1)) / sizeTestBar * 100;
    pourcentageErreurSaumonMLE = mean(vectorErrorsMLE(:,2)) / sizeTestSaumon * 100;
    
    fprintf('\nNombre Itération: %d\n',nbIter)
    fprintf('=== Résultat MLE ===\n Pourcentage Erreur Bar: %f \n',pourcentageErreurBarMLE)
    fprintf(' Pourcentage Erreur Saumon: %f\n',pourcentageErreurSaumonMLE)
    
    pourcentageErreurBarMAP = mean(vectorErrorsMAP(:,1)) / sizeTestBar * 100;
    pourcentageErreurSaumonMAP = mean(vectorErrorsMAP(:,2)) / sizeTestSaumon * 100;
    
    fprintf('=== Résultat MAP ===\n Pourcentage Erreur Bar: %f \n',pourcentageErreurBarMAP)
    fprintf(' Pourcentage Erreur Saumon: %f\n',pourcentageErreurSaumonMAP)
    
    pourcentageErreurBarRISK = mean(vectorErrorsRISK(:,1)) / sizeTestBar * 100;
    pourcentageErreurSaumonRISK = mean(vectorErrorsRISK(:,2)) / sizeTestSaumon * 100;
    
    fprintf('=== Résultat RISK ===\n Pourcentage Erreur Bar: %f \n',pourcentageErreurBarRISK)
    fprintf(' Pourcentage Erreur Saumon: %f\n',pourcentageErreurSaumonRISK)
    
    
    

end






%% Functions annexes Exo 4

function res = MyClassifyNDimension (TestPopulation, vectorMuSaumon, vectorMuBar, covMatrixBar,covMatrixSaumon, pBar)
    res = zeros(size(TestPopulation, 1), 1);
    for index = 1:size(TestPopulation)
        elem = TestPopulation(index, :);
        pXSachantBar = mvnpdf(transpose(elem), vectorMuBar, covMatrixBar);
        pXSachantSaumon = mvnpdf(transpose(elem), vectorMuSaumon, covMatrixSaumon);
        if (pXSachantBar / pXSachantSaumon) > (2 / 1) * ((1 - pBar) / pBar)
            res(index) = 1;
        end
    end
end

function muVect = calcVectorMu(train)
    nbCulumn = size(train, 2);
    muVect = zeros(nbCulumn, 1);
    for i = 1:nbCulumn
        muVect(i) = mean(train(:, i));
    end
end

function trainEnsemble = calcTrainEnsemble(VTPopulation, indices, sizeTrain)
    nbCulumns = size(VTPopulation, 2);
    trainEnsemble = zeros(sizeTrain, nbCulumns);
    s = size(indices);
    for i = 1:1:s(2)
        indice = indices(i);
        trainEnsemble(i,:) = VTPopulation(indice,:);
    end
end

function displayRestultClassificationNDim(vectorErrorsNDim,nbIter,sizeTestBar,sizeTestSaumon)
    pourcentageErreurBarNDim = mean(vectorErrorsNDim(:,1)) / sizeTestBar * 100;
    pourcentageErreurSaumonNDim = mean(vectorErrorsNDim(:,2)) / sizeTestSaumon * 100;
    
    fprintf('\nNombre Itération: %d\n',nbIter)
    fprintf('=== Résultat N Dimension ===\n Pourcentage Erreur Bar: %f \n',pourcentageErreurBarNDim)
    fprintf(' Pourcentage Erreur Saumon: %f\n',pourcentageErreurSaumonNDim)

end










