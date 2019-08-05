function IMGDB = loadimages

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
face_folder = 'face/';  %LOCATION OF FACE IMAGES
non_face_folder = 'non-face/'; %LOCATION OF NON-FACE IMAGES
file_ext = '.png';
out_max = 1;  % DESIRED OUTPUT FOR DETECTING A FACE          
out_min = 0; % DESIRED OUTPUT FOR NOT DETECTING A FACE      
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if exist('imgdb.mat','file')
    load imgdb;
else
    IMGDB = cell (3,[]);
end
fprintf ('Loading Faces ');
folder_content = dir ([face_folder,'*',file_ext]);
nface = size (folder_content,1);
for k=1:nface
    string = [face_folder,folder_content(k,1).name];
    image = imread(string);    
    [m n] = size(image);
    if (m~=27 || n~=18)
        continue;
    end
    f=0;
    for i=1:length(IMGDB)
        if strcmp(IMGDB{1,i},string)
            f=1;
        end
    end
    if f==1
        continue;
    end
    fprintf ('.');    
    IM {1} = im2vec (image);    % ORIGINAL FACE IMAGE
    IM {2} = im2vec (fliplr(image));    % MIRROR OF THE FACE 
    IM {3} = im2vec (circshift(image,1)); 
    IM {4} = im2vec (circshift(image,-1));
    IM {5} = im2vec (circshift(image,[0 1]));
    IM {6} = im2vec (circshift(image,[0 -1]));
    IM {7} = im2vec (circshift(fliplr(image),1));
    IM {8} = im2vec (circshift(fliplr(image),-1));
    IM {9} = im2vec (circshift(fliplr(image),[0 1]));
    IM {10} = im2vec (circshift(fliplr(image),[0 -1]));
    for i=1:10
        IMGDB {1,end+1}= string;
        IMGDB {2,end} = out_max;
        IMGDB (3,end) = {IM{i}};
    end    
end
fprintf ('\nLoading non-faces \n');    
folder_content = dir ([non_face_folder,'*',file_ext]);
nnface = size (folder_content,1);
for k=1:nnface
    string = [non_face_folder,folder_content(k,1).name];
    image = imread(string);
    [m n] = size(image);
    if (m~=27 || n~=18)
        continue;
    end
    f=0;
    for i=1:length(IMGDB)
        if strcmp(IMGDB{1,i},string)
            f=1;
        end
    end
    if f==1
        continue;
    end    
    fprintf ('.');
    IM {1} = im2vec (image);
    IM {2} = im2vec (fliplr(image));
    IM {3} = im2vec (flipud(image));
    IM {4} = im2vec (flipud(fliplr(image)));    
    for i=1:4
        IMGDB {1,end+1}= string;
        IMGDB {2,end} = out_min;
        IMGDB (3,end) = {IM{i}};
    end    
end
fprintf('Done.\n');
save imgdb IMGDB;