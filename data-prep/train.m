data_path='F:\MAT\data-workflow\skull-mat\30\train';

dest_path='F:\MAT\data-workflow\skull-mat\30\data';

mat_files=dir(fullfile(data_path, '*.mat'));

for i=1 : length(mat_files)

	if strcmp(mat_files(i).name, '.') || strcmp(mat_files(i).name, '..') || mat_files(i).isdir == 1 || ~strcmp(mat_files(i).name(end-2:end), 'mat')
		continue;
    end
	
	filename = [data_path '\' mat_files(i).name];

	load(filename);

	dataset(i, :,:,:) = defected;

	labels(i,:,:,:) = instance;
	
	destname = [dest_path '\train_data.mat'];
	save(destname, 'dataset', 'labels');
end
