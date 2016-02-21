function convertUnit(tickID, tickIDLabel, a)
h = get(gca,tickIDLabel);
newLabels = cellfun(@(x) num2str(str2num(x)*a), h, 'UniformOutput', false);
set(gca,tickIDLabel,newLabels);
