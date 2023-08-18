function res = test1(input, name)

image = double(input) ./ 255;
[h,w,z ] = size(image);

max_img(:,:) = max(image, [], 3);
min_img(:,:) = min(image, [], 3);

intensity = sum(image,3) ./ 3;
avg_i = sum(sum(intensity)) / h / w;
sita = (sum(sum((intensity-avg_i).^2)) / h /w );
r  = ceil((sita^0.5)*100);

sita_map = sita_filter(intensity, r);
weight = weight_map(intensity, sita_map);

max_img = max_img .* weight;
min_img = min_img .* weight;


max_map = med_filter(max_img, r);
min_map = med_filter(min_img, r);


num = 0;
depth = zeros(h,w);
for i = 1:h
    for j = 1:w
        if sita_map(i,j) >= sita / h / w *r*r
            depth(i,j) = max_map(i,j);
            num = num + 1;
        else
            depth(i,j) = min_map(i,j);
        end

    end
end
de = depth;
figure(1), 
ek=imagesc(de);
axis image
colormap("hot");
saveas(ek,name);
t = exp(-  1.2 .* depth);

for i = 1:h
    for j = 1:w
        if t(i,j) < 0.1
            t(i,j) = 0.1;
        end
    end
end

A = a(image, depth);
ax = sum(A) / 3 ;

res = (image - ax) ./ t + ax;

imwrite(res,[num2str(r) '2.png'])

lumin = res(:,:,1) .* (res(:,:,1) ./ sum(sum(res(:,:,1)))) + res(:,:,2) .* (res(:,:,2) ./ sum(sum(res(:,:,2)))) + res(:,:,3) .* (res(:,:,3) ./ sum(sum(res(:,:,3))));
lumin(:,:) = lumin(:,:) ./ max(max(lumin(:,:)));
edge = lumin - guidedfilter(lumin, lumin, 2, 0.16);

res = res + 1.5 .* edge;


figure(2)
imshow(res)




end

