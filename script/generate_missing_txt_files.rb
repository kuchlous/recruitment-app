$tmp_directory    = RAILS_ROOT + "/" + APP_CONFIG['temp_directory']
$tmp_file         = APP_CONFIG['temp_file']
resumes = Resume.all
resumes.each do |resume|
  txtfile = RAILS_ROOT + "/" + APP_CONFIG['upload_directory'] + "/" + resume.file_name + ".txt"
  if (!File.exists?(txtfile) || File.size(txtfile) < 100)
    puts "Processing: " + resume.name + " : " + resume.file_name
    # resume_files = Dir.glob(RAILS_ROOT + "/" + APP_CONFIG['upload_directory'] + "/" + resume.file_name + '.*')
    # resume_files.each do |f|
    #   puts "Processing: " + f
    #   next if /.txt$/.match f
    #   next if /.html$/.match f
    #   ext = File.extname(f)
    #   fullpathname = File.join($tmp_directory, $tmp_file) + ext
    #   file_type = Resume.read_upload_write_tmp_file(fullpathname, File.open(f, 'r'))
    #   resume.add_html_txt_and_search(ext, file_type)
    #   puts "Resume = " + resume.name + " fullpathname = " + fullpathname + " type = " + file_type
    #   resume.move_temp_file_to_upload_directory
    #   break
    # end
  end
end
