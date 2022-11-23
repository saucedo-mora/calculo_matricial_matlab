
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Luis Saucedo Mora, 2020, ETSIAE, UPM

clc
clear all % clear memory
tic       % starts a stopwatch timer

magni_coef=20.0;
magni_flechas=800;
ratio_plot=1;
L_refine=100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            PREPROCESADO             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% CASOS %%%%%%%%%%%%%%%%%%%%%%%

% CASO 1
% en este caso hay rigidizador, carga vertical, 3 3 cargas laterales y dos
% momentos superiores
%[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_1(L_refine);

% CASO 2
% portico solo el marco y viga horizontal, biempotrado
%[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_2(L_refine);

% CASO 3
% viga vertical con fuerza horizontal
%[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_3(L_refine);

% CASO 4
% viga vertical con momento
%[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_4(L_refine);

% CASO 5
% portico asimetrico simple con momento
%[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_5(L_refine);

% CASO 6
% portico problema trabajo
%[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_6(L_refine);

% CASO 7
% Tres barras
%[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_7(L_refine);

% CASO 8
% barra empotrada y apoyada
[force_ini, displacement, num_ele, stiffness, force, A, E, ele_dof, I, num_nod, L, known_dis_a, e, nod_coor, i, ele_nod] = Caso_8(L_refine);

%%%%%%%%%%%%%%%%%%%%%%%%% CASOS %%%%%%%%%%%%%%%%%%%%%%%



% CAMBIAR  6.-

% Fuerzas sin restriccion (son todos los indices menos los de known_dis_a
for e=1:num_nod*3
    known_f_a(e)=e;
end

for i=1:length(known_dis_a)
    known_f_a(known_f_a==known_dis_a(i))=[];
end

known_f_a = reshape(known_f_a,length(known_f_a),1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              PROCESADO              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% RIGIDEZ LOCAL Y ENSAMBLAJE -------

% computation of the system stiffness matrix
for e=1:num_ele
 L(e)=sqrt((nod_coor(ele_nod(e,2),1)-nod_coor(ele_nod(e,1),1))^2+...
      (nod_coor(ele_nod(e,2),2)-nod_coor(ele_nod(e,1),2))^2);
 C=(nod_coor(ele_nod(e,2),1)-nod_coor(ele_nod(e,1),1))/L(e);
 S=(nod_coor(ele_nod(e,2),2)-nod_coor(ele_nod(e,1),2))/L(e);
 T1=A(e)*E(e)/L(e); % axil
 T2=12*E(e)*I(e)/(L(e)^3); % flector disp cortante
 T3=6*E(e)*I(e)/(L(e)^2); % flector giro
 
 k=[C*C*T1+S*S*T2 C*S*(T1-T2) -S*T3 -C*C*T1-S*S*T2 -C*S*(T1-T2) -S*T3;...
     C*S*(T1-T2) C*C*T2+S*S*T1 C*T3 -C*S*(T1-T2) -S*S*T1-C*C*T2  C*T3;...
     -S*T3   C*T3 (4/6)*L(e)*T3  S*T3  -C*T3  (2/6)*L(e)*T3;...
   -C*C*T1-S*S*T2 -C*S*(T1-T2) S*T3  C*C*T1+S*S*T2 C*S*(T1-T2) S*T3;...
   -C*S*(T1-T2) -S*S*T1-C*C*T2 -C*T3 C*S*(T1-T2) S*S*T1+C*C*T2  -C*T3;...
   -S*T3  C*T3   (2/6)*L(e)*T3  S*T3  -C*T3  (4/6)*L(e)*T3];
   
    % extract the rows of ele_dof (for each element e)
    ele_dof_vec=ele_dof(e,:);
   
    for i=1:6
        for j=1:6
    
             stiffness(ele_dof_vec(1,i),ele_dof_vec(1,j))=...
             stiffness(ele_dof_vec(1,i),ele_dof_vec(1,j))+k(i,j);
        end
    end
end

%%%% APLICAR CONDICIONES DE CONTORNO -------

for i=1:size(known_f_a,1)
   dis_new(i,1)=displacement(known_f_a(i,1),1);
   force_new(i,1)=force(known_f_a(i,1),1);
end
for i=1:size(known_f_a,1)
    for j=1:size(known_f_a,1)
    stiff_new(i,j)=stiffness(known_f_a(i,1),known_f_a(j,1));
end
end


%%%% SOLVER u=F/k ------------

% solving the partitioned matrix 
dis_new=stiff_new\force_new;
for i=1:size(known_f_a,1)
  displacement(known_f_a(i,1),1)=dis_new(i,1);
end


%%%% OBTENER REACCIONES -------

for i=1:size(known_dis_a,1)
    force(known_dis_a(i,1),1)=stiffness(known_dis_a(i,1),:)...
    *displacement;
end


%%%% OBTENER TENSIONES -------

% stress in elements
for e=1:num_ele
 L(e)=sqrt((nod_coor(ele_nod(e,2),1)-nod_coor(ele_nod(e,1),1))^2+...
      (nod_coor(ele_nod(e,2),2)-nod_coor(ele_nod(e,1),2))^2);
 C=(nod_coor(ele_nod(e,2),1)-nod_coor(ele_nod(e,1),1))/L(e);
 S=(nod_coor(ele_nod(e,2),2)-nod_coor(ele_nod(e,1),2))/L(e);
 stress(e)=(E(e)/L(e))*[-C -S 0 C S 0]*displacement((ele_dof(e,:))'); % solo axil
end


%%%% RESULTADOS -------

disp('stiffness')
stiffness
disp('displacement')
displacement
disp('force')
force
disp('stress')
stress


%%%% ACTUALIZAR POSICIONES -------

k=0;
for i=1:num_nod
    for j=1:2
        k=(i-1)*3+j;
        nod_coor_def(i,j)=nod_coor(i,j)+magni_coef*displacement(k,1);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            POSTPROCESADO            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Plot_results(force_ini, displacement, num_ele, force, A, E, nod_coor_def, I, num_nod, L, magni_flechas, stress, ratio_plot, nod_coor, ele_nod);

toc
