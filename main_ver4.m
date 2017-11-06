clc
clear
% file_path='D:\part_time_job\DWI\IVIM1\IVIM1\IM';
file_path='D:\part_time_job\DWI\IVIM1\PENG_XIAOYAN\IM';
solve_method=1; %1=Biexp, 2=LS,3=Mix,4= fix D_star?5=sove 3 variable simultaneously
d_method=1; % 1=use ADC as d,2=use LS method fitting
data_source='DICOM'; % DICOM or nii;
opti_method='trust-region-reflective'; % trust-region-reflective method or levenberg-marquardt method
ROI_create=0;% 1: create the ROI,0= load the ROI;
options.Algorithm = opti_method;

%% this section choose the DICOM image
if(strcmp(data_source,'DICOM'))
    for(i=1:238)
        file_seq=i-1;
        file_seq_str=num2str(file_seq);
        file_path_full=strcat(file_path,file_seq_str);
        metadata = dicominfo(file_path_full);
        z_axis_total(i)=metadata.SliceLocation;
    end    
    [z_axis_new,index_i]=sort(z_axis_total);
    clear z_axis_new z_axis_total metadata file_path_full file_seq_str file_seq
    
    for(i=1:14)
        %     file_seq=(i-1)*17+8;
        file_seq=index_i(9*14+i)-1;
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
    file_path='D:\part_time_job\DWI\IVIM1\pengxiaoyan_nii\pengxiaoyan.nii';
    nii = load_nii(file_path);
    D=nii.img;    
    for(i=1:14)
        I(:,:,i)=D(:,:,8,i);
    end   
    clear D nii;
    I= rot90(I);
    b_val=[10,20,30,40,50,80,100,150,200,400,600,800,1000,0];
%     b_val=[10,20,30,40,50,80,120,150,200,400,700,800,1000,0];
end
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





num_start=9;
num_end=13;
n_length=num_end-num_start+1;
b_val_nonzero=b_val(1:end-1);



for(i=1:m_row)
    for(j=1:n_col)
        if(BW(i,j)==1)
            S0=I(i,j,14);
            for(kk=1:14)
                Sb(kk)=I(i,j,kk);
            end
            Sb_nonzero=Sb(1:13);
            
            if(max(Sb_nonzero)>S0)
                Error_model_matrix(i,j)=1;
            end
            
            
            if(abs(S0)>0.3)
                Sb_normalize=Sb/S0;
            else
                Sb_normalize=zeros(1,14);
            end
            b_comp=b_val(num_start:num_end);
            Sb_normalize_comp=Sb_normalize(num_start:num_end);
            for(k=num_start:num_end)
                Sb_comp(k-num_start+1)=I(i,j,k);
            end
            
            switch solve_method
                case 1
                    if(abs(min([Sb,S0]))<5)
                        f_matrix(i,j)=0;
                    else
                        switch d_method
                            case 1
                                D=-log(Sb_comp(end)/S0)/b_comp(end);
                            case 2
                                y_temp=log(Sb_comp/S0)';
                                A_temp=-b_comp';
                                D=pinv(A_temp)*y_temp;
                            otherwise
                                disp('under construction!');
                        end
                        
                        if(D<0)
                            D=0;
                            Error_D_matrix(i,j)=1;
                        end
                        D_matrix(i,j)=D;
                        if(D==0)
                            %                         f_matrix(i,j)=1-Sb_comp(end)/S0;
                            f_matrix(i,j)=0;
                        else
                            fun = @(x)(x(1).*exp(-x(2).*b_val)+(1-x(1)).*exp(-D.*b_val))-Sb_normalize;
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
                case 2
                    if(abs(min([Sb,S0]))<1)
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
                case 3
                    if(abs(min([Sb,S0]))<5)
                        f_matrix(i,j)=0;
                        D_matrix(i,j)=0;
                    else
                        D=-log(Sb_comp(end)/S0)/b_comp(end);
                        D_matrix(i,j)=D;
                        if(D==0)
                            f_matrix(i,j)=1-Sb_comp(end)/S0;
                        else
                            Sb_normalize_comp_log=log(Sb_normalize_comp);
                            coef=[-b_comp',ones(num_end-num_start+1,1)];
                            temp=pinv(coef)*Sb_normalize_comp_log';
                            D_matrix(i,j)=temp(1);
                            f_matrix(i,j)=1-exp(temp(2));
                            
                            lb=[0,1.5*D];
                            ub=[0.25,0.3];
                            fun = @(x)(x(1).*exp(-x(2).*b_val)+(1-x(1)).*exp(-D.*b_val))-Sb_normalize;
                            x0 = [15*D_matrix(i,j),f_matrix(i,j)];
                            
                            if(strcmp(opti_method,'trust-region-reflective'))
                                [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,lb,ub,options);
                            else
                                [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,[],[],options);
                            end
                            f_matrix(i,j)=x(1);
                            D_star_matrix(i,j)=x(2);
                        end
                    end
                case 4
                    if(abs(min(Sb))<5)
                        f_matrix(i,j)=0;
                    else
                        D_star_value=0.02;
                        D_star_matrix(i,j)=D_star_value;
                        fun = @(x)(x(1).*exp(-D_star_value.*b_val)+(1-x(1)).*exp(-x(2).*b_val))-Sb_normalize;
                        x0 = [0.0025,D_star_value/25];
                        lb=[0,0];
                        ub=[0.05,D_star_value/1.5];
                        if(strcmp(opti_method,'trust-region-reflective'))
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,lb,ub,options);
                        else
                            [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,[],[],options);
                        end
                        
                        f_matrix(i,j)=x(1);
                        D_matrix(i,j)=x(2);
                    end
                case 5
                    if(abs(min([Sb,S0]))<5)
                        f_matrix(i,j)=0;
                    else
                        fun = @(x)(x(1).*exp(-x(2).*b_val)+(1-x(1)).*exp(-x(3).*b_val))-Sb_normalize;
                        x0 = [0.0025,0.005,0.005];
                        lb=[0,0,0];
                        ub=[0.05,0.3,0.05];
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
                    warning('Unexpected plot type. No plot created.')
            end
        end
    end
end


%% post-processing %%
ffigure_matrix=f_matrix;
figure
index_f=find(f_matrix>0.3);
ffigure_matrix(index_f)=0.0;
index_f=find(f_matrix<0);
ffigure_matrix(index_f)=0.0;
imagesc(ffigure_matrix);
colorbar
title(strcat('f map/ ',metadata.PatientName.FamilyName))


Dfigure_matrix=D_matrix;
figure
index_D=find(D_matrix>0.005);
Dfigure_matrix(index_D)=0.0;
index_D=find(D_matrix<0);
Dfigure_matrix(index_D)=0.0;
imagesc(Dfigure_matrix);
colorbar
title(strcat('D map/',metadata.PatientName.FamilyName))






% figure
% K_f=4000/max(max(f_matrix));
% F_matrix=uint16(K_f*f_matrix);
% imagesc(F_matrix);
% colorbar
% title('f map')
% 
% figure
% F1_matrix=K_f*f_matrix;
% index=find(F1_matrix>3500);
% F1_matrix(index)=0;
% F1_matrix=uint16(F1_matrix);
% imagesc(F1_matrix);
% colorbar
% title('f post-processing map')
% 
% figure
% index_f=find(f_matrix>0.4);
% f_matrix(index_f)=0.0;
% index_f=find(f_matrix<0);
% f_matrix(index_f)=0.0;
% 
% K_f=65535/max(max(f_matrix));
% F_matrix=uint16(K_f*f_matrix);
% imagesc(F_matrix);
% colorbar
% title('f post-processing map2')
% 
% figure
% K_D=4000/max(max(D_matrix));
% D_matrix_bold=uint16(K_D*D_matrix);
% imagesc(D_matrix_bold);
% colorbar
% title('D map')


% figure
% K_D_star=4000/max(max(D_star_matrix));
% D_matrix_star_bold=uint16(K_D_star*D_star_matrix);
% imagesc(D_matrix_star_bold);
% colorbar
% 
% 
% 
% 
% I1=dicomread('D:\part_time_job\DWI\IVIM1\IVIM1\IM0');  
% metadata1 = dicominfo('D:\part_time_job\DWI\IVIM1\IVIM1\IM0');
% imagesc(I1);
% colorbar
% 
% I2=dicomread('D:\part_time_job\DWI\IVIM1\IVIM1\IM17');  
% metadata2 = dicominfo('D:\part_time_job\DWI\IVIM1\IVIM1\IM17');
% figure
% imagesc(I2);
% 
% metadata1.SliceLocation
% metadata2.SliceLocation
% z_location=[];
% z_location=metadata1.SliceLocation;