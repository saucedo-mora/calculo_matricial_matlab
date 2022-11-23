function Plot_results_truss(force_ini, displacement, num_ele, force, A, E, nod_coor_def, num_nod, L, magni_flechas, stress, ratio_plot, nod_coor, ele_nod)
    %figure
    %subplot(2,1,1);
    figure('NumberTitle', 'off', 'Name', 'Tensiones axiles');
    % undeformed truss plot
    for e=1:num_ele
        x=[nod_coor(ele_nod(e,1),1) nod_coor(ele_nod(e,2),1)];
        y=[nod_coor(ele_nod(e,1),2) nod_coor(ele_nod(e,2),2)];
        p1=plot(x,y,'--k','LineWidth',2)
        p1.Color(4) = 0.5;
        pbaspect([ratio_plot 1 1])
        hold on
    end
    
    % deformed truss plot
    strmax=-1000000000.0;
    strmin=10000000000.0;
    for e=1:num_ele
        valstr=stress(e);
        if valstr>strmax
            strmax=valstr;
        end
        if valstr<strmin
            strmin=valstr;
        end
        
    end
    
    cmap = jet(100);
    
    for e=1:num_ele
        valstr=stress(e);
        if (strmax-strmin)>0
            indcolor=floor(99-98*(strmax-valstr)/(strmax-strmin))+1;
        else
            indcolor=50;
        end
        
        x=[nod_coor_def(ele_nod(e,1),1) nod_coor_def(ele_nod(e,2),1)];
        y=[nod_coor_def(ele_nod(e,1),2) nod_coor_def(ele_nod(e,2),2)];
        p2=plot(x,y,'color',cmap(indcolor,:),'LineWidth',5)
        p2.Color(4) = 0.75;
        %mycolormap2 = customcolormap([0 .25 .5 .75 1], {'#9d0142','#f66e45','#ffffbb','#65c0ae','#5e4f9f'});
    
        hold on
    end
    
    %pintar flechas de fuerzas
    maxforce=0;
    for e=1:num_nod
        if abs(force(e))>maxforce
            maxforce=abs(force(e));
        end
    end
    for e=1:num_nod
        prefx=nod_coor_def(e,1);
        prefy=nod_coor_def(e,2);
        if ((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5>0
            indsize=((((force_ini((e-1)*2+1)^2)+(force_ini((e-1)*2+2))^2)^0.5)/maxforce)^0.25;
            q=quiver(prefx,prefy, force_ini((e-1)*2+1)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,force_ini((e-1)*2+2)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15);
            q.Color = 'k';
        end
    end
    
    %pintar reaccion
    freact=force-force_ini;
    for e=1:num_nod
        prefx=nod_coor_def(e,1);
        prefy=nod_coor_def(e,2);
        if ((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5 >0
            indsize=((((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5)/maxforce)^0.25;
            q=quiver(prefx,prefy, freact((e-1)*2+1)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,freact((e-1)*2+2)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15);
            q.Color ='r'; %[0.75, 0, 0.75];
           % text(prefx,prefy,num2str(((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,1),'FontSize',15)
        end
    end
    
    % TODO meter flechas moradas con el peso propio
    
    colormap(cmap)
    char1=num2str(strmin+0*(strmax-strmin),1);
    char2=num2str(strmin+0.25*(strmax-strmin),1);
    char3=num2str(strmin+0.5*(strmax-strmin),1);
    char4=num2str(strmin+0.75*(strmax-strmin),1);
    char5=num2str(strmin+1*(strmax-strmin),1);
    c = colorbar('southoutside','Ticks', [0, 0.25, 0.5, 0.75, 1],'TickLabels',{char1, char2, char3, char4, char5});
    c.Label.String = 'TensiÃ³n axil (MPa)';
    c.FontSize = 10; 
    
    hold off
    
    figure('NumberTitle', 'off', 'Name', 'Desplazamientos x');
    % undeformed truss plot
    for e=1:num_ele
        x=[nod_coor(ele_nod(e,1),1) nod_coor(ele_nod(e,2),1)];
        y=[nod_coor(ele_nod(e,1),2) nod_coor(ele_nod(e,2),2)];
        p1=plot(x,y,'--k','LineWidth',2)
        p1.Color(4) = 0.5;
        pbaspect([ratio_plot 1 1]);
        hold on
    end
    
    displa_elx=zeros(num_ele,1);
    for e=1:num_ele
        displa_elx(e,1)=0.5*displacement((ele_nod(e,1)-1)*2+1,1)+0.5*displacement((ele_nod(e,2)-1)*2+1,1);
    end
    
    % deformed truss plot
    dispmax=-1000000000.0;
    dispmin=10000000000.0;
    for e=1:num_ele
        valdisp=displa_elx(e);
        if valdisp>dispmax
            dispmax=valdisp;
        end
        if valdisp<dispmin
            dispmin=valdisp;
        end
        
    end
    
    cmap = jet(100);
    
    for e=1:num_ele
        valdisp=displa_elx(e);
        if (dispmax-dispmin)>0
            indcolor=floor(99-98*(dispmax-valdisp)/(dispmax-dispmin))+1;
        else
            indcolor=50;
        end
        
        x=[nod_coor_def(ele_nod(e,1),1) nod_coor_def(ele_nod(e,2),1)];
        y=[nod_coor_def(ele_nod(e,1),2) nod_coor_def(ele_nod(e,2),2)];
        p2=plot(x,y,'color',cmap(indcolor,:),'LineWidth',5)
        p2.Color(4) = 0.75;
        %mycolormap2 = customcolormap([0 .25 .5 .75 1], {'#9d0142','#f66e45','#ffffbb','#65c0ae','#5e4f9f'});
    
        hold on
    end
    
    %pintar flechas de fuerzas
    maxforce=0;
    for e=1:num_nod
        if abs(force(e))>maxforce
            maxforce=abs(force(e));
        end
    end
    for e=1:num_nod
        prefx=nod_coor_def(e,1);
        prefy=nod_coor_def(e,2);
        if ((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5>0
            indsize=((((force_ini((e-1)*2+1)^2)+(force_ini((e-1)*2+2))^2)^0.5)/maxforce)^0.25;
            q=quiver(prefx,prefy, force_ini((e-1)*2+1)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,force_ini((e-1)*2+2)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15);
            q.Color = 'k';
        end
    end
    
    %pintar reaccion
    freact=force-force_ini;
    for e=1:num_nod
        prefx=nod_coor_def(e,1);
        prefy=nod_coor_def(e,2);
        if ((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5 >0
            indsize=((((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5)/maxforce)^0.25;
            q=quiver(prefx,prefy, freact((e-1)*2+1)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,freact((e-1)*2+2)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15);
            q.Color ='r' ; %[0.75, 0, 0.75];
           % text(prefx,prefy,num2str(((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,1),'FontSize',15)
        end
    end
    
    % TODO meter flechas moradas con el peso propio
    
    colormap(cmap)
    char1=num2str(dispmin+0*(dispmax-dispmin),1);
    char2=num2str(dispmin+0.25*(dispmax-dispmin),1);
    char3=num2str(dispmin+0.5*(dispmax-dispmin),1);
    char4=num2str(dispmin+0.75*(dispmax-dispmin),1);
    char5=num2str(dispmin+1*(dispmax-dispmin),1);
    c = colorbar('southoutside','Ticks', [0, 0.25, 0.5, 0.75, 1],'TickLabels',{char1, char2, char3, char4, char5});
    c.Label.String = 'Desplazamientos x (mm)';
    c.FontSize = 10; 
    
    hold off
    
    %figure('NumberTitle', 'off', 'Name', 'Tensiones');
    
    figure('NumberTitle', 'off', 'Name', 'Desplazamientos y');
    % undeformed truss plot
    for e=1:num_ele
        x=[nod_coor(ele_nod(e,1),1) nod_coor(ele_nod(e,2),1)];
        y=[nod_coor(ele_nod(e,1),2) nod_coor(ele_nod(e,2),2)];
        p1=plot(x,y,'--k','LineWidth',2)
        p1.Color(4) = 0.5;
        pbaspect([ratio_plot 1 1]);
        hold on
    end
    
    displa_elx=zeros(num_ele,1);
    for e=1:num_ele
        displa_ely(e,1)=0.5*displacement((ele_nod(e,1)-1)*2+2,1)+0.5*displacement((ele_nod(e,2)-1)*2+2,1);
    end
    
    % deformed truss plot
    dispmax=-1000000000.0;
    dispmin=10000000000.0;
    for e=1:num_ele
        valdisp=displa_ely(e);
        if valdisp>dispmax
            dispmax=valdisp;
        end
        if valdisp<dispmin
            dispmin=valdisp;
        end
        
    end
    
    cmap = jet(100);
    
    for e=1:num_ele
        valdisp=displa_ely(e);
        if (dispmax-dispmin)>0
            indcolor=floor(99-98*(dispmax-valdisp)/(dispmax-dispmin))+1;
        else
            indcolor=50;
        end
        
        x=[nod_coor_def(ele_nod(e,1),1) nod_coor_def(ele_nod(e,2),1)];
        y=[nod_coor_def(ele_nod(e,1),2) nod_coor_def(ele_nod(e,2),2)];
        p2=plot(x,y,'color',cmap(indcolor,:),'LineWidth',5)
        p2.Color(4) = 0.75;
        %mycolormap2 = customcolormap([0 .25 .5 .75 1], {'#9d0142','#f66e45','#ffffbb','#65c0ae','#5e4f9f'});
    
        hold on
    end
    
    %pintar flechas de fuerzas
    maxforce=0;
    for e=1:num_nod
        if abs(force(e))>maxforce
            maxforce=abs(force(e))
        end
    end
    for e=1:num_nod
        prefx=nod_coor_def(e,1)
        prefy=nod_coor_def(e,2)
        if ((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5>0
            indsize=((((force_ini((e-1)*2+1)^2)+(force_ini((e-1)*2+2))^2)^0.5)/maxforce)^0.25
            q=quiver(prefx,prefy, force_ini((e-1)*2+1)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,force_ini((e-1)*2+2)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15)
            q.Color = 'k';
        end
    end
    
    %pintar reaccion
    freact=force-force_ini;
    for e=1:num_nod
        prefx=nod_coor_def(e,1)
        prefy=nod_coor_def(e,2)
        if ((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5 >0
            indsize=((((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5)/maxforce)^0.25
            q=quiver(prefx,prefy, freact((e-1)*2+1)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,freact((e-1)*2+2)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15)
            q.Color ='r'%[0.75, 0, 0.75];
           % text(prefx,prefy,num2str(((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,1),'FontSize',15)
        end
    end
    
    % TODO meter flechas moradas con el peso propio
    
    colormap(cmap)
    char1=num2str(dispmin+0*(dispmax-dispmin),1);
    char2=num2str(dispmin+0.25*(dispmax-dispmin),1);
    char3=num2str(dispmin+0.5*(dispmax-dispmin),1);
    char4=num2str(dispmin+0.75*(dispmax-dispmin),1);
    char5=num2str(dispmin+1*(dispmax-dispmin),1);
    c = colorbar('southoutside','Ticks', [0, 0.25, 0.5, 0.75, 1],'TickLabels',{char1, char2, char3, char4, char5});
    c.Label.String = 'Desplazamientos y (mm)';
    c.FontSize = 10; 
    
    hold off
    
    
    
    figure('NumberTitle', 'off', 'Name', 'Energía elástica');
    % undeformed truss plot
    for e=1:num_ele
        x=[nod_coor(ele_nod(e,1),1) nod_coor(ele_nod(e,2),1)];
        y=[nod_coor(ele_nod(e,1),2) nod_coor(ele_nod(e,2),2)];
        p1=plot(x,y,'--k','LineWidth',2)
        p1.Color(4) = 0.5;
        pbaspect([ratio_plot 1 1])
        hold on
    end
    
    % deformed truss plot
    strmax=-1000000000.0;
    strmin=10000000000.0;
    for e=1:num_ele
        valstr=0.5*stress(e)*stress(e)*L(e)*A(e)/E(e);
        if valstr>strmax
            strmax=valstr;
        end
        if valstr<strmin
            strmin=valstr;
        end
        
    end
    
    cmap = jet(100);
    
    for e=1:num_ele
        valstr=0.5*stress(e)*stress(e)*L(e)*A(e)/E(e);
        if (strmax-strmin)>0
            indcolor=floor(99-98*(strmax-valstr)/(strmax-strmin))+1;
        else
            indcolor=50;
        end
        
        x=[nod_coor_def(ele_nod(e,1),1) nod_coor_def(ele_nod(e,2),1)];
        y=[nod_coor_def(ele_nod(e,1),2) nod_coor_def(ele_nod(e,2),2)];
        p2=plot(x,y,'color',cmap(indcolor,:),'LineWidth',5)
        p2.Color(4) = 0.75;
        %mycolormap2 = customcolormap([0 .25 .5 .75 1], {'#9d0142','#f66e45','#ffffbb','#65c0ae','#5e4f9f'});
    
        hold on
    end
    
    %pintar flechas de fuerzas
    maxforce=0;
    for e=1:num_nod
        if abs(force(e))>maxforce
            maxforce=abs(force(e))
        end
    end
    for e=1:num_nod
        prefx=nod_coor_def(e,1)
        prefy=nod_coor_def(e,2)
        if ((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5>0
            indsize=((((force_ini((e-1)*2+1)^2)+(force_ini((e-1)*2+2))^2)^0.5)/maxforce)^0.25
            q=quiver(prefx,prefy, force_ini((e-1)*2+1)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,force_ini((e-1)*2+2)/((force_ini((e-1)*2+1)^2)+abs(force_ini((e-1)*2+2))^2)^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15)
            q.Color = 'k';
        end
    end
    
    %pintar reaccion
    freact=force-force_ini;
    for e=1:num_nod
        prefx=nod_coor_def(e,1)
        prefy=nod_coor_def(e,2)
        if ((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5 >0
            indsize=((((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5)/maxforce)^0.25
            q=quiver(prefx,prefy, freact((e-1)*2+1)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,freact((e-1)*2+2)/((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,indsize*magni_flechas,'LineWidth',5,'MaxHeadSize',15)
            q.Color ='r'%[0.75, 0, 0.75];
           % text(prefx,prefy,num2str(((freact((e-1)*2+1)^2)+(freact((e-1)*2+2)^2))^0.5,1),'FontSize',15)
        end
    end
    
    % TODO meter flechas moradas con el peso propio
    
    colormap(cmap)
    char1=num2str(strmin+0*(strmax-strmin),1);
    char2=num2str(strmin+0.25*(strmax-strmin),1);
    char3=num2str(strmin+0.5*(strmax-strmin),1);
    char4=num2str(strmin+0.75*(strmax-strmin),1);
    char5=num2str(strmin+1*(strmax-strmin),1);
    c = colorbar('southoutside','Ticks', [0, 0.25, 0.5, 0.75, 1],'TickLabels',{char1, char2, char3, char4, char5});
    c.Label.String = 'Energía Elástica (Nmm)';
    c.FontSize = 10; 
    
    hold off
end