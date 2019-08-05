function NET = trainnet(IMGDB)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
options = optimset('maxiter',100000);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fprintf('Creating & training the machine ->\n');

T = cell2mat(IMGDB(2,:));
P = cell2mat(IMGDB(3,:));
net = svmtrain(P',T','Kernel_Function','linear','Polyorder',2,'quadprog_opts',options);
fprintf('Number of Support Vectors: %d\n',size(net.SupportVectors,1));
classes = svmclassify(net,P');
fprintf('done. %d \n');
save net net
NET = net;