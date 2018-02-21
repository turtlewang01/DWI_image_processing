function ADChist3w(BW,input_matrix);
mulval = [];
percval = [];
percentiles = [0.05,0.1,0.25,0.5,0.75,0.90];%¸????????

    
ADCval = input_matrix(BW==1);
mulval = ADCval;
roiarea =length(ADCval);

%mulval(mulval<0) = [];
mulval = sort(mulval);
%     mulval = mulval*1000000;%¸??????
title = {};
for j = 1:length(percentiles)
    percval(1,j) = mulval(uint32(length(mulval)*percentiles(j)));
    title{1,j} = ['ADC',num2str(percentiles(j)*100)];
end
features = ADCfeature(mulval);
percval(1,j+1) = features(4);%Skew
percval(1,j+2) = features(3);%Kurtosis
percval(1,j+3) = features(1);%mean value
percval(1,j+4) = roiarea;

%% write file
title = [title,{'skew','kurtosis','mean_value','sum_of_area'}];
[filename,filepath] = uiputfile('*.xls','Save statistical As');
xlswrite([filepath,filename],title,1,'A1');
xlswrite([filepath,filename],percval,1,'A2');
save([filepath,'percval.mat'],'percval');
save([filepath,'mulval.mat'],'mulval');


function features = ADCfeature(input)
%calculate the different order moment(stastical value);
%
mu = mean(input);
SD = 0;
kurt = 0;
skew = 0;
n = length(input);
% for i = 1:n
%     xi = input(i);
%     SD = SD+(xi-mu)^2;
%     kurt = kurt+(xi-mu)^4;
%     skew = skew+(xi-mu)^3;
% end

SD = std(input);
kurt = kurtosis(input);
skew = skewness(input);

% SD = sqrt(SD/n);
% kurt = (kurt/(SD^4)/(n-1))-3;
% skew = skew/(SD^3)/(n-1);
features = [mu,SD,kurt,skew];

