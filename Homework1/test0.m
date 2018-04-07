data = csvread("data20.csv");
 
p = data(:,1);
t = data(:,2);

w = 0 

for i = 1:10
  i
  a = hardlim(w .* p);
  sum(a == t)/rows(a)
  w = sum((t.-a).*p)
endfor