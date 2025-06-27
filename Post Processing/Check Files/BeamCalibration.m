clear ; clc ; close ;

path = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Data - v3 - Analyzed\Substrate 12-07-23_TD 1-29-24" ; 
path2 = "K:\Yang Research\Two-Photon Polymerization\Tensile Testing Data\Second Paper\Data - v3 - Analyzed\Substrate 12-07-23_TD 1-31-24" ; 

Twenty = [ 3, 4 ] ; 
Pixel2MicronRatio = 0.33 ;
SmoothFactor = 5 ; 


for n = 1:size(Twenty,2)

    loadpath = fullfile(path, string(Twenty(n)), "Raw Data.mat") ; 
    loadpath2 = fullfile(path, string(Twenty(n)), "Parameters.mat") ; 
    load(loadpath) ; 
    load(loadpath2) ; 

    BeamStiffness = 95.8 ;
    P2MR_Adj = Pixel2MicronRatio / Parameters.ResolutionMultiplier ;
    BotDisplacement = Data.BottomStructure.SumDisplacementYAdjusted * P2MR_Adj ;
    Force = BotDisplacement * BeamStiffness ;
    %Force = smooth(smooth(Force(1:380),SmoothFactor), SmoothFactor) ; 
    
    plot(Force, 'LineWidth', 2) ; %hold on ;
    
    [XPt, ~] = ginput(2) ;
    Index1 = round(XPt(1)) ;
    Index2 = round(XPt(2)) ; 

    if n == 1 
       
        Diff = Index2 - Index1 ; 
    
    elseif n == 2

        Index2 = Index1+Diff ; 

    end
    Force = smooth(smooth(Force(Index1:Index2),SmoothFactor), SmoothFactor) ;
    ForceKeep(:,n) = Force ; 

    %disp(Parameters.DisplacementRate) ; 

end

Vector1 = mean(ForceKeep') ; 
% plot(Vector1, 'LineWidth', 2) ; hold on ;

% 
Twenty5 = [ 3,4 ] ; 
for n = 1:size(Twenty5,2)  

    loadpath = fullfile(path2, string(Twenty5(n)), "Raw Data.mat") ; 
    loadpath2 = fullfile(path2, string(Twenty5(n)), "Parameters.mat") ; 
    load(loadpath) ; 
    load(loadpath2) ; 

    P2MR_Adj = Pixel2MicronRatio / Parameters.ResolutionMultiplier ;
    BotDisplacement = Data.BottomStructure.SumDisplacementYAdjusted * P2MR_Adj ;
    Displacement = BotDisplacement ;

    plot(Displacement, 'LineWidth', 2) ; %hold on ;

    [XPt, ~] = ginput(1) ;
    Index1 = round(XPt(1)) ;

    Index2 = Index1+Diff ; 


    Displacement = smooth(smooth(Displacement(Index1:Index2),SmoothFactor), SmoothFactor) ;
    DisplacementKeep(:,n) = Displacement ; 

    %plot(Force2) ; hold on ;

end

Vector2 = mean(DisplacementKeep') ;

plot(Vector1, 'LineWidth', 2) ; hold on ;

plot(Vector2*125, 'LineWidth', 2) ;

% Vector1 = Disp20 ; 
% Vector2 = Force15 ; 

% % Find the linear constant (calibration factor)
% calibration_constant = sum(Vector2 .* Vector1) / sum(Vector1.^2);
% 
% % Calibrate the first vector using the calibration constant
% calibrated_vector1 = calibration_constant * Vector1;
% 
% % Calculate the sum of squared errors
% squared_errors = (calibrated_vector1 - Vector2).^2;
% sum_of_squared_errors = sum(squared_errors);
% 
% % Display the calibration constant and the sum of squared errors
% fprintf('Calibration Constant: %.4f\n', calibration_constant);