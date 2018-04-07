datasplit_balanced

features = [16];

t = traindata(:,16);
t2 = traindata(:,2);
p1 = (traindata(:,3:columns(traindata)))(:,features);
p2 = (valdata(:,3:columns(traindata)))(:,features);

w = zeros(1, columns(p1));
b = 0;
lr_w = 0.00003;
lr_b = 0.00003;
loops = 200;
whist = zeros(loops, columns(p1));
ahist = zeros(loops, 1);
bhist = zeros(loops, 1);
for i = 1:loops
  for ii = 1:rows(p1)
    a = sum(w.*p1(ii))+b;
    w = w + ((2.*lr_w.*(t(ii)-a).^2).*p1(ii));
    b = b + (2.*lr_b.*(t(ii)-a).^2);
  endfor
  whist(i, :) = w;
  bhist(i, :) = b;
  accuracy = sum((a>0)==t2)/rows(t2);
  ahist(i, 1) = accuracy;
endfor
features
disp("training complete, weights:")
w
b
disp("accuracy for training only dataset: ")
accuracy

t = cat(1, traindata, valdata)(:,2);
p = (cat(1, traindata, valdata)(:,3:columns(traindata)))(:,features);

a = sum((repmat(w, rows(p), 1).*p)+b,2);

disp("accuracy with training and val datasets:")
accuracy = sum((a>0)==t)/rows(t);


t = cat(1, traindata, valdata, testdata)(:,2);
p = (cat(1, traindata, valdata, testdata)(:,3:columns(traindata)))(:,features);

a = sum((repmat(w, rows(p), 1).*p)+b,2);

disp("accuracy with training, val, and test datasets:")
accuracy = sum((a>0)==t)/rows(t);

figure
plot(1:loops, whist)
title("weights");
figure
plot(1:loops, bhist)
title("bias");
figure
plot(1:loops, ahist(:,1))
title("accuracy");
