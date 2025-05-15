module ProductsHelper
    def preserved_filters(overrides = {})
        {
        min_price: params[:min_price] || 0, 
        max_price: params[:max_price] || Product.maximum(:price).to_i,
        query:     params[:query],
        tag_id:    params[:tag_id],
        category_id: params[:category_id]
        }.merge(overrides).compact
    end

    def preserved_filter_fields
        max_price = Product.maximum(:price).to_i # Always fetch current max

        hidden_fields = []
        hidden_fields << hidden_field_tag(:min_price, params[:min_price] || 0, id: "search-min-price")
        hidden_fields << hidden_field_tag(:max_price, params[:max_price] || max_price, id: "search-max-price")
        hidden_fields << hidden_field_tag(:category_id, params[:category_id]) if params[:category_id].present?
        hidden_fields << hidden_field_tag(:tag_id, params[:tag_id]) if params[:tag_id].present?
        hidden_fields << hidden_field_tag(:query, params[:query]) if params[:query].present?
        hidden_fields.join.html_safe
    end

    
end

