%masking noise injection for skull models with voxel resolution of 60x60x60
data_path='F:\MAT\data-workflow\skull-mat\60';

phases = {'test'}; %noise injection is only applied on the testing set

for t = 1 : numel(phases)

	phase=phases{t};

	mat_list =[data_path '\' phase];

	mat_files=dir(fullfile(mat_list, '*.mat'));

	for i = 1: length(mat_files)
		%assuring only .mat files are processed
        if strcmp(mat_files(i).name, '.') || strcmp(mat_files(i).name, '..') || mat_files(i).isdir == 1 || ~strcmp(mat_files(i).name(end-2:end), 'mat')
            continue;
        end

        filename = [mat_list '\' mat_files(i).name];

		load(filename, 'instance');
		defected=instance(:,:,:);
        
        enough=0;
        while enough == 0
        	%choosing the coordinates in the model where to remove the voxel cube [bb,cc,dd]
			bb = randperm(60,1);
			cc = randperm(60,1) ;
			%dd = randperm(30,1) ;
			dd = randi([24 60],1,1);

			%selecting the dimensions of the cube. possible dimensions: 10x10x10, 12x12x12, 14x14x14 and 16x16x16
			even=1;
			while even~=0
				cube_dim= randi([10 16],1,1);
				even=rem(cube_dim,2);
				disp(cube_dim);
			end
            
            fprintf('1. cube_dim %d \n', cube_dim);
			%placing the cube in the selected model location
			if cube_dim==16 %cube dimensions:16x16x16
			    if bb+16>60
			     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5, bb-6, bb-7, bb-8, bb-9, bb-10, bb-11, bb-12, bb-13, bb-14, bb-15, bb-16];
			    else
			     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5, bb+6, bb+7, bb+8, bb+9, bb+10, bb+11, bb+12, bb+13, bb+14, bb+15, bb+16];
			    end

			    if cc+16>60
			     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5, cc-6, cc-7, cc-8, cc-9, cc-10, cc-11, cc-12, cc-13, cc-14, cc-15, cc-16];
			    else
			     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5, cc+6, cc+7, cc+8, cc+9, cc+10, cc+11, cc+12, cc+13, cc+14, cc+15, cc+16];
			    end

			    if dd+16>60
			     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5, dd-6, dd-7, dd-8, dd-9, dd-10, dd-11, dd-12, dd-13, dd-14, dd-15, dd-16];
			    else
			     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5, dd+6, dd+7, dd+8, dd+9, dd+10, dd+11, dd+12, dd+13, dd+14, dd+15, dd+16];
			    end
			end


			if cube_dim==14 %cube dimensions:14x14x14
			    if bb+14>60
			     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5, bb-6, bb-7, bb-8, bb-9, bb-10, bb-11, bb-12, bb-13, bb-14];
			    else
			     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5, bb+6, bb+7, bb+8, bb+9, bb+10, bb+11, bb+12, bb+13, bb+14];
			    end

			    if cc+14>60
			     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5, cc-6, cc-7, cc-8, cc-9, cc-10, cc-11, cc-12, cc-13, cc-14];
			    else
			     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5, cc+6, cc+7, cc+8, cc+9, cc+10, cc+11, cc+12, cc+13, cc+14];
			    end

			    if dd+14>60
			     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5, dd-6, dd-7, dd-8, dd-9, dd-10, dd-11, dd-12, dd-13, dd-14];
			    else
			     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5, dd+6, dd+7, dd+8, dd+9, dd+10, dd+11, dd+12, dd+13, dd+14];
			    end
			end


			if cube_dim==12 %cube dimensions:12x12x12
			    if bb+12>60
			     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5, bb-6, bb-7, bb-8, bb-9, bb-10, bb-11, bb-12];
			    else
			     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5, bb+6, bb+7, bb+8, bb+9, bb+10, bb+11, bb+12];
			    end

			    if cc+12>60
			     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5, cc-6, cc-7, cc-8, cc-9, cc-10, cc-11, cc-12];
			    else
			     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5, cc+6, cc+7, cc+8, cc+9, cc+10, cc+11, cc+12];
			    end

			    if dd+12>60
			     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5, dd-6, dd-7, dd-8, dd-9, dd-10, dd-11, dd-12];
			    else
			     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5, dd+6, dd+7, dd+8, dd+9, dd+10, dd+11, dd+12];
			    end
			end


			if cube_dim==10 %cube dimensions:10x10x10
			    if bb+10>60
			     b = [bb,bb-1, bb-2, bb-3, bb-4, bb-5, bb-6, bb-7, bb-8, bb-9, bb-10];
			    else
			     b = [bb,bb+1, bb+2, bb+3, bb+4, bb+5, bb+6, bb+7, bb+8, bb+9, bb+10];
			    end

			    if cc+10>60
			     c = [cc,cc-1, cc-2, cc-3, cc-4, cc-5, cc-6, cc-7, cc-8, cc-9, cc-10];
			    else
			     c = [cc,cc+1, cc+2, cc+3, cc+4, cc+5, cc+6, cc+7, cc+8, cc+9, cc+10];
			    end

			    if dd+10>60
			     d = [dd,dd-1, dd-2, dd-3, dd-4, dd-5, dd-6, dd-7, dd-8, dd-9, dd-10];
			    else
			     d = [dd,dd+1, dd+2, dd+3, dd+4, dd+5, dd+6, dd+7, dd+8, dd+9, dd+10];
			    end
			end

			soma=sum(sum(sum(instance(b,c,d) == 1))); %count the number of voxels that will be cut away from the skull model by the cube
            fprintf('2. soma %d \n', soma);
            fprintf('3. filename %s \n', filename);
			if soma<200 %if the number of voxels to be cut is less than 200, generate another cube until the condition of more than 200 voxels to cut is met
                %fprintf('4. hey %d \n', enough);
                continue;
            end
            enough=1;
        end

		defected(b,c,d) = 0; %cut the cube from the skull model
		save(filename, 'instance','defected'); %save the intact skull and the resultant artificially corrupted skull model in the same .mat file but in different variables
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