
%rand("seed", 3);

data = csvread("data_unscaled.csv");

if( sum( data(:,1) ) != 0.5)
  if( (sum( (data(:,1)==1) )/rows(data)) < 0.5)
    truerows = (data(:,1)==1);
    truedata = data(truerows,:);
    truedata = truedata(randperm(rows(truedata)),:);
    
    falsedata = data(not(truerows),:);
    falserows = randperm(rows(falsedata));
    falsedata =  falsedata(falserows(:, 1:sum(truerows)),:);
  else
    falserows = (data(:,1)==-1);
    falsedata = data(falserows,:);
    falsedata = falsedata(randperm(rows(falsedata)),:);
    
    truedata = data(not(falserows),:);
    truerows = randperm(rows(truedata));
    truedata = truedata(truerows(:, 1:sum(falserows)),:);
  endif
endif

randrows = randperm(rows(truedata));

rows(truedata)/rows(falsedata)

trainrows = randrows(:, 1:floor(rows(truedata)/3));
randrows = randrows(:, floor(rows(truedata)/3)+1:end);

valrows = randrows(:, 1:floor(rows(truedata)/3));
randrows = randrows(:, floor(rows(truedata)/3)+1:end);

testrows = randrows;

traindata = cat(1, truedata(trainrows,:), falsedata(trainrows,:));
valdata = cat(1, truedata(valrows,:), falsedata(valrows,:));
testdata = cat(1, truedata(testrows,:), falsedata(testrows,:));