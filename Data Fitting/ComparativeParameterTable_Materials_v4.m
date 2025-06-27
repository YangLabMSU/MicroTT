clear ; clc ; close all ;

% Plotting and Comparing the Entire Datasets of all IP-S, IP-Visio, and IP-Dip

load('IP-Dip Fit Values for Comparison.mat') ;
load('IP-S Fit Values for Comparison - v2.mat') ;
load('IP-Visio Fit Values for Comparison.mat') ;

for n = 1:size(IPSFitValues,2)

    IPSIdx = ~isnan(IPSFitValues(:,n)) ;
    ColAvgIPS = mean(IPSFitValues(IPSIdx,n)) ;
    ColStdIPS = std(IPSFitValues(IPSIdx,n)) ;

    if n == 1

        IPS_E1Avg = ColAvgIPS ;

    elseif n == 2 || n == 4

        ColAvgIPS = ColAvgIPS / IPS_E1Avg ;
        ColStdIPS = ColStdIPS / IPS_E1Avg ;

    end

    Table(1,n) = ColAvgIPS + "+-" + ColStdIPS ;

    IPDipIdx = ~isnan(IPDipFitValues(:,n)) ;
    ColAvgIPDip = mean(IPDipFitValues(IPDipIdx,n)) ;
    ColStdIPDip = std(IPDipFitValues(IPDipIdx,n)) ;

    if n == 1

        IPDip_E1Avg = ColAvgIPDip ;

    elseif n == 2 || n == 4

        ColAvgIPDip = ColAvgIPDip / IPDip_E1Avg ;
        ColStdIPDip = ColStdIPDip / IPDip_E1Avg ;

    end

    Table(3,n) = ColAvgIPDip + "+-" + ColStdIPDip ;

    IPVisIdx = ~isnan(IPVisioFitValues(:,n)) ;
    ColAvgIPVis = mean(IPVisioFitValues(IPVisIdx,n)) ;
    ColStdIPVis = std(IPVisioFitValues(IPVisIdx,n)) ;

    if n == 1

        IPVis_E1Avg = ColAvgIPVis ;

    elseif n == 2 || n == 4

        ColAvgIPVis = ColAvgIPVis / IPVis_E1Avg ;
        ColStdIPVis = ColStdIPVis / IPVis_E1Avg ;

    end

    Table(2,n) = ColAvgIPVis + "+-" + ColStdIPVis ;

end

TableFirstCol = [ "IP-S" size(IPSFitValues,1) ; "IP-Visio" size(IPVisioFitValues,1) ;...
    "IP-Dip" size(IPDipFitValues,1)] ;

Table = [ TableFirstCol Table ] ;
Header = [ "Material" "Measurements" "E1" "E2" "Lam1" "E3" "Lam2" "Yield e" "Yield Stress"];

Table = [ Header ; Table ] ;
