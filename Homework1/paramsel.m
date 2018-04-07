
t = cat(1, traindata, valdata, testdata)(:,1);
p = (cat(1, traindata, valdata, testdata)(:,2:columns(traindata)));

w =zeros(1, columns(p));
wconverged = zeros(1, columns(p));
b = zeros(1, columns(p));
bconverged = zeros(1, columns(p));
loops = 1000;
whist = zeros(loops, columns(p));
bhist = zeros(loops, columns(p));

learning_rate_w = 1;
learning_rate_b = 1;

for i = 1:loops
  a = hardlims((repmat(w, rows(p), 1).*p) + repmat(b, rows(p), 1));
  wlast = w;
  w = w + (learning_rate_w.*sum((repmat(t, 1, columns(a)).-a).*p));
  wconverged = (wlast == w);
  blast = b;
  b = b + (learning_rate_b.*sum((repmat(t, 1, columns(a)).-a)));
  bconverged = (blast == b);
  whist(i,:)=w;
  bhist(i,:)=b;
  accuracy = sum(a==repmat(t, 1, columns(a)))./rows(t);
endfor

k = cat(1, b, bconverged ,w, wconverged, accuracy, [1:(columns(traindata)-1)]);
[temp, order] = sort(k(5,:));
format short
k = rot90(fliplr(k(:,order)),-1)

plot(1:loops,whist);
