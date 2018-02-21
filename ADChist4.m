function ADChist3()
[filename,filepath] = uigetfile('*.nii');%??????nii??
a=load_nii([filepath,filename]);
[roiname,roipath] = uigetfile('*.mat','??roi??');
mulval = [];
percval = [];
percentiles = [0.05,0.1,0.25,0.5,0.75,0.90];%¸????????
if roipath == 0
    mulroi = {};
    roiarea = 0;
    for i = 1:size(a.img,3)
        image = a.img(:,:,i);
        %»­Ò»¸öroi
        imshow(image,[])
        roiedges = imfreehand;
        roi = createMask(roiedges);
        mulroi{i} = roi;
        if ~isempty(find(roi==1))    
        %?ADC???    
            ADCval = image(roi==1);
            mulval = [mulval;ADCval];
            roiarea = roiarea + length(ADCval);
        end
    end
    mulval(mulval<0) = [];
    mulval = sort(mulval);
    mulval = mulval*1000000;%??????
    title = {};
    for j = 1:length(percentiles)
        percval(1,j) = mulval(uint32(length(mulval)*percentiles(j)));
        title{1,j} = ['ADC',num2str(percentiles(j)*100)];
    end 
    features = ADCfeature(mulval);
    percval(1,j+1) = features(4);%Skew
    percval(1,j+2) = features(3);%Kurtosis
    percval(1,j+3) = features(1);%??
    percval(1,j+4) = roiarea;
    title = [title,{'skew','kurtosis','??','???'}];
    xlswrite([filename(1:end-4),'_percval.xls'],title,1,'A1')
    xlswrite([filename(1:end-4),'_percval.xls'],percval,1,'A2')
    save([filepath,'percval.mat'],'percval')
    save([filepath,'mulroi.mat'],'mulroi')
    save([filepath,'mulval.mat'],'mulval')
else
    load([roipath,roiname]);
    roiarea = 0;
    for i = 1:size(a.img,3)
        image = a.img(:,:,i);
        %     roi = mulroi{i};
        roi = mulroi{i};
        if ~isempty(find(roi==1))
            %?ADC???
            ADCval = image(roi==1);
            mulval = [mulval;ADCval];
            roiarea = roiarea + length(ADCval);
        end
    end
    mulval(mulval<0) = [];
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
    percval(1,j+3) = features(1);%??
    percval(1,j+4) = roiarea;
    title = [title,{'skew','kurtosis','??','???'}];
    xlswrite([filepath,filename(1:end-4),'_percval.xls'],title,1,'A1')
    xlswrite([filepath,filename(1:end-4),'_percval.xls'],percval,1,'A2')
    save([filepath,'percval.mat'],'percval')
    save([filepath,'mulval.mat'],'mulval')
end
disp(percval)

function features = ADCfeature(input)
%????
%
mu = mean(input);
SD = 0;
kurt = 0;
skew = 0;
n = length(input);
for i = 1:n
    xi = input(i);
    SD = SD+(xi-mu)^2;
    kurt = kurt+(xi-mu)^4;
    skew = skew+(xi-mu)^3;
end
SD = sqrt(SD/n);
kurt = (kurt/(SD^4)/(n-1))-3;
skew = skew/(SD^3)/(n-1);
features = [mu,SD,kurt,skew];

