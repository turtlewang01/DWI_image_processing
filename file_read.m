function [I,b_val,metadata]=file_read(file_type,file_path,file_name,num_analysis,image_opt);
num_b=image_opt.numb;
patient_name=image_opt.patient_name;
b_val=image_opt.bval;
num_image=image_opt.num_image;
if(strcmp(file_type,'DICOM'))
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
    file_path=strcat(file_path,file_name);
%     file_path_new='D:\part_time_job\DWI\IVIM1\cyw_nii\cyw_new.nii';
    metadata.PatientName.FamilyName=patient_name;
%     reslice_nii(file_path, file_path);
    nii = load_nii(file_path);
    D=nii.img;
    [metadata.Height,metadata.Width,num_slice,num_b]=size(D);
    num_image=num_slice*num_b; %number of images        
    for(i=1:num_b)
        I(:,:,i)=D(:,:,num_analysis,i);
    end   
    clear D nii;
    I= rot90(I);
%     b_val=[10,20,30,40,50,80,100,150,200,400,600,800,1000,0]; %
%     b_val=[10,20,30,40,50,80,100,150,200,400,600,800,1000,0];
%     b_val=[10,20,30,40,50,80,120,150,200,400,700,800,1000,0];
%     b_val=[10,20,30,40,50,80,120,150,200,400,600,800,1000,0]; % for guiqing
%     b_val=[400 600 1000];
end