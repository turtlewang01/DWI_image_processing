clc
clear
% file_path='D:\part_time_job\DWI\IVIM1\IVIM1\IM';
file_path='D:\part_time_job\DWI\IVIM1\panxingjian\IM';
solve_method=1; %1=Biexp, 2=LS,3=Mix,4= fix D_star?5=sove 3 variable simultaneously
d_method=2; % 1=use ADC as d,2=use LS method fitting,3=use just two points to calculate D,4= use the LS method fitting,but use the original data
data_source='DICOM'; % DICOM or nii;
ROI_create=0;% 1: create the ROI,0= load the ROI;
use_modify_model=0; % 1=using the modified model; 0=use the origiianal model
result_quantizer=0; % 1=quantizing the result;
opti_method='levenberg-marquardt'; % trust-region-reflective method or levenberg-marquardt method

use_filter=1; % 1=use filter; 0=don't use filter;
threshold_noise=15; % threshold for noise; signal value below this value is thougt to be noise

num_analysis=9; % slice number used for analysis
num_image=238; %number of images?this option only takes effect when choose nii format
num_slice=17; % number of slice?this option only takes effect when choose nii format


flag_use_part_b=0; %1=use part of the b value for computation;0=use all the b value to compute;
b_value_list=[200,400]; % use part b-value for computation, b=0 is used by default.

D_star_ub=50*10^(-3);
D_star_lb=0;
D_ub=2.5*10^(-3);
D_lb=0;
f_ub=0.3;
f_lb=0;

num_b=floor(num_image/num_slice);
%% this section choose the DICOM image
if(strcmp(data_source,'DICOM'))
    for(i=1:num_image-1)
        file_seq=i-1;
        file_seq_str=num2str(file_seq);
        file_path_full=strcat(file_path,file_seq_str);
        metadata = dicominfo(file_path_full);
        z_axis_total(i)=metadata.SliceLocation;
    end    
    [z_axis_new,index_i]=sort(z_axis_total);
    clear z_axis_new z_axis_total metadata file_path_full file_seq_str file_seq        
    for(i=1:num_b)        
        file_seq=index_i(num_analysis*num_b+i)-1;
        file_seq_str=num2str(file_seq);
        file_path_full=strcat(file_path,file_seq_str);
        
        I(:,:,i)=dicomread(file_path_full);
        metadata = dicominfo(file_path_full);
        z_axis(i)=metadata.SliceLocation;
        
        curBvalue=metadata.Private_0043_1039;
        if(abs(curBvalue(1))<1)
            b_val_read(i)=curBvalue(1);
        else
            b_val_read(i)=curBvalue(1)-1000000000;
        end
    end    
    [b_val,index_I] = sort(b_val_read);
    temp=b_val(1);
    b_val(1:end-1)=b_val(2:end);
    b_val(end)=temp;
    temp=index_I(1);
    index_I(1:end-1)=index_I(2:end);
    index_I(end)=temp;
    temp=I(:,:,index_I);
    I=temp;
else
    %% this section use the nii denoise image
    file_path='D:\part_time_job\DWI\IVIM1\cyw_nii\cyw.nii';
%     file_path_new='D:\part_time_job\DWI\IVIM1\cyw_nii\cyw_new.nii';
    metadata.PatientName.FamilyName='cyw';
%     reslice_nii(file_path, file_path);
    nii = load_nii(file_path);
    D=nii.img;
    [metadata.Height,metadata.Width,num_slice,num_b]=size(D);
    num_image=num_slice*num_b; %number of images
    num_analysis=9; % slice number used for analysis    
    for(i=1:num_b)
        I(:,:,i)=D(:,:,num_analysis,i);
    end   
    clear D nii;
    I= rot90(I);
    b_val=[10,20,30,40,50,80,100,150,200,400,600,800,1000,0]; %
%     b_val=[10,20,30,40,50,80,100,150,200,400,600,800,1000,0];
%     b_val=[10,20,30,40,50,80,120,150,200,400,700,800,1000,0];
      b_val=[10,20,30,40,50,80,120,150,200,400,600,800,1000,0]; % for guiqing
%     b_val=[400 600 1000];
end
%% this section denoise the image;
% h = fspecial('gaussian',[3,3],0.2);
% for(i=1:14)
%     I(:,:,i)=imfilter(I(:,:,i),h);
% end
h_handle=figure
imagesc(I(:,:,1));
title(strcat('Original Pic/',metadata.PatientName.FamilyName))

%% create ROI or load ROI%%
if(ROI_create)
    BW = roipoly(I(:,:,1));
    ROI_file=strcat('BW_',metadata.PatientName.FamilyName);
    save(ROI_file,'BW');    
%     BW1 = edge(I(:,:,1),'sobel'); % edge detection
else
    BW=load(strcat('BW_',metadata.PatientName.FamilyName));
    BW=BW.BW;
end

%% this section choose the b value used for computation
if(flag_use_part_b)
    used_index=zeros(size(b_value_list));
    b_value_list=sort(b_value_list,'ascend');
    num_blist=length(b_value_list);
    for(i=1:num_blist)
        temp=find(abs(b_val-b_value_list(i))<0.5);
        if(isempty(temp))
            error('Wrong number!');
        else
            used_index(i)=temp;
        end
    end
    b_val=[b_value_list,b_val(end)];
    temp=zeros(metadata.Height,metadata.Width,num_blist+1);
    temp(:,:,1:num_blist)=I(:,:,used_index);
    temp(:,:,end)=I(:,:,end);
    I=temp;
    clear temp;
    num_b=length(b_val);
    
    num_start=1; % the 9th b number
    num_end=num_blist; % the 13th b number
else
    num_start=9; % the 9th b number
    num_end=13; % the 13th b number
end
n_length=num_end-num_start+1;
b_val_nonzero=b_val(1:end-1);


I=double(I);

option.BW=BW;
option.num_start=num_start;
option.num_end=num_end;
option.solve_method=solve_method;
option.d_method=d_method;
option.use_modify_model=use_modify_model;
option.threshold_noise=threshold_noise;
option.opti_method=opti_method;


option.D_star_ub=D_star_ub;
option.D_star_lb=D_star_lb;
option.D_ub=D_ub;
option.D_lb=D_lb;
option.f_ub=f_ub;
option.f_lb=f_lb;




outdata=ivim(I,b_val,option);

f_matrix=outdata.f;
D_matrix=outdata.D;
D_star_matrix=outdata.D_star;


h = fspecial('gaussian',[3,3],0.2);
%% post-processing %%
if(result_quantizer)
    ffigure_matrix=f_matrix;
    figure
    index_f=find(f_matrix>f_ub);
    ffigure_matrix(index_f)=0.0;
    index_f=find(f_matrix<f_lb);
    ffigure_matrix(index_f)=0.0;
    k_f=1/f_ub;
    ffigure_matrix=k_f*ffigure_matrix;
    ffigure_matrix=fi(ffigure_matrix,0,4);
    ffigure_matrix=str2num(ffigure_matrix.Value);    
    ffigure_matrix=imfilter(ffigure_matrix,h);    
    imagesc(ffigure_matrix);
    colorbar
    title(strcat('f map/ ',metadata.PatientName.FamilyName))
    
    
    Dfigure_matrix=D_matrix;
    figure
    index_D=find(D_matrix>D_ub);
    Dfigure_matrix(index_D)=0.0;
    index_D=find(D_matrix<D_lb);
    Dfigure_matrix(index_D)=0.0;
    k_d=1/D_ub;
    Dfigure_matrix=k_d*Dfigure_matrix;
    Dfigure_matrix=fi(Dfigure_matrix,0,4);
    Dfigure_matrix=str2num(Dfigure_matrix.Value);    
    Dfigure_matrix=imfilter(Dfigure_matrix,h);
    imagesc(Dfigure_matrix);
    colorbar
    title(strcat('D map/',metadata.PatientName.FamilyName))
    
    D_star_figure_matrix=D_star_matrix;
    figure
    index_D=find(D_star_figure_matrix>D_star_ub);
    D_star_figure_matrix(index_D)=0.0;
    index_D=find(D_star_figure_matrix<D_star_lb);
    D_star_figure_matrix(index_D)=0.0;
    k_d=1/D_star_ub;
    D_star_figure_matrix=k_d*D_star_figure_matrix;
    D_star_figure_matrix=fi(D_star_figure_matrix,0,4);
    D_star_figure_matrix=str2num(D_star_figure_matrix.Value);
    imagesc(D_star_figure_matrix);
    colorbar
    title(strcat('D star map/',metadata.PatientName.FamilyName))
else
    ffigure_matrix=f_matrix;
    figure  
    index_f=find(f_matrix>f_ub);
    ffigure_matrix(index_f)=0.0;
    index_f=find(f_matrix<f_lb);
    ffigure_matrix(index_f)=0.0;
    if(use_filter)
        ffigure_matrix=imfilter(ffigure_matrix,h); 
    end     
    imagesc(ffigure_matrix);
    colorbar
    title(strcat('f map/ ',metadata.PatientName.FamilyName))
    clear index_f
    
    
    Dfigure_matrix=D_matrix;
    figure
    index_D=find(D_matrix>D_ub);
    Dfigure_matrix(index_D)=D_ub;
    index_D=find(D_matrix<D_lb);
    Dfigure_matrix(index_D)=D_lb;
    if(use_filter)
        Dfigure_matrix=imfilter(Dfigure_matrix,h); 
    end
    imagesc(Dfigure_matrix);
    colorbar
    title(strcat('D map/',metadata.PatientName.FamilyName))
    clear index_D
    
    
    
    D_star_figure_matrix=D_star_matrix;
    figure    
    index_D=find(D_star_figure_matrix>D_star_ub);
    D_star_figure_matrix(index_D)=0.0;
    index_D=find(D_star_figure_matrix<D_star_lb);
    D_star_figure_matrix(index_D)=0.0;
    imagesc(D_star_figure_matrix);
    colorbar
    title(strcat('D star map/',metadata.PatientName.FamilyName))
    clear index_D
    
    D_f_matrix=f_matrix.*D_star_matrix;
    figure
    index_D=find(D_f_matrix>0.005);
    D_f_matrix(index_D)=0.0;
    index_D=find(D_f_matrix<0);
    D_f_matrix(index_D)=0.0;
    imagesc(D_f_matrix);
    colorbar
    title(strcat('D star X f star map/',metadata.PatientName.FamilyName))    
end








