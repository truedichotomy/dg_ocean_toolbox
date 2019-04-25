function dg_fn4qt(indir, outdir, infileroot, outfileroot, ext)
% synopsis: function dg_fn4qt(indir, outdir, infileroot, outfileroot)
%
% This routine converts filenames in a directory to a quicktime
% animation friendly format.
%
% Example: dg_fn4qt('/data/glider/','/data/glider/out/','sw06*','qtframe_','jpg')
%

if exist('ext') ~= 1
  ext = 'png';
end %if

if exist('outfileroot') ~= 1
  %outfileroot = 'fig';
  outfileroot = 'sw06_'
end %if

if exist('infileroot') ~= 1
  %infileroot = 'tuvs';
  infileroot = 'sw06'
end %if

if exist('outdir') ~= 1
  %outdir = '/home/donglai/data/figures/AGU2004/divor/raw_qt/';
  outdir = '/www/home/donglai/public_html/njshelf/glider_anim/qt_r100/'
end %if

if exist('indir') ~= 1
  %indir = '/home/donglai/data/figures/AGU2004/divor/raw/';
  indir = '/www/home/donglai/public_html/njshelf/glider_anim/pngs_r100/'
end %if

infiles = dir([indir infileroot '*']);
for ii = 1:length(infiles),
  infile = infiles(ii).name
  inpath = [indir infile];
  outfile = [outfileroot num2str(ii) '.' ext];
  outpath = [outdir outfile];
  copyfile(inpath,outpath);
end %for
