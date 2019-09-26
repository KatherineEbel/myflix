module CategoryHelper
  def category_options
    Category.all.collect { |c| [ c.name, c.id ]}
  end
end