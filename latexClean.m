function newFilename = latexClean(filename,SUFFIX)
[fp,fn,fe] = fileparts(filename);
if ~SUFFIX
    fn = [fn,fe];
    fe = [];
end
fn = strrep(fn, '.', '_');
newFilename = fullfile(fp,[fn,fe]);