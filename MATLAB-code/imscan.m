function imscan (net,im)
close all
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% PARAMETERS
SCAN_FOLDER = 'imscan/';
UT_FOLDER = 'imscan/under-thresh/';
TEMPLATE1 = 'template1.png';      
TEMPLATE2 = 'template2.png';      
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
warning off;
delete ([UT_FOLDER,'*.*']);
delete ([SCAN_FOLDER,'*.*']);
[m, n]=size(im);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% First Section
C1 = mminmax(double(im));
C2 = mminmax(double(imread (TEMPLATE1)));
C3 = mminmax(double(imread (TEMPLATE2)));
Corr_1 = double(conv2 (C1,C2,'same'));
Corr_2 = double(conv2 (C1,C3,'same'));
Cell.state = int8(imregionalmax(Corr_1) | imregionalmax(Corr_2));
Cell.state(1:13,:)=-1;
Cell.state(end-13:end,:)=-1;
Cell.state(:,1:9)=-1;
Cell.state(:,end-9:end)=-1;
Cell.net = ones(m,n)*-1;
[LUTm, LUTn]= find(Cell.state == 1);
imshow(im);
hold on
plot(LUTn,LUTm,'.y');pause(0.01);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Second Section
xo = [-1,-1,-1, 0, 0,+1,+1,+1]; %offset
yo = [-1, 0,+1,-1,+1,-1, 0,+1]; %offset
while (1==1)
    [y, x] = find(Cell.state==1,1);
    if isempty(y)
        break;
    end
    imcut = im(y-13:y+13,x-9:x+8);
    Cell.state(y,x) = -1;
    Cell.net(y,x) = svmclassify(net,im2vec(imcut)');    
    if (Cell.net(y,x) == 1)
        plot(x,y,'.g','MarkerSize',15);pause(0.01);
        for k=1:8
            nx = x + xo(k);
            ny = y + yo(k);
            if (Cell.state(ny,nx) ~= -1)
                Cell.state(ny,nx) = 1;
            end
        end
    else
        plot(x,y,'.r');pause(0.01);                        
    end          
end

function output = mminmax(input)

max_ = max(max(input));
min_ = min(min(input));

output = ((input-min_)/(max_-min_) - 0.5) * 2;