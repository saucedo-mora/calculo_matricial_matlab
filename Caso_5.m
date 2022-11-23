function [force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_5(L_refine)
        % CASO 2
        
        
    %%%% NODOS ---------------------------
    
    % nodes coordinates  %%%% CAMBIAR   1.-
    % 1 % 
    nod_coor=[0 0;200 500; 1000 1000; 1500 0];
    
    %%%% ELEMENTOS -----------------------
    
    % elements nodes    %%%% CAMBIAR    2.-
    % 1 % 
    ele_nod_pre=[1 2; 2 3; 3 4];
    % 2 % 
    %ele_nod_pre=[1 2; 2 3; 3 4; 5 6; 6 7; 7 8; 2 6; 3 7; 4 8];
    %number of elements
    num_ele_pre=size(ele_nod_pre,1);
    
    ele_nod=[]
    %%%% Refinado %%%   
    for e=1:num_ele_pre
        L(e)=sqrt((nod_coor(ele_nod_pre(e,2),1)-nod_coor(ele_nod_pre(e,1),1))^2+...
          (nod_coor(ele_nod_pre(e,2),2)-nod_coor(ele_nod_pre(e,1),2))^2);
        index_aux=floor(L(e)/L_refine);
        if index_aux-1<1
            ele_nod=[ele_nod; ele_nod_pre(e,2) ele_nod_pre(e,1)]
        else
           for i=1:index_aux-1
               xloc=((index_aux-i)/(index_aux))*nod_coor(ele_nod_pre(e,1),1)+((i)/(index_aux))*nod_coor(ele_nod_pre(e,2),1)
               yloc=((index_aux-i)/(index_aux))*nod_coor(ele_nod_pre(e,1),2)+((i)/(index_aux))*nod_coor(ele_nod_pre(e,2),2)
               nod_coor=[nod_coor; xloc yloc]
               if i==1
                   ele_nod=[ele_nod; ele_nod_pre(e,1) length(nod_coor)];
               else
                   if i==index_aux-1
                       ele_nod=[ele_nod; length(nod_coor) ele_nod_pre(e,2)];
                       ele_nod=[ele_nod; length(nod_coor) length(nod_coor)-1];
                   else
                       ele_nod=[ele_nod; length(nod_coor) length(nod_coor)-1];
                   end
               end
           end
        end  
    end
    
    %number of nodes
    num_nod=size(nod_coor,1);
    %number of elements
    num_ele=size(ele_nod,1);
    
    % elements degree of freedom (DOF) 
    ele_dof=zeros(num_ele,6);
    for e=1:num_ele
        for i=1:2
            ele_dof(e,(i-1)*3+1)=(ele_nod(e,i)-1)*3+1;
            ele_dof(e,(i-1)*3+2)=(ele_nod(e,i)-1)*3+2;
            ele_dof(e,(i-1)*3+3)=(ele_nod(e,i)-1)*3+3;
        end
    end
    
    %%%% PROPIEDADES --------------------
    
    % A, E, L are cross sectional area, Young's modulus, length of elements,respectively.
    % Datos IPN 100
    
    %%%% CAMBIAR  3.-
    for e=1:num_ele
        A(e)=1056;
    end
    
    %%%% CAMBIAR   4.-
    for e=1:num_ele
        E(e)=200*10^3;
    end
    
    % INERCIA
    for e=1:num_ele
        I(e)=1.71*10^6;
    end
    
    % initial zero matrix for all matrices
    displacement=zeros(3*num_nod,1);
    force=zeros(3*num_nod,1);
    stiffness=zeros(3*num_nod);
    
    %%%% CONDICIONES DE CONTORNO ----------
    
    %%%% CAMBIAR   5.-
    for e=1:num_nod*3
        force(e)=0.0;
    end
    %applied loads at DOFs
    %%% CARGA 1
    force(6)=100000000.0;
    
    force_ini=force;
    %Boundary conditions
    displacement (1,1)=0.0;
    displacement (2,1)=0.0;
    displacement (3,1)=0.0;
    
    displacement (10,1)=0.0;
    displacement (11,1)=0.0;
    displacement (12,1)=0.0;
    
    %%%% CAMBIAR  6.-
    % Desplazamientos con restriccion
    known_dis_a=[1;2;3;10;11;12];

end