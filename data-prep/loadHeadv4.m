startDir = 'F:\HealthyMRI\Healthy-MRI-T1\sample'; %gets directory, ou entao especificar o directory

% Get list of all subfolders.
allSubFolders = genpath(startDir);
% Parse into a cell array.
remain = allSubFolders;
% Initialize variable that will contain the list of filenames so that we can concatenate to it.
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames);

% Process all dfs files in those folders.
for k = 1 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
	
	% Get ALL dfs files.
    
    %inner skull
	filePattern_isk = sprintf('%s/*.inner_skull.dfs', thisFolder);
    
	baseFileNames_isk = dir(filePattern_isk);
    numberOfInnerSkullFiles=length(baseFileNames_isk);
    
    %outer skull
	filePattern_osk = sprintf('%s/*.scalp.dfs', thisFolder);
	baseFileNames_osk = dir(filePattern_osk);
   
    numberOfOuterSkullFiles=length(baseFileNames_osk);
    
    if numberOfInnerSkullFiles >=1 && numberOfOuterSkullFiles >=1
        %STATEMENT
        fullFileName_isk = fullfile(thisFolder, baseFileNames_isk(1).name);

        isk = readdfs(fullFileName_isk);

        fullFileName_osk = fullfile(thisFolder, baseFileNames_osk(1).name);

        osk = readdfs(fullFileName_osk);

        %surf2mesh(v,f,p0,p1,keepratio,maxvol,regions,holes,forcebox)
        %inner skull
        tic;
         fprintf('\nSTEP 4:\n Inner Skull \n Volume meshing has started...\n\n');
         [n_isk,e_isk,f_isk]=surf2mesh(isk.vertices,isk.faces,min(isk.vertices(:,1:3))-1,max(isk.vertices(:,1:3))+1,1,100);
         fprintf('\nSTEP 4:\n Meshed volume of Inner Skull has been created!\n\n');
        toc_s2m = toc;

        %outer skull
        tic;
         fprintf('\nSTEP 4:\n Outer Skull \n Volume meshing has started...\n\n');
         [n_osk,e_osk,f_osk]=surf2mesh(osk.vertices,osk.faces,min(osk.vertices(:,1:3))-1,max(osk.vertices(:,1:3))+1,1,100);
         fprintf('\nSTEP 4:\n Meshed volume of Outer Skull has been created!\n\n');
        toc_s2m = toc;

        %merge mesh
        [n_skull,e_skull] = mergemesh(n_isk,e_isk,n_osk,e_osk);

        %plot mesh
        figure;
        plotmesh(n_skull,e_skull);

        %save stl - savestl(node,elem,fname,solidname)
        ix=strfind(baseFileNames_isk(1).name,'.');  % get the underscore locations
        id=baseFileNames_isk(1).name(1:ix(1)-1);     % return the substring up to 2nd underscore

        s1='skull_';
        ext='.stl';
        fileName= strcat(s1,id,ext);
        savestl(n_skull,e_skull,fileName);
    
    else 
        fprintf('     Folder %s has no skull files in it.\n', thisFolder);
    end    
end 




