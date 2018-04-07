datasplit_balanced_all

features = [1:47];

t = traindata(:,1);
p1 = (traindata(:,2:columns(traindata)))(:,features);
p2 = (valdata(:,2:columns(traindata)))(:,features);

w = zeros(1, columns(p1));
b = 0;
lr_w = 1;
lr_b = 1;
loops = 1000;
whist = zeros(loops, columns(p1));
ahist = zeros(loops, 2);
bhist = zeros(loops, 1);
best_accuracy = 0;
best_w = w;
best_b = b;
for i = 1:loops
  a = hardlims(sum((repmat(w, rows(p1), 1).*p1)+b,2));
  w = w + lr_w.*sum((repmat(t, 1, columns(a)).-a).*p1);
  b = b + lr_b.*sum((repmat(t, 1, columns(a)).-a));
  whist(i, :) = w;
  bhist(i, :) = b;
  accuracy = sum(a==t)/rows(t);
  if accuracy > best_accuracy
    best_accuracy = accuracy;
    best_w = w;
    best_b = b;
  endif
  ahist(i, 1) = accuracy;
  ahist(i, 2) = best_accuracy;
endfor
w = best_w;
b = best_b;
features
disp("training complete, weights:")
w
b
disp("accuracy for training only dataset: ")
accuracy

t = cat(1, traindata, valdata)(:,1);
p = (cat(1, traindata, valdata)(:,2:columns(traindata)))(:,features);

a = hardlims(sum((repmat(w, rows(p), 1).*p)+b,2));

disp("accuracy with training and val datasets:")
accuracy = sum(a==t)/rows(t)


t = cat(1, traindata, valdata, testdata)(:,1);
p = (cat(1, traindata, valdata, testdata)(:,2:columns(traindata)))(:,features);

a = hardlims(sum((repmat(w, rows(p), 1).*p)+b,2));

disp("accuracy with training, val, and test datasets:")
accuracy = sum(a==t)/rows(t)

plot(1:loops, whist(:,1:5))
title("weights");
legend("1","2","3","4","5");

figure
plot(1:loops, whist(:,11:15))
title("weights");
legend("11","12","13","14","15");

figure
plot(1:loops, whist(:,21:25))
title("weights");
legend("21","22","23","24","25");

figure
plot(1:loops, whist(:,31:35))
title("weights");
legend("31","32","33","34","35");

figure
plot(1:loops, whist(:,41:44))
title("weights");
legend("41","42","43","44");
figure
plot(1:loops, whist(:,6:10))
title("weights");
legend("6","7","8","9","10");

figure
plot(1:loops, whist(:,16:20))
title("weights");
legend("16","17","18","19","20");

figure
plot(1:loops, whist(:,26:30))
title("weights");
legend("26","27","28","29","30");

figure
plot(1:loops, whist(:,36:40))
title("weights");
legend("36","37","38","39","40");

figure
plot(1:loops, whist(:,45:47))
title("weights");
legend("45","46","47");

figure
plot(1:loops, bhist)
title("bias");
figure
plot(1:loops, ahist)
title("accuracy");