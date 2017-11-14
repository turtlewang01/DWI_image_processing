clc
clear
% file_path='D:\part_time_job\DWI\IVIM1\IVIM1\IM';
file_path='D:\part_time_job\DWI\IVIM1\suo\IMG';
solve_method=4; %1=Biexp, 2=LS,3=Mix,4= fix D_star?5=sove 3 variable simultaneously
d_method=2; % 1=use ADC as d,2=use LS method fitting,3=use just two points to calculate
data_source='DICOM'; % DICOM or nii;
ROI_create=0;% 1: create the ROI,0= load the ROI;
use_modify_model=0; % 1=using the modified model; 0=use the origiianal model
result_quantizer=0; % 1=quantizing the result;
opti_method='levenberg-marquardt'; % trust-region-reflective method or levenberg-marquardt method
options.Algorithm = opti_method;
use_filter=1; % 1=use filter; 0=don't use filter;
threshold_noise=15; % threshold for noise; signal value below this value is thougt to be noise


D_star_ub=50*10^(-3);
D_star_lb=0;
D_ub=2.5*10^(-3);
D_lb=0;
f_ub=0.3;
f_lb=0;
%% this section choose the DICOM image

% for(i=1:9)
%     file_seq=i;
%     file_seq_str=num2str(file_seq);
%     file_path_full=strcat(file_path,file_seq_str,'.dcm');
%     metadata = dicominfo(file_path_full);
%     z_axis_total(i)=metadata.SliceLocation;
% end
% [z_axis_new,index_i]=sort(z_axis_total);
% clear z_axis_new z_axis_total metadata file_path_full file_seq_str file_seq

for(i=1:9)   
    file_seq=i;
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

%% this section denoise the image;
% h = fspecial('gaussian',[3,3],0.2);
% for(i=1:14)
%     I(:,:,i)=imfilter(I(:,:,i),h);
% end
% I=I(40:244,45:212,:);
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




I=double(I);
[m_row,n_col]=size(I(:,:,1));
f_matrix=zeros(m_row,n_col);
D_matrix=zeros(m_row,n_col);
D_star_matrix=zeros(m_row,n_col);
Error_D_matrix=zeros(m_row,n_col);
Error_model_matrix=zeros(m_row,n_col);





num_start=5; % the 9th b number 
num_end=9; % the 13th b number
n_length=num_end-num_start+1;
b_val_nonzero=b_val(1:end-1);



for(i=1:m_row)
    for(j=1:n_col)
        if(BW(i,j)==1)
            S0=I(i,j,end);
            for(kk=1:9)
                Sb(kk)=I(i,j,kk);
            end
            Sb_nonzero=Sb(1:8);
            
            if(max(Sb_nonzero)>S0)
                Error_model_matrix(i,j)=1;
            end
            
            
            if(abs(S0)>0.3)
                Sb_normalize=Sb/S0;
            else
                Sb_normalize=zeros(1,9);
            end
            b_comp=b_val(num_start:num_end);
            Sb_normalize_comp=Sb_normalize(num_start:num_end);
            for(k=num_start:num_end)
                Sb_comp(k-num_start+1)=I(i,j,k);
            end
            
            switch solve_method
                case 1 % use biexponential method
                    if(abs(min([Sb,S0]))<threshold_noise)
                        f_matrix(i,j)=0;
                    else
                        switch d_method
                            case 1
                                D=-log(Sb_comp(end)/S0)/b_comp(end);
                            case 2
                                y_temp=log(Sb_comp/S0)';                                
                                A_temp=-b_comp';
                                D=pinv(A_temp)*y_temp;
                            case 3
                                D=-(log(Sb_comp(1)/Sb_comp(end)))/(b_comp(1)-b_comp(end)); % two points method to calculate D value
                            otherwise
                                disp('under construction!');
                        end
                        if(D_matrix(i,j)<D_lb)
                            D_matrix(i,j)=0;
                        end
                        if(D_matrix(i,j)>D_ub)
                            D_matrix(i,j)=D_ub;
                        end
                        
                        if(D<0)
                            D=0;
                            Error_D_matrix(i,j)=1;
                        end
                        D_matrix(i,j)=D;
                        if(D==0)                           
                            f_matrix(i,j)=0;
                        else
                            if(use_modify_model)
                                fun = @(x)(x(1).*exp(-(x(2)+D).*b_val)+(1-x(1)).*exp(-D.*b_val))-Sb_normalize;
                            else
                                fun = @(x)(x(1).*exp(-x(2).*b_val)+(1-x(1)).*exp(-D.*b_val))-Sb_normalize;
                            end
                            
                            x0 = [0.0025,25*D];
                            lb=[0,1.5*D];
                            ub=[0.3,0.3];
                            if(strcmp(opti_method,'trust-region-reflective'))
                                [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,lb,ub,options);
                            else
                                [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,[],[],options);
                            end
                            
                            f_matrix(i,j)=x(1);
                            D_star_matrix(i,j)=x(2);
                        end
                    end
                case 2 % use simpified method
                    if(abs(min([Sb,S0]))<threshold_noise)
                        f_matrix(i,j)=0;
                        D_matrix(i,j)=0;
                    else
                        delta=0;
                        Sb_normalize_comp_log=log(Sb_normalize_comp)-delta;
                        coef=[-b_comp',ones(num_end-num_start+1,1)];
                        temp=pinv(coef)*Sb_normalize_comp_log';
                        D_matrix(i,j)=temp(1);
                        f_matrix(i,j)=1-exp(temp(2));
                    end
                case 3 % use the LS method as the initial point
                    if(abs(min([Sb,S0]))<threshold_noise)
                        f_matrix(i,j)=0;
                        D_matrix(i,j)=0;
                    else
                        Sb_normalize_comp_log=log(Sb_normalize_comp);
                        coef=[-b_comp',ones(num_end-num_start+1,1)];
                        temp=pinv(coef)*Sb_normalize_comp_log';
                        D_matrix(i,j)=temp(1);
                        f_matrix_LS(i,j)=1-exp(temp(2));
                        
                        if(f_matrix_LS(i,j)<f_lb)
                            f_matrix_LS(i,j)=0;
                        end
                        if(f_matrix_LS(i,j)>f_ub)
                            f_matrix_LS(i,j)=0;
                        end
                        
                        if(D_matrix(i,j)<D_lb)
                            D_matrix(i,j)=0;
                        end
                        if(D_matrix(i,j)>D_ub)
                            D_matrix(i,j)=0;
                        end
                        
                        D=D_matrix(i,j);
                        lb=[f_lb,1.5*D_matrix(i,j)];
                        ub=[f_ub,D_star_ub];
                        if(use_modify_model)
                            fun = @(x)(x(1).*exp(-(x(2)+D).*b_val)+(1-x(1)).*exp(-D.*b_val))-Sb_normalize;
                        else
                            fun = @(x)(x(1).*exp(-x(2).*b_val)+(1-x(1)).*exp(-D.*b_val))-Sb_normalize;
                        end
                        
                        
                        x0 = [15*D_matrix(i,j),f_matrix_LS(i,j)];
                        if(strcmp(opti_method,'trust-region-reflective'))
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,lb,ub,options);
                        else
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,[],[],options);
                        end
                        f_matrix(i,j)=x(1);
                        D_star_matrix(i,j)=x(2);                   
                    end
                case 4 % fix the D* 
                    if(abs(min(Sb))<threshold_noise)
                        f_matrix(i,j)=0;
                    else
                        D_star_value=0.03;
                        D_star_matrix(i,j)=D_star_value;
                        if(use_modify_model)
                                fun = @(x)(x(1).*exp(-(D_star_value+x(2)).*b_val)+(1-x(1)).*exp(-x(2).*b_val))-Sb_normalize;
                            else
                                fun = @(x)(x(1).*exp(-D_star_value.*b_val)+(1-x(1)).*exp(-x(2).*b_val))-Sb_normalize;
                        end
                        
                        x0 = [0.0025,D_star_value/25];
                        lb=[0,0];
                        ub=[0.3,D_star_value/1.5];
                        if(strcmp(opti_method,'trust-region-reflective'))
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,lb,ub,options);
                        else
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,[],[],options);
                        end
                        
                        f_matrix(i,j)=x(1);
                        D_matrix(i,j)=x(2);
                    end
                case 5 % solve the three parameters simultanoeusly
                    if(abs(min([Sb,S0]))<threshold_noise)
                        f_matrix(i,j)=0;
                    else
                        fun = @(x)(x(1).*exp(-x(2).*b_val)+(1-x(1)).*exp(-x(3).*b_val))-Sb_normalize;
                        x0 = [0.0025,0.005,0.005];
                        lb=[0,0,0];
                        ub=[0.3,0.3,0.05];
                        if(strcmp(opti_method,'trust-region-reflective'))
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,lb,ub,options);
                        else
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,[],[],options);
                        end
                        
                        f_matrix(i,j)=x(1);
                        D_star_matrix(i,j)=x(2);
                        D_matrix(i,j)=x(3);
                    end                
                otherwise
                    warning('under construction!')
            end
        end
    end
end

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








