
datasplit_balanced_all

features = [2 3 4 16 21 25 26 31 33 38];

t = traindata(:,16);
p = (traindata(:,2:columns(traindata)))(:,features);

neurons = 25

w = (2*rand(neurons, columns(features), 2))-1;
b = (2*rand(neurons, 1, 2))-1;
a = zeros(neurons, rows(p), 2);
n2 = zeros(rows(p), 1);
s2 = zeros(rows(p), 1);
s1 = zeros(rows(p), neurons);
alpha = 0.00001;
loops = 10000;

hist = zeros(loops, 2);
whist = zeros(loops, columns(p), 4);

best_accuracy = 0;
best_w = w;
best_b = b;

for i = 1:loops
  if mod(i, loops/100) == 0
    disp(floor(i/loops*100))
    fflush(stdout);
  endif
  
  for ii = 1:neurons
    a(ii,:, 1) = logsig(sum(w(ii, :, 1).*p+b(ii,:,1), 2));
    a(ii, :, 2) = w(ii,1,2).*a(ii,:, 1);
  endfor
  
  n2 = rot90( sum(a(:,:,2), 1)+b(1,1,1), -1);
  
  s2 = -2.*(t -n2);
  for ii = 1:neurons
    s1(:,ii) = rot90(((1 - a(ii,:,1)).*a(ii,:,1)),-1).*w(ii,1,2).* s2;
    
    w(ii,:, 2) = w(ii,:, 2) - sum((alpha.*s2).*rot90(a(ii,:,1),-1));
    w(ii,:, 1) = w(ii,:, 1) - sum((alpha.*s1(:,ii)).*rot90(a(ii,:,1),-1));
    b(ii, :, 1) =  b(ii, :, 1) - (alpha*sum(s1(:,ii)));
  endfor
  
  b(1, 1, 1) = b(1, 1, 1) - (alpha*sum(s2));
  
  error = sum((t - n2).^2)/rows(t);
  
%  accuracy = sum((n2>-1)==(t>-1))/rows(t);
  accuracy = sum(abs(t-n2)<.05)/rows(t);
  
  if accuracy > best_accuracy
    best_accuracy = accuracy;
    best_w = w;
    best_b = b;
  endif
  
  whist(i, :, 1) = w(1,:, 1);
  whist(i, :, 2) = w(2,:, 1);
  whist(i, :, 3) = w(1,:, 2);
  whist(i, :, 4) = w(2,:, 2);
  
  
  hist(i,1) = error;
  hist(i,2) = accuracy;

endfor

w = best_w;
b = best_b;

for ii = 1:neurons
  a(ii,:, 1) = logsig(sum(w(ii, :, 1).*p+b(ii,:,1), 2));
  a(ii, :, 2) = w(ii,1,2).*a(ii,:, 1);
endfor

n2 = rot90( sum(a(:,:,2), 1)+b(1,1,1), -1);
accuracy = sum(abs(t-n2)<.05)/rows(t)

features
disp("training complete, weights:")
disp("accuracy for training only dataset: ")
accuracy

t = cat(1, traindata, valdata)(:,16);
p = (cat(1, traindata, valdata)(:,2:columns(traindata)))(:,features);

a = zeros(neurons, rows(p), 2);
n2 = zeros(rows(p), 1);
for ii = 1:neurons
  a(ii,:, 1) = logsig(sum(w(ii, :, 1).*p+b(ii,:,1), 2));
  a(ii, :, 2) = w(ii,1,2).*a(ii,:, 1);
endfor

n2 = rot90( sum(a(:,:,2), 1)+b(1,1,1), -1);
  
disp("accuracy with training and val datasets:")
accuracy = sum(abs(t-n2)<.05)/rows(t)

t = cat(1, traindata, valdata, testdata)(:,16);
p = (cat(1, traindata, valdata, testdata)(:,2:columns(traindata)))(:,features);

a = zeros(neurons, rows(p), 2);
n2 = zeros(rows(p), 1);
for ii = 1:neurons
  a(ii,:, 1) = logsig(sum(w(ii, :, 1).*p+b(ii,:,1), 2));
  a(ii, :, 2) = w(ii,1,2).*a(ii,:, 1);
endfor

n2 = rot90( sum(a(:,:,2), 1)+b(1,1,1), -1);

disp("accuracy with training, val, and test datasets:")
accuracy = sum(abs(t-n2)<.05)/rows(t)

figure
plot(1:loops, hist(:,1));
title("error");
figure
plot(1:loops, hist(:,2));
title("accuracy");
%figure
%plot(1:loops, whist(:,1,:));
%figure
%plot(1:loops, whist(:,2,:));