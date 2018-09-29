function off_to_mat(off_path, data_path, volume_size, pad_size)

% Put the mesh object in a volume grid and save the volumetric
% represenation file.
% off_path: root off data folder
% data_path: destination volumetric data folder

phases = {'train', 'test'};
data_size = pad_size * 2 + volume_size;

dest_path = [data_path '\' num2str(data_size)];   

if ~exist(dest_path, 'dir')
    mkdir(dest_path);
end     

% for train and test phases
for t = 1 : numel(phases)
    
    phase = phases{t};
    off_list = [off_path '\' phase];

    dest_tsdf_path = [dest_path '\' phase];
          
    if ~exist(dest_tsdf_path, 'dir')
        mkdir(dest_tsdf_path);
    end
    
    files = dir(fullfile(off_list, '*.off')); 
    
    for i = 1 : length(files) 

        %strcmp = string compare - para assegurar que sao os ficheiros certos
        if strcmp(files(i).name, '.') || strcmp(files(i).name, '..') || files(i).isdir == 1 || ~strcmp(files(i).name(end-2:end), 'off')
            continue;
        end           
        filename = [off_list '\' files(i).name];
        
        
        destname = [dest_tsdf_path '\' files(i).name(1:end-4) '.mat'];
        
        off_data = off_loader(filename);
        instance = polygon2voxel(off_data, [volume_size, volume_size, volume_size], 'auto');
        instance = padarray(instance, [pad_size, pad_size, pad_size]);
        instance = int8(instance);
        save(destname, 'instance');
        
    end
end
