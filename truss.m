

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Luis Saucedo Mora, 2020,  ETSIAE UPM             
%--------------------------------------------------------------

clc
clear all % clear memory
tic       % starts a stopwatch timer

magni_coef=100.0;
%magni_flechas=500;
magni_flechas=50;%otro
ratio_plot=3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            PREPROCESADO             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% NODOS ---------------------------

% nodes coordinates  %%%% CAMBIAR   1.-
%ALA
%nod_coor=[0 0;0 500;1500 0;1500 250; 6000 0; 1000 125; 2000 110; 2500 0; 2500 140; 3000 80; 3500 0; 3500 140 ];
%CERCHA
%nod_coor=[0 0; 500 0; 1000 0; 1500 0; 2000 0; 2500 0; 3000 0; 0 500; 500 500; 1000 500; 1500 500; 2000 500; 2500 500; 3000 500]
%OTRo
nod_coor=[ 0   50.0; 0   -50.0; 30   70.45; 30   -29.55; 60   61.14; 60   -38.86; 90   61.49; 90   -38.51; 120   61.44; 120   -38.56; 150   34.82; 150   -65.18; 180   27.58; 180   -72.42; 210   43.45; 210   -56.55; 240   42.38; 240   -57.62; 270   51.34; 270   -48.66; 300   75.1; 300   -24.9; 330   66.53; 330   -33.47; 360   49.27; 360   -50.73; 390   51.11; 390   -48.89; 420   36.6; 420   -63.4; 450   23.69; 450   -76.31; 480   45.3; 480   -54.7; 510   58.05; 510   -41.95; 540   55.54; 540   -44.46; 570   70.55; 570   -29.45] 
%number of nodes
num_nod=size(nod_coor,1);


%%%% ELEMENTOS -----------------------

% elements nodes    %%%% CAMBIAR    2.-
%ALA
%ele_nod=[1 2;1 3;2 6; 6 3;2 4;1 6; 6 4;3 4; 3 7; 4 7; 7 9; 7 8; 8 9; 3 8; 4 9; 8 10; 9 10; 10 11; 10 12; 8 11; 9 12; 11 12; 11 5; 12 5];
%CERCHA
%ele_nod=[1 2; 2 3; 3 4; 4 5; 5 6; 6 7; 8 9; 9 10; 10 11; 11 12; 12 13; 13 14; 1 8; 2 9; 3 10; 4 11; 5 12; 6 13; 7 14; 1 9; 2 10; 3 11; 4 12; 5 13; 6 14]
ele_nod=[ 1   2; 1   3; 2   4; 1   4; 2   3; 3   4; 3   5; 4   6; 3   6; 4   5; 5   6; 5   7; 6   8; 5   8; 6   7; 7   8; 7   9; 8   10; 7   10; 8   9; 9   10; 9   11; 10   12; 9   12; 10   11; 11   12; 11   13; 12   14; 11   14; 12   13; 13   14; 13   15; 14   16; 13   16; 14   15; 15   16; 15   17; 16   18; 15   18; 16   17; 17   18; 17   19; 18   20; 17   20; 18   19; 19   20; 19   21; 20   22; 19   22; 20   21; 21   22; 21   23; 22   24; 21   24; 22   23; 23   24; 23   25; 24   26; 23   26; 24   25; 25   26; 25   27; 26   28; 25   28; 26   27; 27   28; 27   29; 28   30; 27   30; 28   29; 29   30; 29   31; 30   32; 29   32; 30   31; 31   32; 31   33; 32   34; 31   34; 32   33; 33   34; 33   35; 34   36; 33   36; 34   35; 35   36; 35   37; 36   38; 35   38; 36   37; 37   38; 37   39; 38   40; 37   40; 38   39] 
%number of elements
num_ele=size(ele_nod,1);

% elements degree of freedom (DOF) 
ele_dof=zeros(num_ele,4);
for e=1:num_ele
    for i=1:2
        ele_dof(e,(i-1)*2+1)=(ele_nod(e,i)-1)*2+1
        ele_dof(e,(i-1)*2+2)=(ele_nod(e,i)-1)*2+2
    end
end


%%%% PROPIEDADES --------------------

% A, E, L are cross sectional area, Young's modulus, length of elements,respectively.

%%%% CAMBIAR  3.-

for e=1:num_ele
    A(e)=3*10^(3);
end

%%%% CAMBIAR   4.-

for e=1:num_ele
    E(e)=200*10^3;
end


% initial zero matrix for all matrices
displacement=zeros(2*num_nod,1);
force=zeros(2*num_nod,1);
stiffness=zeros(2*num_nod);



%%%% CONDICIONES DE CONTORNO ----------

%%%% CAMBIAR   5.-

%applied loads at DOFs
for e=1:num_nod*2
    force(e)=0.0;
end
%ALA
%{
%%% CARGA 1
force(5)=100000.0;
force(6)=-100000.0;

%%% CARGA 2
Loadwind=100.0;
force(6)=force(6)+Loadwind;
force(16)=force(16)+Loadwind;
force(22)=force(22)+Loadwind;
force(10)=force(10)+3*Loadwind;

force_ini=force;
%Boundary conditions
displacement (1,1)=0.0;
displacement (2,1)=0.0;
displacement (3,1)=0.0;

%%%% CAMBIAR  6.-
% Desplazamientos con restriccion
known_dis_a=[1;2;3];
%}
%CERCHA
%{
% CERCHA

force(6)=-100000.0;

force_ini=force;
%Boundary conditions
displacement (1,1)=0.0;
displacement (2,1)=0.0;
displacement (13,1)=0.0;
displacement (14,1)=0.0;

%%%% CAMBIAR  6.-
% Desplazamientos con restriccion
known_dis_a=[1;2;13;14];

% Fuerzas sin restriccion (son todos los indices menos los de known_dis_a
for e=1:num_nod*2
    known_f_a(e)=e;
end

for i=1:length(known_dis_a)
    known_f_a(known_f_a==known_dis_a(i))=[];
end

known_f_a = reshape(known_f_a,length(known_f_a),1);
%}
%OTRO
%%{
% OTRO

force(42)=-1000000.0;

force_ini=force;
%Boundary conditions
displacement (1,1)=0.0;
displacement (2,1)=0.0;
displacement (3,1)=0.0;
displacement (4,1)=0.0;
displacement (79,1)=0.0;
displacement (80,1)=0.0;
displacement (77,1)=0.0;
displacement (78,1)=0.0;

%%%% CAMBIAR  6.-
% Desplazamientos con restriccion
known_dis_a=[1;2;3;4;77;78;79;80];
%}


% Fuerzas sin restriccion (son todos los indices menos los de known_dis_a
for e=1:num_nod*2
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
 k=(A(e)*E(e)/L(e)*[C*C C*S -C*C -C*S;C*S S*S -C*S -S*S;...
   -C*C -C*S C*C C*S; -C*S -S*S C*S S*S]);
   
    % extract the rows of ele_dof (for each element e)
    ele_dof_vec=ele_dof(e,:);
    for i=1:4
        for j=1:4
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
 stress(e)=(E(e)/L(e))*[-C -S C S]*displacement((ele_dof(e,:))');
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
    k=k+1;
    nod_coor_def(i,j)=nod_coor(i,j)+magni_coef*displacement(k,1);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            POSTPROCESADO            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Plot_results_truss(force_ini, displacement, num_ele, force, A, E, nod_coor_def, num_nod, L, magni_flechas, stress, ratio_plot, nod_coor, ele_nod);

toc
