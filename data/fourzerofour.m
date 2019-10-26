% open files
%readall(datastore('tables'))
files = dir('/Users/xtinaushakova/Play/ushi/data/tables');

all = zeros(41, 1);

for file = files'
    new = load(file.name);
    all = cat(2, all, new);
end

all(:,1) = [];