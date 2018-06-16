data_path='F:\MAT\data-workflow\skull-mat\30';

phases = {'train', 'test'};

% for train and test phases
for t = 1 : numel(phases)

		phase=phases{t};

		mat_list =[data_path '\' phase];

		mat_files=dir(fullfile(mat_list, '*.mat'));

		for i = 1: length(mat_files)
					%strcmp = string compare - para assegurar que sao os ficheiros certos
			        if strcmp(mat_files(i).name, '.') || strcmp(mat_files(i).name, '..') || mat_files(i).isdir == 1 || ~strcmp(mat_files(i).name(end-2:end), 'mat')
			            continue;
			        end

			        filename = [mat_list '\' mat_files(i).name];


					%load('100206.mat', 'instance');
					load(filename, 'instance');
					defected=instance(:,:,:);
                    
                    enough=0;
					while enough == 0
							bb = randperm(30,1);
							cc = randperm(30,1) ;
							%dd = randperm(30,1) ;
							dd = randi([13 30],1,1);

							cube_dim= randi([5 8],1,1);
							%disp(cube_dim);
                            
                            fprintf('1. cube_dim %d \n', cube_dim);
							%select a random cube - dimensions:8x8x8
							if cube_dim==8
							    if bb+8>30
							     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5, bb-6, bb-7, bb-8];
							    else
							     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5, bb+6, bb+7, bb+8];
							    end

							    if cc+8>30
							     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5, cc-6, cc-7, cc-8];
							    else
							     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5, cc+6, cc+7, cc+8];
							    end

							    if dd+8>30
							     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5, dd-6, dd-7, dd-8];
							    else
							     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5, dd+6, dd+7, dd+8];
							    end
							end
							%}

							%select a random cube - dimensions:7x7x7
							if cube_dim==7
							    if bb+7>30
							     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5, bb-6, bb-7];
							    else
							     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5, bb+6, bb+7];
							    end

							    if cc+7>30
							     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5, cc-6, cc-7];
							    else
							     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5, cc+6, cc+7];
							    end

							    if dd+7>30
							     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5, dd-6, dd-7];
							    else
							     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5, dd+6, dd+7];
							    end
							end

							%select a random cube - dimensions:6x6x6
							if cube_dim==6
							    if bb+6>30
							     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5, bb-6];
							    else
							     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5, bb+6];
							    end

							    if cc+6>30
							     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5, cc-6];
							    else
							     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5, cc+6];
							    end

							    if dd+6>30
							     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5, dd-6];
							    else
							     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5, dd+6];
							    end
							end


							%select a random cube - dimensions:5x5x5
							if cube_dim==5
							    if bb+5>30
							     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5];
							    else
							     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5];
							    end

							    if cc+5>30
							     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5];
							    else
							     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5];
							    end

							    if dd+5>30
							     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5];
							    else
							     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5 ];
							    end
							end
							%contar o número de 1s que existem no sítio em instance onde ficou o cubo
							    %se for inferior a 5, encontrar outro cubo
							soma=sum(sum(sum(instance(b,c,d) == 1)));
                            fprintf('2. soma %d \n', soma);
                            fprintf('3. filename %s \n', filename);
							if soma<20
                                fprintf('4. hey %d \n', enough);
                                continue;
                            end
                            enough=1;
					end

					defected(b,c,d) = 0;
					save(filename, 'instance','defected');
		end				


end

%{
figure;    
p = isosurface(squeeze(new_instance),0.5) ;
 patch( p,'facecolor',[1 0 0],'edgecolor','none'), camlight;view(3)  

axis equal 
axis on      
lighting gouraud
pause;

close all;
%}