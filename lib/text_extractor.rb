class TextExtractor
  require 'mime/types'
  require 'pdf-reader'
  require 'docx'
  require 'zip'
  require 'sanitize'
  require 'rtf'

  class << self
    def extract_text_from_any_file(file_path)
      # Extract file type
      file_type = detect_file_type(file_path)
      ext = File.extname(file_path).downcase
      
      case file_type
      when /msword/
        extract_text_from_word_doc(file_path)
      when "application/pdf"
        extract_text_from_pdf(file_path)
      when "text/html", "text/htm"
        extract_text_from_html(file_path)
      when "text/rtf"
        extract_text_from_rtf(file_path)
      when "application/x-zip", "application/zip"
        extract_text_from_zip(file_path)
      when "text/plain"
        File.read(file_path)
      else
        # Try based on file extension
        case ext
        when '.pdf'
          extract_text_from_pdf(file_path)
        when '.doc', '.docx'
          extract_text_from_word_doc(file_path)
        when '.rtf'
          extract_text_from_rtf(file_path)
        when '.html', '.htm'
          extract_text_from_html(file_path)
        when '.odt'
          extract_text_from_odt(file_path)
        when '.txt'
          File.read(file_path)
        else
          # Last resort: try to read as text
          begin
            content = File.read(file_path)
            if content.encoding == Encoding::ASCII_8BIT
              Rails.logger.warn("Binary file detected, cannot extract text: #{file_path}")
              return ""
            else
              content
            end
          rescue => e
            Rails.logger.error("Failed to read file as text: #{e.message}")
            return ""
          end
        end
      end
    end

    def extract_text_from_pdf(pdf_path)
      begin
        reader = PDF::Reader.new(pdf_path)
        text = ""
        
        reader.pages.each do |page|
          text += page.text + "\n"
        end
        
        # Clean up the text - remove excessive whitespace and normalize line endings
        text.gsub(/\s+/, ' ').strip
      rescue => e
        Rails.logger.error("Error extracting text from PDF #{pdf_path}: #{e.message}")
        # Fallback to shell command if Ruby method fails
        `pdftotext -eol unix -nopgbrk #{pdf_path} 2>& 1`
      end
    end

    def extract_text_from_word_doc(doc_path)
      ext = File.extname(doc_path).downcase
      
      case ext
      when '.docx'
        extract_text_from_docx(doc_path)
      when '.doc'
        extract_text_from_doc(doc_path)
      else
        # Fallback to shell command for unknown formats
        `antiword #{doc_path} 2>& 1`
      end
    end

    def extract_text_from_docx(docx_path)
      begin
        doc = Docx::Document.open(docx_path)
        text = ""
        
        doc.paragraphs.each do |paragraph|
          text += paragraph.text + "\n"
        end
        
        # Clean up the text
        text.gsub(/\s+/, ' ').strip
      rescue => e
        Rails.logger.error("Error extracting text from DOCX #{docx_path}: #{e.message}")
        # Fallback to shell command
        `antiword #{docx_path} 2>& 1`
      end
    end

    def extract_text_from_doc(doc_path)
     `antiword #{doc_path} 2>& 1`
    end

    def extract_text_from_html(file_path)
      content = File.read(file_path)
      Sanitize.clean(content)
    end

    def extract_text_from_rtf(file_path)
      # Try Ruby-based RTF parsing first
      begin
        rtf = RTF::Parser.new
        content = File.read(file_path)
        text = rtf.parse(content)
        text.gsub(/\s+/, ' ').strip
      rescue => e
        Rails.logger.warn("Ruby RTF parsing failed: #{e.message}")
        # Fallback to shell command
        `unrtf -n --text -P /usr/local/lib/unrtf/ #{file_path} 2>& 1`
      end
    end

    def extract_text_from_odt(file_path)
      begin
        Zip::File.open(file_path) do |zip_file|
          content_entry = zip_file.find_entry('content.xml')
          if content_entry
            content = content_entry.get_input_stream.read
            # Basic XML parsing to extract text
            text = content.gsub(/<[^>]*>/, ' ').gsub(/\s+/, ' ').strip
            return text
          end
        end
      rescue => e
        Rails.logger.error("Error extracting text from ODT #{file_path}: #{e.message}")
      end
      
      return ""
    end

    def extract_text_from_zip(file_path)
      # Handle various ZIP-based formats (DOCX, ODT, etc.)
      ext = File.extname(file_path).downcase
      
      case ext
      when '.docx'
        extract_text_from_docx(file_path)
      when '.odt'
        extract_text_from_odt(file_path)
      else
        # Try to extract as generic ZIP and look for common document files
        begin
          Zip::File.open(file_path) do |zip_file|
            # Look for common document files
            ['word/document.xml', 'content.xml', 'document.xml'].each do |entry_name|
              entry = zip_file.find_entry(entry_name)
              if entry
                content = entry.get_input_stream.read
                text = content.gsub(/<[^>]*>/, ' ').gsub(/\s+/, ' ').strip
                return text
              end
            end
          end
        rescue => e
          Rails.logger.error("Error extracting text from ZIP #{file_path}: #{e.message}")
        end
        
        return ""
      end
    end

    def detect_file_type(path)
      # Use Ruby's built-in MIME type detection based on file extension
      ext = File.extname(path).downcase
      case ext
      when '.pdf'
        'application/pdf'
      when '.doc'
        'application/msword'
      when '.docx'
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      when '.rtf'
        'text/rtf'
      when '.txt'
        'text/plain'
      when '.html', '.htm'
        'text/html'
      when '.odt'
        'application/vnd.oasis.opendocument.text'
      when '.zip'
        'application/zip'
      when '.xls'
        'application/vnd.ms-excel'
      when '.xlsx'
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      else
        # Try to read first few bytes to detect binary vs text
        begin
          content = File.read(path, 512)
          if content.encoding == Encoding::ASCII_8BIT || content.include?("\x00")
            'application/octet-stream'
          else
            'text/plain'
          end
        rescue
          'application/octet-stream'
        end
      end
    end
  end
end 
