module ReviewHelper
  def rating_options
    5.downto(1)
      .map { |rating| ["#{rating} #{'Star'.pluralize(rating)}", rating] }
  end
end