datasplit_balanced_all

features = [2 3 4 7 8 9 14 16 21 22 23 24 25 26 27 28 29 30 31 33 38 40];

t = traindata(:,1);
p1 = (traindata(:,2:columns(traindata)))(:,features);

w = (2*rand(1, columns(p1)))-1;
b = (2*rand(1,1))-1;
lr_w = 1;
lr_b = 1;
loops = 10000;
whist = zeros(loops, columns(p1));
ahist = zeros(loops, 4);
bhist = zeros(loops, 1);
best_accuracy = 0;
best_w = w;
best_b = b;

for i = 1:loops
  
  if mod(i, loops/100) == 0
    disp(floor(i/loops*100))
    fflush(stdout);
  endif
  
  a = hardlims(sum((repmat(w, rows(p1), 1).*p1)+b,2));
  w = w + lr_w.*sum((repmat(t, 1, columns(a)).-a).*p1);
  b = b + lr_b.*sum((repmat(t, 1, columns(a)).-a));
  whist(i, :) = w;
  bhist(i, :) = b;
  
  accuracy = sum(or(and(a==1, t==1),and(a==-1, t==-1)))/rows(t);
  sensitivity = sum(and(a==1, t==1))/sum(t==1);
  specificity = sum(and(a==-1, t==-1))/sum(t==-1);
  
  if accuracy > best_accuracy
    best_accuracy = accuracy;
    best_w = w;
    best_b = b;
  endif
  ahist(i, 1) = accuracy;
  ahist(i, 2) = best_accuracy;
  ahist(i, 3) = sensitivity;
  ahist(i, 4) = specificity;
endfor
w = best_w;
b = best_b;
loops
features
disp("training complete, weights:")
w
b
disp("training only dataset: ")
accuracy = sum(or(and(a==1, t==1),and(a==-1, t==-1)))/rows(t)
sensitivity = sum(and(a==1, t==1))/sum(t==1)
specificity = sum(and(a==-1, t==-1))/sum(t==-1)

t = cat(1, traindata, valdata)(:,1);
p = (cat(1, traindata, valdata)(:,2:columns(traindata)))(:,features);

a = hardlims(sum((repmat(w, rows(p), 1).*p)+b,2));

disp("training and val datasets:")
accuracy = sum(or(and(a==1, t==1),and(a==-1, t==-1)))/rows(t)
sensitivity = sum(and(a==1, t==1))/sum(t==1)
specificity = sum(and(a==-1, t==-1))/sum(t==-1)


t = cat(1, traindata, valdata, testdata)(:,1);
p = (cat(1, traindata, valdata, testdata)(:,2:columns(traindata)))(:,features);

a = hardlims(sum((repmat(w, rows(p), 1).*p)+b,2));

disp("training, val, and test datasets:")
accuracy = sum(or(and(a==1, t==1),and(a==-1, t==-1)))/rows(t)
sensitivity = sum(and(a==1, t==1))/sum(t==1)
specificity = sum(and(a==-1, t==-1))/sum(t==-1)

figure
plot(1:loops, whist)
title("weights");
%legend( "2, TMAX",
%        "3, TMIN ",
%        "26, TRANGE",
%        "28, TMIN DIFF");

figure
plot(1:loops, bhist)
title("bias");
figure
plot(1:loops, ahist(:,1:2))
title("accuracy");
legend("Accuracy", "Best accuracy");

figure
plot(1:loops, ahist(:,3:4))
title("Specificity and Sensitivity");
legend("Sensitivity", "Specificity");