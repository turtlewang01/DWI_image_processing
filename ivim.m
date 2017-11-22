function outdata=ivim(I,b_val,option);

[m_row,n_col]=size(I(:,:,1));
f_matrix=zeros(m_row,n_col);
D_matrix=zeros(m_row,n_col);
D_star_matrix=zeros(m_row,n_col);
Error_D_matrix=zeros(m_row,n_col);
Error_model_matrix=zeros(m_row,n_col);

num_b=length(b_val);

BW=option.BW;
num_start=option.num_start;
num_end=option.num_end;
solve_method=option.solve_method;
d_method=option.d_method;
use_modify_model=option.use_modify_model;
opti_method=option.opti_method;

threshold_noise=option.threshold_noise;
D_star_ub=option.D_star_ub;
D_star_lb=option.D_star_lb;
D_ub=option.D_ub;
D_lb=option.D_lb;
f_ub=option.f_ub;
f_lb=option.f_lb;



NLS_options.Algorithm = opti_method;

for(i=1:m_row)
    for(j=1:n_col)
        if(BW(i,j)==1)
            S0=I(i,j,num_b);
            for(kk=1:num_b)
                Sb(kk)=I(i,j,kk);
            end
            Sb_nonzero=Sb(1:num_b-1);
            
            if(max(Sb_nonzero)>S0)
                Error_model_matrix(i,j)=1;
            end
            
            
            if(abs(S0)>0.3)
                Sb_normalize=Sb/S0;
            else
                Sb_normalize=zeros(1,num_b);
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
                                A_temp=[-b_comp',ones(length(y_temp),1)];
                                temp=pinv(A_temp)*y_temp;
                                D=temp(1);
                                clear temp
                            case 3
                                D=-(log(Sb_comp(1)/Sb_comp(end)))/(b_comp(1)-b_comp(end)); % two points method to calculate D value
                            case 4 %there is some bugs with this case
                                y_temp=log(Sb_comp)';
                                A_temp=[-b_comp',ones(length(y_temp),1)];
                                temp=pinv(A_temp)*y_temp;
                                D=temp(1);
                                clear temp
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
                                [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,lb,ub,NLS_options);
                            else
                                [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(fun,x0,[],[],NLS_options);
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

outdata.D=D_matrix;
outdata.f=f_matrix;
outdata.D_star=D_star_matrix;