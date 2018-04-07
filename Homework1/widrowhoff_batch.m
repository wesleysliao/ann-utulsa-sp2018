datasplit_balanced

features = [2    3    4   16   21   25   26   31   33   38];

t = traindata(:,16);
t2 = traindata(:,1);
p1 = (traindata(:,2:columns(traindata)))(:,features);
p2 = (valdata(:,2:columns(traindata)))(:,features);

w = zeros(1, columns(p1));
b = 0;
lr_w = -0.0000001;
lr_b = -0.0000001;
loops = 1000;
whist = zeros(loops, columns(p1));
ahist = zeros(loops, 2);
bhist = zeros(loops, 1);

a = sum((repmat(w, rows(p1), 1).*p1)+b,2);
best_error = sum((t-a).^2);
for i = 1:loops
  
  if mod(i, loops/100) == 0
    disp(floor(i/loops*100))
    fflush(stdout);
  endif
  
  a = sum((repmat(w, rows(p1), 1).*p1)+b,2);
  w = w + (2.*lr_w.*sum(((repmat(t, 1, columns(a)).-a).^2).*p1));
  b = b + (2.*lr_b.*sum((repmat(t, 1, columns(a)).-a).^2));
  whist(i, :) = w;
  bhist(i, :) = b;
  accuracy = sum(abs(t-a)<.05)/rows(t);
%  accuracy = sum((a>-1)==(t>-1))/rows(t);
  error = sum((t-a).^2);
  if error <= best_error
    best_error = error;
  else
    break;
  endif
  
  ahist(i, 1) = error;
endfor
best_error
features
disp("training complete, weights:")
w
b
disp("accuracy for training only dataset: ")
accuracy

t = cat(1, traindata, valdata)(:,16);
p = (cat(1, traindata, valdata)(:,2:columns(traindata)))(:,features);

a = sum((repmat(w, rows(p), 1).*p)+b,2);

disp("accuracy with training and val datasets:")
accuracy = sum(abs(t-a)<.05)/rows(t)

t = cat(1, traindata, valdata, testdata)(:,16);
p = (cat(1, traindata, valdata, testdata)(:,2:columns(traindata)))(:,features);

a = sum((repmat(w, rows(p), 1).*p)+b,2);

disp("accuracy with training, val, and test datasets:")
accuracy = sum(abs(t-a)<.05)/rows(t)

figure
plot(1:loops, whist, 1:loops, bhist)
title("weights + bias");
legend("weights", "bias");
figure
plot(1:loops, ahist(:,1))
title("error");