datasplit_unscaled

features = [2,3,16];

t = cat(1, traindata, valdata, testdata)(:,1);
p = (cat(1, traindata, valdata, testdata)(:,2:columns(traindata)))(:,features);

w = (2*rand(1, columns(p)))-1;
b = (2*rand(1,1))-1;
lr_w = 1;
lr_b = 1;
loops = 5000;
whist = zeros(loops, columns(p));
ahist = zeros(loops, 3);
bhist = zeros(loops, 1);

for i = 1:loops

  if mod(i, loops/100) == 0
    disp(floor(i/loops*100))
    fflush(stdout);
  endif
  
  a = hardlims(sum((repmat(w, rows(p), 1).*p)+b,2));
  w = w + lr_w.*sum((repmat(t, 1, columns(a)).-a).*p);
  b = b + lr_b.*sum((repmat(t, 1, columns(a)).-a));
  
  whist(i, :) = w;
  bhist(i, :) = b;
  
  accuracy = sum(or(and(a==1, t==1),and(a==-1, t==0)))/rows(t);
  sensitivity = sum(and(a==1, t==1))/sum(t==1);
  specificity = sum(and(a==-1, t==0))/sum(t==0);

  ahist(i, 1) = accuracy;
  ahist(i, 2) = sensitivity;
  ahist(i, 3) = specificity;
endfor
loops
features
disp("training complete, weights:")
w
b
disp("accuracy for all data: ")
accuracy
sensitivity
specificity

figure
plot(1:loops, whist)
title("weights");
legend(pos="northwest", "2, TMAX","3, TMIN ","16, PREV PRCP");

figure
plot(1:loops, bhist)
title("bias");

figure
plot(1:loops, ahist)
title("Accuracy");
legend("Accuracy","Sensitivity","Specificity");