module ProductsHelper
  def should_checked? id, key
    return true if params[:filters].blank? ||
                   params[:filters][:categories].blank?

    params[:filters][:categories][key]&.include?(id.to_s) == true
  end
end
