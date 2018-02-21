function outdata=results_postproc(indata,result_quantizer,var_bound)
f_matrix=indata.f;
D_matrix=indata.D;
D_star_matrix=indata.D_star;

if(result_quantizer)
    ffigure_matrix=f_matrix;    
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