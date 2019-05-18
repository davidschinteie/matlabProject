img1 = imread('img/19Iunie2016_crop.jpg');
img2 = imread('img/16Sept2018_crop.jpg');
temp = load('img/fisier1.mat');
p1 = temp.set1;
temp = load('img/fisier2.mat');
p2 = temp.set2;

tri = delaunay(p1(:,1),p1(:,2));

verbose =0;

if verbose
    
	figure, imshow(img1), hold on;
	plot(p1(:,1),p1(:,2),'sr','markerSize',4);
	figure(gcf);
	pause(1);
    
	figure, imshow(img2), hold on;
	plot(p2(:,1),p2(:,2),'sr','markerSize',4);
	figure(gcf);
	pause(1);
    
    
	%close all;
    
	%keyboard;
    
	colors = {'c','r','b','o','m','g','k'};
    
    
	for i=1:size(tri,1)
    	figure(1);hold on;
    	indici = [tri(i,1) tri(i,2) tri(i,3) tri(i,1)];
    	xs = p1(indici,1);
    	ys = p1(indici,2);
    	plot(xs,ys,colors{mod(i,7)+1});
   	 
    	figure(2);hold on;
    	%indici = [tri(i,1) tri(i,2) tri(i,3)];
    	xs = p2(indici,1);
    	ys = p2(indici,2);
    	plot(xs,ys,colors{mod(i,7)+1});
	end
    
	figure(1), figure(2);
	%keyboard;
end

close all;
step = 1/50;
contor = 0;
for t = 0:step:1
	%img_t = uint8(zeros(size(img1)));
    img_t = (1-t)*img1 + t*img2;
	for l = 1:size(tri,1)
    	linia = l;
    	A0 = p1(tri(linia,1),:);
    	B0 = p1(tri(linia,2),:);
    	C0 = p1(tri(linia,3),:);
    	A1 = p2(tri(linia,1),:);
    	B1 = p2(tri(linia,2),:);
    	C1 = p2(tri(linia,3),:);
   	 
    	At = (1-t)*A0 + t*A1;
    	Bt = (1-t)*B0 + t*B1;
    	Ct = (1-t)*C0 + t*C1;
   	 
    	xmin = min(min(At(1),Bt(1)),Ct(1));
    	xmax = max(max(At(1),Bt(1)),Ct(1));
    	ymin = min(min(At(2),Bt(2)),Ct(2));
    	ymax = max(max(At(2),Bt(2)),Ct(2));
   	 
    	[x,y] = meshgrid(floor(xmin):floor(xmax),floor(ymin):floor(ymax));
    	x = x(:);
    	y = y(:);
    	in = inpolygon(x,y,[At(1),Bt(1),Ct(1)],[At(2),Bt(2),Ct(2)]);
   	 
    	P = [x(in),y(in)];
   	 
    	T1 = calculeazaTransformarea(A0,B0,C0,At,Bt,Ct);
    	T2 = calculeazaTransformarea(A1,B1,C1,At,Bt,Ct);
   	 
    	for idx=1:size(P,1)
       	 
        	punct = [P(idx,1),P(idx,2)];
       	 
        	P0 = inv(T1)*[punct(1),punct(2),1]';
        	P0 = round(P0);
        	P1 = inv(T2)*[punct(1),punct(2),1]';
        	P1 = round(P1);
       	 
        	culoareP = (1-t)*double(img1(P0(2),P0(1),:)) + t*double(img2(P1(2),P1(1),:));
       	 
        	img_t(punct(2),punct(1),:) = uint8(culoareP);
       	 
    	end
	end
	%figure,imshow(img_t);
	imwrite(img_t,['rezultate\img_' num2str(contor) '.jpg']);
    [A,map] = rgb2ind(img_t,256);
    if contor == 0
        imwrite(A,map,'finalAnimation.gif','gif','LoopCount',inf,'DelayTime',0.35);
    else
        imwrite(A,map,'finalAnimation.gif','gif','WriteMode','append','DelayTime',0.35);
    end
    contor=contor+1;
end

