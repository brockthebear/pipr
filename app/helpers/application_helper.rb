module ApplicationHelper   
  
  # Returns the full title on a per-page basis.
  def full_title (page_title = '')        # Method def, optional tag
    base_title = "pipr"                   # Variable assignment
    if page_title.empty?                  # Boolean test
      base_title                          # Implicit title
    else
      "#{page_title} | #{base_title}"     # String interpolation
    end
  end
end
